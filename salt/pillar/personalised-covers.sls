personalised_covers:
    gtm_id: GTM-XXXX
    api: 'http://localhost:8080/'
    landing_page: 'http://elifesciences.org/cover/%s'
    aws:
        access_key_id: null
        secret_access_key: null
        region: us-east-1
        bucket: 'dev-elife-personalised-covers'

api_dummy:
    standalone: False
    pinned_revision_file: /srv/personalised-covers/api-dummy.sha1

redis:
    port: 6379
    host: localhost
