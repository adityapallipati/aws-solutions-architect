## Create a new bucket

```sh
aws s3api create-bucket \
--bucket acl-example-ap-12345 \
--region us-east-1
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