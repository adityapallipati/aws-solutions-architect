## Create a new bucket

```sh
aws s3api create-bucket \
--bucket acl-example-ap-12345 \
--region us-east-1
```

## Change bucket ownership

```sh
aws s3api put-bucket-ownership-controls \
--bucket acl-example-ap-12345 \
--ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
```

**Note**: You'll need two AWS Accounts for this demo. This is meant to demonstrate processes that happen across different accounts. **More about ACLs**: [S3 README.md](../README.md).

## Turn off Block Public Access for ACLs

```sh
aws s3api put-public-access-block \
--bucket acl-example-ap-12345 \
--public-access-block-configuration \
"BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

# Verify Change

```sh
aws s3api get-public-access-block --bucket acl-example-ap-12345
```
**Result**

```md
{
    "PublicAccessBlockConfiguration": {
        "BlockPublicAcls": false,
        "IgnorePublicAcls": false,
        "BlockPublicPolicy": true,
        "RestrictPublicBuckets": true
    }
}
```

## Change ACLs to allows for a user in another AWS account

1. Navigate to the Upper Right of your AWS account
2. Click on Security Credentials
3. Copy your Canonical User Id
4. Paste in policy.json canonical user id for Owner tag
5. Add display name of owner (your main aws account)
6. Repeat for your second AWS account
7. Paste in policy.json canonical user id for Grantee tag
8. Add display name of grantee (your second aws account)

[policy.xml](./policy.json)

```json
{
  "Grants": [
    {
      "Grantee": {
        "DisplayName": "YOUR_DISPLAY_NAME",
        "ID": "YOUR_CANONICAL_USER_ID",
        "Type": "CanonicalUser"
      },
      "Permission": "FULL_CONTROL"
    }
  ],
  "Owner": {
    "DisplayName": "YOUR_SECOND_ACCOUNT_DISPLAY_NAME",
    "ID": "YOUR_SECOND_ACCOUNT_CANONICAL_USER_ID"
  }
}
```

```sh
aws s3api put-bucket-acl \
--bucket acl-example-ap-12345 \
--access-control-policy="file:///workspace/aws-solutions-architect/s3/acls/policy.json"
```

## Validate change

1. Go to your second AWS account, try to add a file to the bucket via CLI

```sh
aws s3 ls s3://acl-example-ap-12345
touch hello.txt
aws s3 cp hello.txt s3://acl-example-ap-12345
aws s3 ls s3://acl-example-ap-12345
```

2. Validate the change in your main AWS account

```sh
aws s3 ls s3://acl-example-ap-12345
```

## Clean up

```sh
../bash-scripts/delete-objects acl-example-ap-12345
../bash-scripts/delete-bucket acl-example-ap-12345
```