## Create a bucket

```sh
aws s3 mb s3://class-fun-ap-1234
```

## Create a file

```sh
echo "Hello World" > hello.txt
aws s3 cp hello.txt s3://class-fun-ap-1234 --storage-class STANDARD_IA
```

Validate in S3 Console your storage class is not Standard but Standard-IA.

## Clean up

```sh
../bash-scripts/delete-objects class-fun-ap-1234
../bash-scripts/delete-bucket class-fun-ap-1234
```