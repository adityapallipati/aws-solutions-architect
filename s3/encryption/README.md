## Create a bucket

```sh
aws s3 mb s3://encryption-fun-ap-12345
```

## Create a file with encryption of SSE-S3

```sh
echo "Hello World!" > hello.txt
aws s3 cp hello.txt s3://encryption-fun-ap-12345
```

## Grab AWS managed key in console

1. Navigate to Key Management Service
2. Grab the S3 AWS Managed Key

## Put Object with encryption of SSE-KMS

```sh
aws s3api put-object \
--bucket encryption-fun-ap-12345 \
--key hello.txt \
--body hello.txt \
--server-side-encryption aws:kms \
--ssekms-key-id YOUR_AWS_MANAGED_KEY
```

# Download hello.txt to confirm you have permissions to access bucket

```sh
aws s3 cp s3://encryption-fun-ap-12345/hello.txt hello.txt
```

## Put Object with encryption of SSE-C [Failed Attempt]

### Create md5 key with openssl and export env variable $BASE64_ENCODED_KEY

```sh
export BASE64_ENCODED_KEY=$(openssl rand -base64 32)
```

### Validate export

```sh
echo $BASE64_ENCODED_KEY
```

### generate md5 and export to $MD5_VALUE

```sh
export MD5_VALUE=$(echo $BASE64_ENCODED_KEY | md5sum | awk '{print $1}' | base64 -w0)
```

### Validate export
```sh
echo $MD5_VALUE
```

### Now attempt put

```sh
aws s3api put-object \
--bucket encryption-fun-ap-12345 \
--key hello.txt \
--body hello.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key $BASE64_ENCODED_KEY \
--sse-customer-md5 $MD5_VALUE
```

## Put Object with SSE-C via AWS S3

### Generate a key
```sh
openssl rand -out ssec.key 32
```
### Upload file to bucket
```sh
aws s3 cp hello.txt s3://encryption-fun-ap-12345/hello.txt \
--sse-c AES256 \
--sse-c-key fileb://ssec.key
```

### Attempt to download file w/o Key

```sh
aws s3 cp s3://encryption-fun-ap-12345/hello.txt hello.txt

```
### Result
```md
fatal error: An error occurred (400) when calling the HeadObject operation: Bad Request
```

### Download file by providing key

```sh
aws s3 cp s3://encryption-fun-ap-12345/hello.txt hello.txt \
--sse-c AES256 \
--sse-c-key fileb://ssec.key
```

### Result (successful download)

```md
download: s3://encryption-fun-ap-12345/hello.txt to ./hello.txt
```
## Clean Up

```sh
../bash-scripts/delete-objects encryption-fun-ap-12345
../bash-scripts/delete-bucket encryption-fun-ap-12345
```