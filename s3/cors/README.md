# Create Website 1

## Create a bucket

```sh
aws s3 mb s3://cors-fun-ap-12345
```

## Change block public access

```sh
aws s3api put-public-access-block \
--bucket cors-fun-ap-12345 \
--public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

## Create a bucket policy

```sh
aws s3api put-bucket-policy --bucket cors-fun-ap-12345 --policy file://./bucket-policy.json
```

## Turn on static website hosting

```sh
aws s3api put-bucket-website --bucket cors-fun-ap-12345 --website-configuration file://./website.json
```

## Upload our index.html file and include a resource that would be cross-origin

```sh
aws s3 cp index.html s3://cors-fun-ap-12345
```

## View the website and see if the index.html is there

*Other regions may use a '.' or a '-'.*

```sh
http://cors-fun-ap-12345.s3website.us-east-1.amazonaws.com

http://cors-fun-ap-12345.s3-website-us-east-1.amazonaws.com
```

# Create Website 2

## Create a bucket

```sh
aws s3 mb s3://cors-fun-ap-12345-2
```

## Change block public access

```sh
aws s3api put-public-access-block \
--bucket cors-fun-ap-12345-2 \
--public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

## Create a bucket policy

```sh
aws s3api put-bucket-policy --bucket cors-fun-ap-12345-2 --policy file://./bucket-policy-2.json
```

## Turn on static website hosting

```sh
aws s3api put-bucket-website --bucket cors-fun-ap-12345-2 --website-configuration file://./website.json
```

## Upload our javascript file

```sh
aws s3 cp hello.js s3://cors-fun-ap-12345-2
```
