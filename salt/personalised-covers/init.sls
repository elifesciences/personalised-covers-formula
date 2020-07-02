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
            - install-composer

    file.directory:
        - name: /srv/personalised-covers
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user
            - group
        - follow_symlinks: False # repository has a broken symlink that only resolves itself after 'composer install'
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

personalised-covers-logs:
    file.directory:
        - name: /srv/personalised-covers/var/logs
        - user: {{ pillar.elife.webserver.username }}
        - group: {{ pillar.elife.webserver.username }}
        - dir_mode: 775
        - file_mode: 664
        - recurse:
            - user
            - group
            - mode
        - require:
            - personalised-covers-cache

    cmd.run:
        - name: chmod -R g+s /srv/personalised-covers/var/logs
        - require:
            - file: personalised-covers-cache

personalised-covers-data:
    file.recurse:
      - name: /srv/personalised-covers-data/formats
      - source: salt://personalised-covers/data/formats
      - user: {{ pillar.elife.webserver.username }}
      - group: {{ pillar.elife.webserver.username }}
      - dir_mode: 555
      - file_mode: 444

personalised-covers-config:
    file.managed:
        - name: /srv/personalised-covers/config/config.php
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - source: salt://personalised-covers/config/srv-personalised-covers-config-config.php
        - template: jinja
        - require:
            - personalised-covers-repository

personalised-covers-composer-install:
    cmd.run:
        {% if pillar.elife.env in ['prod', 'end2end'] %}
        - name: composer --no-interaction install --classmap-authoritative --no-dev
        {% elif pillar.elife.env in ['ci'] %}
        - name: composer --no-interaction install --classmap-authoritative
        {% else %}
        - name: composer --no-interaction install
        {% endif %}
        - cwd: /srv/personalised-covers/
        - runas: {{ pillar.elife.deploy_user.username }}
        - require:
            - personalised-covers-config
            - personalised-covers-cache
            - personalised-covers-logs
            - personalised-covers-data

personalised-covers-gen-fonts:
    cmd.run:
        - name: ./bin/font-generator
        - runas: {{ pillar.elife.deploy_user.username }}
        - cwd: /srv/personalised-covers
        - require:
            - personalised-covers-composer-install

personalised-covers-console-ready:
    cmd.run:
        - name: ./bin/console --env={{ pillar.elife.env }}
        - cwd: /srv/personalised-covers
        - runas: {{ pillar.elife.deploy_user.username }}
        - require:
            - personalised-covers-composer-install

personalised-covers-cache-clean:
    cmd.run:
        - name: ./bin/console cache:clear --env={{ pillar.elife.env }}
        - runas: {{ pillar.elife.deploy_user.username }}
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
