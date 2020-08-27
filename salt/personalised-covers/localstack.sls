create-local-s3-simulated-bucket:
    cmd.run:
        - name: |
            set -e
            /usr/local/docker-scripts/docker-wait-healthy localstack 240
            aws --endpoint-url=http://localhost:4572 s3 mb s3://{{ pillar.personalised_covers.aws.bucket }}
        - runas: {{ pillar.elife.deploy_user.username }}
        - requires:
            - aws-cli
            - docker-compose-localstack-up
