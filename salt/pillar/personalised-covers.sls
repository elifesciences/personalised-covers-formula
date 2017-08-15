personalised_covers:
    api: 'gateway.elife.internal'
    landing_page: 'http://elifesciences.org/cover/%s'
    aws:
        access_key_id: null
        secret_access_key: null
        region: us-east-1
        bucket: 'elife-personalised-covers'

api_dummy:
    standalone: False
    pinned_revision_file: /srv/personalised-covers/api-dummy.sha1

redis:
    port: 6379
    host: localhost
