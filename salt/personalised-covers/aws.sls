aws-credentials:
    file.managed:
        - name: /home/{{ pillar.elife.deploy_user.username }}/.aws/credentials
        - source: salt://personalised-covers/config/home-user-.aws-credentials
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - makedirs: True
        - template: jinja
        - require:
            - deploy-user

aws-credentials-webserver:
    file.managed:
        - name: {{ salt['user.info'](pillar.elife.webserver.username).home }}/.aws/credentials
        - source: salt://personalised-covers/config/home-webserver-.aws-credentials
        - user: {{ pillar.elife.webserver.username }}
        - group: {{ pillar.elife.webserver.username }}
        - makedirs: True
        - template: jinja
        - require:
            - deploy-user
