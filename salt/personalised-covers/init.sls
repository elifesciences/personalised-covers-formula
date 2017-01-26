personalised-covers-repository:
    builder.git_latest:
        - name: git@github.com:elifesciences/personalised-covers.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: {{ salt['elife.rev']() }}
        - branch: {{ salt['elife.branch']() }}
        - target: /srv/personalised-covers/
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - fetch_pull_requests: True
        - require:
            - php-composer-1.0
            - php-puli-latest

    file.directory:
        - name: /srv/personalised-covers
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user
            - group
        - require:
            - builder: personalised-covers-repository

# files and directories must be readable and writable by both elife and www-data
# they are both in the www-data group, but the g+s flag makes sure that
# new files and directories created inside have the www-data group
# @source https://github.com/elifesciences/search-formula/blob/master/salt/search/init.sls#L42
personalised-covers-cache:
    file.directory:
        - name: /srv/personalised-covers/var
        - user: {{ pillar.elife.webserver.username }}
        - group: {{ pillar.elife.webserver.username }}
        - dir_mode: 775
        - file_mode: 664
        - recurse:
            - user
            - group
            - mode
        - require:
            - personalised-covers-repository

    cmd.run:
        - name: chmod -R g+s /srv/personalised-covers/var
        - require:
            - file: personalised-covers-cache


personalised-covers-composer-install:
    cmd.run:
        {% if pillar.elife.env in ['prod', 'demo'] %}
        - name: composer1.0 --no-interaction install --classmap-authoritative --no-dev
        {% elif pillar.elife.env in ['ci', 'end2end'] %}
        - name: composer1.0 --no-interaction install --classmap-authoritative
        {% else %}
        - name: composer1.0 --no-interaction install
        {% endif %}
        - cwd: /srv/personalised-covers/
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - personalised-covers-cache


personalised-covers-console-ready:
    cmd.run:
        - name: ./bin/console --env={{ pillar.elife.env }}
        - cwd: /srv/personalised-covers
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - personalised-covers-composer-install

personalised-covers-cache-clean:
    cmd.run:
        - name: ./bin/console cache:clear --env={{ pillar.elife.env }}
        - user: {{ pillar.elife.deploy_user.username }}
        - cwd: /srv/personalised-covers
        - require:
            - personalised-covers-console-ready
            - personalised-covers-cache

personalised-covers-nginx-vhost:
    file.managed:
        - name: /etc/nginx/sites-enabled/personalised-covers.conf
        - source: salt://personalised-covers/config/etc-nginx-sites-enabled-personalised-covers.conf
        - template: jinja
        - require:
            - nginx-config
            - personalised-covers-composer-install
        - listen_in:
            - service: nginx-server-service
            - service: php-fpm

syslog-ng-personalised-covers-logs:
    file.managed:
        - name: /etc/syslog-ng/conf.d/personalised-covers.conf
        - source: salt://personalised-covers/config/etc-syslog-ng-conf.d-personalised-covers.conf
        - template: jinja
        - require:
            - pkg: syslog-ng
            - personalised-covers-composer-install
        - listen_in:
            - service: syslog-ng

logrotate-personalised-covers-logs:
    file.managed:
        - name: /etc/logrotate.d/personalised-covers
        - source: salt://personalised-covers/config/etc-logrotate.d-personalised-covers
        - template: jinja
