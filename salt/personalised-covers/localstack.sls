create-local-s3-simulated-bucket:
    cmd.run:
        - name: aws --endpoint-url=http://localhost:4572 s3 mb s3://{{ pillar.personalised_covers.aws.bucket }}
        - requires:
            - aws-cli
            - docker-compose-localstack-up
