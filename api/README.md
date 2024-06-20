## AWS Application Programming Interface (API)

**What is an Application Programming Interface (API)?**

An API is software that allows two applications/services to talk to each other.
The most common type of API is via HTTP/S requests.

AWS API is an HTTP API and you can interact by sending HTTPS requests using an application interacting with APIs like Postman.

Each AWS Service has its own Service Endpoint which you send requests

Rarely do users directly send HTTP requests directly to the AWS API.
Its much easier to interact with the API via a variety of Developer Tools.

- AWS Management Console
- AWS SDK
- AWS CLI

## AWS Command Line Interface (CLI)

**What is a CLI?**

A Command Line Interface (CLI) **processes commands to a computer program in the form of lines of text.**

Operating systems Implement a command line interface in a shell.

**What is a Terminal?**

A terminal is a text only interface (input/output environment)

**What is a Console?**

A console is a physical computer to physically input information into a terminal.

**What is a Shell?**

A shell is the command line program that users interact with to input commands.

- bash
- zsh
- powershell

AWS Command Line Interface (CLI) allows users to programmatically interact with with the AWS API via entering single or multi-line commands into a shell or terminal.

## Access Keys

**Access Keys** is a **key and secret** required to have programmatic access to AWS resources when interacting with the AWS API outside of the AWS Management Console.

**An Access Key is commonly referred to as AWS Credentials**

A user must be granted access to use Access Keys.

- Never share your access keys
- Never commit access keys to a codebase
- You can have two active Access Keys
- You can deactivate Access Keys
- Access Keys have whatever access a user has to AWS resources

Access Keys are to be stored in ~/.aws/credentials and follow a TOML file format.

Example:
- Default will be the access key when no profile is specified
- You can store multiple access keys by giving them profile names
- You can use the aws configure CLI command to populate the credential file

```toml
[default]
aws_access_key_id=AADLFKJLE4209EXAMPLE
aws_secret_access_key=wJsLDdfDkjefe/DFKLJLKJ/bdxDJFEEIJEXAMPLEKEY
[develop]
aws_access_key_id=AADLFKJL452509EXAMPLE
aws_secret_access_key=adfasdfDFSFDS/DFKLJLKJ/bdxDJFEEIJEXAMPLEKEY
region=us-east-1
```

The AWS SDK and CLI will automatically pick up environment variables.

Example:
```sh
export AWS_ACCESS_KEY_ID=AADLFKJL452509EXAMPLE
```

## API Retries and Exponential Backoff

When interacting with APIs over a network, its common for a network issue to occur for various reasons due to the amount of devices a request has to pass through and point of failures:
- DNS Servers
- Switches
- Load Balancers

When working with APIs you need to plan for possible network failure by trying again.

**A good CLI or SDK will have exponential backoff built in with options like how many times it should try.**

## Smithy

Smithy 2.0 is AWS's open-source Interface Definition Language (IDL) for web services.

- Smithy is a language for defining services and SDKs
- Smithy and its server generator unlocks model-first development
- Forces you to define your interface first rather than let your API become implicitly defined by your implementation choices

Example:
```md
// Define the namespace
namespace com.amazonaws.s3

// Define a simplified S3 Service
service SimpleS3 {
    version: "2023-12-21",
    operations: [ListBuckets, PutObject]
}

// Define an operation to list buckets
operation ListBuckets {
    output: ListBucketsOutput
}

// Define the output structure for ListBuckets operation
structure ListBucketOutput {
    buckets: BucketList
}

// Define a list of buckets
list BucketList {
    member: Bucket
}
```

## Service Token Service (STS)

STS is a web services that enables you to request temporary, limited-privilege credentials for IAM users or federated users.

AWS Security Token Service (STS) is a global service and all AWS STS requests go to a single endpoint at https://sts.amazonaws.com

You can use the following API actions to obtain STS:

- AssumeRole
- AssumeRoleWithSAML
- AssumeRoleWithWebIdentity
- DecodeAuthorizationMessage
- GetAccessKeyInfo
- GetCallerIdentity
- GetFederationToken
- GetSessionToken

An STS will return:

- AccessKeyID
- SecretAccessKey
- SessionToken
- Expiration

Example:

```py
import boto3

sts_client = boto3.client('sts')
response = sts_client.assume_role(
    RoleArn='ARN_HERE',
    RoleSessionName='session1'
)

creds = response['Credentials']

# load in temporary credentials
s3 = boto3.client('s3',
    aws_access_key_id=creds['AccessKeyId'],
    aws_secret_access_key=creds['SecretAccessKey'],
    aws_session_token=creds['SessionToken']
    )
```
## Signing AWS API Requests

When you send API Requests to AWS, you sign the requests so that AWS can identify who sent them.

When you use the AWS CLI or AWS SDK, requests are signed for you automatically.
Some requests don't need to be signed:
    - Anonymous requests to Amazon S3
    - Some API operations to STS e.g. AssumeRoleWithWebIdentity

Signatures do the following:
    - Prevent data tampering
    - Verifies the identity of the requester

Example of a signature being supplied:

```sh
https://s3.amazonaws.com/examplebucket/test.txt
?X-Amz-Algorithim=AWS4-HMAC-SHA256
&X-Amz-Credential=<your-access-key-id>/20130721/us-east...
&X-Amz-Date=20130721T201207Z
&X-Amx-Expires=86400
&X-Amx-SignedHeaders=host
&X-Amz-Signature=<signature-value>
```
AWS has two different protocols for signing:
    - version 2 (not used)
    - version 4 

## AWS IP Address Ranges
AWS Publishes all of its IP Address Ranges at this url in json format:
https://ip-ranges.amazonaws.com/ip-ranges.json

```sh
curl https://ip-ranges.amazonaws.com/ip-ranges.json \
| jq jq '.prefixes[] | select(.region=="us-east-1") | select(.service=="CODEBUILD") |.ip_prefix'
```
## Service Endpoints

To connect programtically to an AWS service, you use an endpoint. 

An endpoint is the URL of the entry point for an AWS web service.

This is generally the format of a service endpoint (it varies per service)
protocol://service-code.region-code.amazonaws.com

- generally TLSv2 is expected some older APIs might support TLSv1, TLSv1.1, or HTTP

There are four types of Service Endpoints:
1. Global Endpoints - AWS Services that use the same endpoint
2. Regional Endpoints - AWS Services require you to specify a region
3. FIPS Endpoints - Some endpoints support FIPS for enterprise use
4. Dualstack Endpoints - Allows IPV6 or IPV4

The types of Service Endpoints cna be combined eg Regional + FIPS + Dualstack
An AWS Service may have multiple different service endpoints
    - AWS CLI and AWS SDK will automatically use the default endpoint for each service in an AWS Region

## Configuration Files

AWS has two different configuration files in TOML format at:
~/.aws/credentials - used to store sensitive credentials eg AWS Access Key and Secret
~/.aws/config - used to store generic configurations eg Preferred Region

You can store all the same configureation in either files, though credentials will take precendence over config

Global Configuration options for configuration files:
- **aws_access_key_id**
- **aws_secret_access_key**
- aws_session_token
- ca_bundle
- cli_auto_prompt
- cli_binary_format
- cli_history
- cli_pager
- cli_timestamp_format
- credential_process
- credential_source
- duration_seconds
- external_id
- max_attempts
- mfa_serial
- **output**
- parameter_validation
- **region**
- retry_mode
- role_arn
- role_session_name
- source_profile
- sso_account_id
- sso_region
- sso_registration_scopes
- sso_role_name
- sso_start_url
- web_identity_token_file
- tcp_keepalive

## Named Profiles
AWS Config files support the ability to have multiple profiles

Profiles allow you to switch between different configurations quickly for different environments

## AWS CLI Configure Commands

AWS CLI has multiple configure commands to make configuration easy:

A wizard to quickly setup your configuration file
```md
$ aws configure
AWS Access Key ID [None]: SOMEKEY
AWS Secret Access Key [None]: SOMESECRETKEY
Default region name [None]: us-east-1
Default output format [None]: json
```
Set a value for a specific string

```sh
aws configure set region us-west-2 --profile dev
```

Unset a value by using the set command with a blank string

```sh
aws configure set region "" --profile dev
```

Use get to print the value of a string

```sh
aws configure get region
```

Import AWS Credentials generated and downloaded from the AWS Console

```sh
aws configure import --csv file://credentials.csv
```

