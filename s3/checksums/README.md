## Create a new s3 bucket

```sh
aws s3 mb s3://checksums-examples-ap-12345
```

## Create a file that we will do a checksum on

```sh
echo "Hello World!" > myfile.txt
```

## Get a checksum of a file for md5

```sh
md5sum myfile.txt
```
# 8ddd8be4b179a529afa5f2ffae4b9858  myfile.txt

## Upload our file to s3 and look at its etag

```
aws s3 cp myfile.txt s3://checksums-examples-ap-12345
aws s3api head-object -bucket checksums-examples-ap-12345 --key myfile.txt
```

# Output
```md
{
    "AcceptRanges": "bytes",
    "LastModified": "2024-06-11T01:18:17+00:00",
    "ContentLength": 13,
    "ETag": "\"8ddd8be4b179a529afa5f2ffae4b9858\"",
    "ContentType": "text/plain",
    "ServerSideEncryption": "AES256",
    "Metadata": {}
}
```
## Let's upload a file with a different kind of checksum

```sh
ruby crc.rb
```
# a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b

```sh
aws s3api put-object
--bucket="checksums-examples-ap-12345" \
--key="myfilesha1.txt" \
--body="myfile.txt" \
--checksum-algorithm="SHA1" \
--checksum-sha1="a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b"
```

## Clean Up

```sh
../bash-scripts/delete-objects checksums-examples-ap-12345
../bash-scripts/delete-bucket checksums-examples-ap-12345
```