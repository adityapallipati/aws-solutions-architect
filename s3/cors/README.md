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

## Create API Gateway with mock response and then test the endpoint

```md
https://08yes3tmfb.execute-api.us-east-1.amazonaws.com/Prod
```

```sh
curl -X POST -H "Content-Type: application/json" https://08yes3tmfb.execute-api.us-east-1.amazonaws.com/Prod/hello
```

**RECAP**

We created a 2 static websites both did not result in a CORS issue we wanted. So we created a mock API via API Gateway to produce a CORS issue within our first website. Now we're going to set cors on our bucket to resolve the issue.

## Set CORS on our bucket

```sh
aws s3api put-bucket-cors --bucket cors-fun-ap-12345 --cors-configuration file://./cors.json
```

cors.json

```json
{
    "CORSRules": [
        {
            "AllowedOrigins":["https://08yes3tmfb.execute-api.us-east-1.amazonaws.com"],
            "AllowedHeaders":["*"],
            "AllowedMethods":["PUT", "POST", "DELETE"],
            "MaxAgeSeconds": 3000,
            "ExposeHeaders": ["x-amz-server-side-encryption"]
        }
    ]
}
```

## Clean Up

```sh
../bash-scripts/delete-objects cors-fun-ap-12345
../bash-scripts/delete-bucket cors-fun-ap-12345
../bash-scripts/delete-objects cors-fun-ap-12345-2
../bash-scripts/delete-bucket cors-fun-ap-12345-2
```