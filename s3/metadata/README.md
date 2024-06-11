## Create a bucket
```sh
aws s3 mb s3://metadata-fun-ap-12345
```

## Create a new file

``sh
echo "Hello Mars!" > hello.txt
```

## Upload file with metadata

```sh
aws s3api put-object --bucket metadata-fun-ap-12345 --key hello.txt --body hello.txt --metadata Planet=Mars
```

## Get Metadata through head object

```sh
aws s3api head-object --bucket metadata-fun-ap-12345 --key hello.txt
```

**OUTPUT**

```md
{
    "AcceptRanges": "bytes",
    "LastModified": "2024-06-11T03:58:51+00:00",
    "ContentLength": 12,
    "ETag": "\"ad9fa83779fd19527ed739033310bc2f\"",
    "ContentType": "binary/octet-stream",
    "ServerSideEncryption": "AES256",
    "Metadata": {
        "planet": "Mars"
    }
}
```

## Clean Up

```sh
../bash-scripts/delete-objects metadata-fun-ap-12345
../bash-scripts/delete-bucket metadata-fun-ap-12345
```