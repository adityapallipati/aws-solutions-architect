## Create a bucket

```sh
aws s3 mb s3://bucket-policy-example-ap-1234
```

## Add bucket policy

```sh
aws s3api put-bucket-policy \
--bucket bucket-policy-example-ap-1234 \
--policy file://./policy.json
```

## Validate the change

1. Check in main AWS account if bucket policy is added to bucket.
2. Navigate to second AWS account and attempt to put objects into bucket.

```sh
aws s3 ls s3://bucket-policy-example-ap-1234
touch hello.txt
aws s3 cp hello.txt s3://bucket-policy-example-ap-1234
aws s3 ls s3://bucket-policy-example-ap-1234
```

## Clean Up

```sh
../bash-scripts/delete-objects bucket-policy-example-ap-1234
../bash-scripts/delete-bucket bucket-policy-example-ap-1234
```
