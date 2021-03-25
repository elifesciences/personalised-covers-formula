personalised_covers:
    gtm_id: GTM-XXXX
    api: 'http://localhost:8080/'
    journal_url: 'https://continuumtest--journal.elifesciences.org/'
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

elife:
    sidecars:
        containers:
            localstack:
                name: localstack
                image: localstack/localstack  # 700 MB!
                tag: 0.9.0
                ports:
                    # S3
                    - "4572:4572"
                environment: 
                    - "SERVICES=s3" 
                    - "DATA_DIR=/tmp/localstack"
                volumes:
                    - "/tmp/localstack:/tmp/localstack"
                healthcheck: "bash -c 'AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake aws --endpoint-url=http://localhost:4572 s3 ls'"
                enabled: true
