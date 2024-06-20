## Create a user with no permissions

We need to create a new user with no permissions and generate out access keys

1. create the user

```sh
aws iam create-user \
--user-name sts-machine-user
```

2. generate access keys for user
    - **do not share these values or upload them to a public repository**
    - keep track of these values by copy pasting them somewhere, we'll need them for the next step

```sh
aws iam create-access-key \
--user-name sts-machine-user \
--output table
```
3. configure your user by copying access key and secret key
    - AWS Access Key Id: paste your key id you generated
    - AWS Secret Access Key: paste your secret key you generated
    - Default region name: hit enter
    - Default output format: hit enter

```sh
aws configure
```

4. test who cli recognizes you as
```sh
aws sts get-caller-identity
```

5. edit the credentials file to change away from default profile
    - change section from default to sts
```sh
open ~/.aws/credentials
```

6. test who cli recognizes you as
```sh
aws sts get-caller-identity --profile sts
```

7. make sure you don't have access to s3
```sh
aws s3 ls --profile sts
```

## Create a Role

We need to create a role that will access a new resource

## Use new user credentials and assume role

```sh
aws iam put-user-policy \
--user-name sts-machine-user \
--policy-name StsAssumePolicy \
--policy-document file://./bin/policy.json
```

```sh
aws sts assume-role \
--role-arn arn:aws:iam::590183687974:role/my-sts-fun-stack-StsRole-DAkQBbY7THJk \
--role-session-name s3-sts-fun \
--profile sts
```
Keep track of the output as we'll need the access id, secret key, and session token.

```sh
open ~/.aws/credentials
```

Edit credentials file and add profile 'assumed' with respective details

```toml
[assumed]
aws_access_key_id = 
aws_secret_access_key = 
aws_session_token = 
```

Test role

```sh
aws sts get-caller-identity --profile assumed
```

Test bucket access

```sh
aws s3 ls --profile assumed
```

## Clean up

- go into Console and tear down stack
- delete access keys
    - open credentials file to find your access key for sts profile
    - open ~/.aws/credentials
- delete policy
- delete user

```sh
aws iam delete-access-key \
--access-key-id YOUR_ACCESS_KEY \
--user-name sts-machine-user
```

```sh
aws iam delete-user-policy \
--user-name sts-machine-user \
--policy-name StsAssumePolicy
```

```sh
aws iam delete-user \
--user-name sts-machine-user
```