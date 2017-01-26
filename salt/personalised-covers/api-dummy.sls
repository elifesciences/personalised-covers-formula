api-dummy-nginx-vhost-dev:
    file.managed:
        - name: /etc/nginx/sites-enabled/api-dummy-dev.conf
        - source: salt://personalised-covers/config/etc-nginx-sites-enabled-api-dummy-dev.conf
        - require:
            - api-dummy-composer-install
            - personalised-covers-nginx-vhost
        - listen_in:
            - service: nginx-server-service
            - service: php-fpm
