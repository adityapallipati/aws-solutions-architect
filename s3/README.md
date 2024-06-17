# S3 Bucket Overview
S3 Buckets are infrastrucure, and hold S3 Objects.

## S3 Bucket Naming Rules
"how we have to name our bucket"

s3 bucket names are similar to valid URL rules (but more rules), this is because s3 bucket names are **used to form URL links** to perform various HTTPs operations.
Example: https://**myexamplebucket**.s3.amazonaws.com/photo.jpg

- **Length**: Bucket names be **3-63 characters** long
- **Characters**: Only lowercase letters, numbers, dots (.), and hyphens (-) are allowed.
- **Start and End**: They must **begin and end with a letter or number.**
- **Adjacent Periods**: No two adjacent period are allowed.
- **IP Address Format**: Names can't be formatted as IP address (e.g. 192.169.5.4)
- **Restricted Prefixes**: Can't start with "xn--","sthree", or "sthree-configurator"
- **Restricted Suffixes**: Can't end with "-s3alias", or "--ol-s3", reserved for access point alias names.
- **Uniqueness**: Must be unique across all AWS accounts in all AWS Regions within a parition.
- **Exclusivity**: A name can't be reused in the same partition until the original bucket is deleted.
- **Transfer Acceleration**: Buckets used with S3 Transfer Acceleration can't have dots in their name.

***NO UPPERCASE, NO UNDERSCORES, NO SPACES IN BUCKET NAMES***

Examples:

Examples:
- <span style="color: green;">✔</span> mybucket-123
- <span style="color: red;">✖</span> 123.456.789.012 *formatted as an IP address*
- <span style="color: red;">✖</span> My-Bucket *contains uppercase letters*
- <span style="color: red;">✖</span> data.bucket..archive *contains adjacent periods*
- <span style="color: green;">✔</span> log-bucket
- <span style="color: red;">✖</span> xn--bucketname *starts with "xn--"*
- <span style="color: red;">✖</span> bucket_name *contains underscore*
- <span style="color: green;">✔</span> example-bucket-1
- <span style="color: red;">✖</span> sthree-config-bucket *starts with "sthree-config"*
- <span style="color: green;">✔</span> test.bucket.data
- <span style="color: red;">✖</span> new-bucket-s3alias *ends with "s3alias"*
- <span style="color: green;">✔</span> archive-bucket
- <span style="color: red;">✖</span> @bucket-name *contains @ sign, only . and - allowed*


## S3 Bucket Restrictions and Limitations
"what we can and can't do with buckets"

*(not an exhaustive list)*

- You can by default create **100 buckets**
  - You can create a service request to increase to **1000 buckets**
- You need to **empty a bucket first** before you can delete it
- **No max bucket size** and **no limit to the number of objects** in a bucket
  - File can be between 0 and 5 TBs
    - Files larger than 100MB should use multi-part upload
  - S3 for AWS Outputs has limits
 - Get, Put, List, and Delete operations are designed for high availability
    - Create, Delete or configuration operations should be run less often.
  

## S3 Bucket Types 
"the two different kinds of buckets, flat (general purpose) and directory" 

**Amazon S3 has two types of buckets**

🪣 General Purpose Buckets
- Organizes data in a **flat hierarchy**
- The original S3 bucket type.
- Recommended for most use cases.
- Used with all storage classes except can't be used with S3 Express One Zone storage class
- There aren't prefix limits
- There is a default limit of 100 general buckets per account

📁 Directory Buckets
- Organizes data **folder hierarchy**
- Only to be used with **S3 Express One Zone storage class**
- Recommended when you need single-digit millisecond performance on PUT and GET
- *There aren't prefix limits for directory buckets
- Individual directories can scale horizontally
- There is a default limit of 10 directory buckets per account

## S3 Bucket Folders
"how s3 buckets have virtual folders for general purpose buckets"

The S3 Console allows you to "create folders". **S3 general purpose buckets** do not have true folders found in hierarchy file system.

When you create a folder in S3 Console, Amazon S3 creates a **zero-byte** S3 object with a name that ends in a forward slash. e.g. myfolder/

- S3 folders are not their own independent identities but just S3 Objects
- S3 folders don't include metadata, permissions
- S3 folders don't contain anything, they can't be full or empty
- S3 folders aren't "moved", S3 objects containing the same prefix are renamed

## S3 Object Overview

S3 Objects are resources that **represent data** and is not infrastructure.

- Etags: a way to detect wen the contents of an object has changed without downloading the contents
  **What is an ETag?**
  An entity tag (etag) is a response header that represent a resource that has changed (without the need to download(
  - The value of an etag is generally represented by a hashing function eg MD5 or SHA-1
  - Etags are part of the HTTP protocol
  - Etags are used for revalidation for caching systems

  S3 Objects **have an etag**
  - etag represents a hash of the object
  - reflects changes only to the contents of an object, not its metadata
  - may or may not be an MD5 digest of the object data (depends if it's encrypted)
  - Etag represents a specific version of an object

  **ETags are useful if you want to programmatically detect content changes to S3 objects.**

- Checksums: ensures the integrity of a file being uploaded or downloaded
  **What is a Checksum?**
  A checksum is used to **check the sum (amount) of data to ensure the data integrity of a file.**
  If data is downloaded and if in-transit data is lost or mangled the checksum will **determine there is something wrong with the file**.

  - Amazon S3 uses checksums to verify data integrity of files on the upload or download.
  - Amazon allows you to **change the checksum algorithm during upload of an object**
  - Amazon S3 offers the following checksum algorithms:
    - CRC32 (Cyclic Redundancy Check)
    - CRC32C
    - SHA1 (Secure Hash Algorithms)
    - SHA256

- Object Prefixes: simulates file system folders in a flat hierarchy
  **What is a object prefix?**
  S3 Object prefixes are **strings that proceed** the **Object filename** and are part of the Object key name.

  Example: /assets/images/aditya.png

  Object prefix --> **/assets/images/**
  Object key name --> aditya.png
  Object filename --> aditya.png

  Since all objects in a bucket are stored in a **flat-structured hierarchy**, Object prefixes allows for a way to **organize, group, and filter** objects.

  A prefix uses the forward slash "/" as a delimiter to group similar data, similar to directories (folders) or subdirectories. Prefixes are **not true folders**.

  **There is no limit for the number of delimiters, the only limit is the Object Key Name cannot exceed 1024 bytes with the object prefix and filename combined.**

- Object Metadata: attach data alongside the content, to describe the contents of the data
  **What is Metadata?**
  Metadata provides information about other data but not the contents itself.
  Metadata is useful for:
    - categorizing and organizing data
    - providing contents about data

  Amazon S3 allows you to **attach metadata to S3 Objects** at anytime
  Metadata can be either:
    - System defined
      System defined Metadata is **data that only Amazon can control.** Users usually* cannot set the metadata values.
        - Content Type: image/jpeg
        - Cache Control: max-age=3600, must-revalidate
        - Content Disposition: attachment; filename='example.pdf'
        - Content-Encoding: gzip
        - Expires: Thu, 01 2030 16:00:00 GMT
        - X-amz-website-redirection-location: /new-page.html
      *AWS will attach some System defined metadata even if you do not specify any*
      **Some system defined metadata can be modified by the user eg Content-Type**

    - User defined
      User Defined Metadata is set by the user and must start with **x-amz-meta-* 
      **Examples**
      Access and Security
      - x-amz-meta-encryption: "AES-356"
      - x-amz-meta-access-level: "confidential"
      - x-amz-meta-expiration-date: "2024-12-12"

      Media File:
      - x-amz-meta-camera-model: "Canon EOS 5D"
      - x-amz-meta-photo-taken-on: "2023-05-05"
      - x-amz-meta-location: "Dallas"

      Custom Application:
      - x-amz-meta-app-version: "2.4.1"
      - x-amz-meta-data-imported: "2023-01-01"
      - x-amz-meta-source: "CRM System"

      Project-specific:
      - x-amz-meta-project-id: "ABC12345"
      - x-amz-meta-department: "Marketing"
      - x-amz-meta-reviewed-by: "John Doe"

      Document Versioning:
      - x-amz-meta-version: "v3.1"
      - x-amz-meta-last-modified-by: "Aditya Pallipati"
      - x-amz-meta-original-upload: "2024-06-11"

      Content-related:
      - x-amz-meta-title: "Model Development Documentation 2024"
      - x-amz-meta-author: "Aditya Pallipati"
      - x-amz-meta-description: "Model development high level overview for XYZ model..."

      Compliance and Legal:
      - x-amz-meta-legal-hold: "true"
      - x-amz-meta-compliance-category: "GDPR"
      - x-amz-meta-access-level: "5 Years"

      Backup and Archival:
      - x-amz-meta-backup-status: "Completed"
      - x-amz-meta-archive-status: "2024-08-31"
      - x-amz-meta-recovery-point: "2023-08-31"


  **Resource Tags and Object tags are similar to Metadata but tags are intended to provide information about cloud resources (eg S3 Objects) and not the contents of the object.**

- Object tags: benefits resource tagging but at the object level
- Object Locking: makes data files immutable
  **S3 Object Locks** allow you to **prevent the deletion of objects** in a bucket
  This feature can only be turned on at the creation of a bucket
  Object Lock is for companies that need to prevent objects being deleted to have:
    - Data integrity
    - Regulatory compliance

  S3 Object Lock is **SEC 17a-4, CTCC,** and **FINRA** regulation compliant.

  You can store objects using **write-once-read-many (WORM) model** just like S3 Glacier.

  You can use it to prevent an object from being deleted or overwritten for:
    - a fixed amount of time
    - or indefinitely

  Object retention is handled two different ways:
    1. Retention periods: a fixed period of time which an object remains locked
    2. Legal holds: remains locked until you remove the hold

  **S3 buckets with Object Lock can't be used as destination buckets for server access logs.**

  Object Locking **setting can only be set via the AWS API** eg (CLI, SDK) and not the AWS Console.

```sh
aws s3api put-object \
--bucket your-bucket-name \
--key your-object-key \
--body file-to-upload \
--object-lock-mode GOVERNANCE \
--object-lock-retain-util-date "2025-01-01T00:00:00Z"
```

  This is to avoid misconfiguration by non-technical users locking objects.

- Object Versioning: have multiple versions of a data file

## Bucket URI
  ** The S3 Bucket URI (Uniform Resource Identifier) is a way to reference the address of S3 bucket and S3 objects.

  Example: s3://myexamplebucket/photo.jpg

  You'll see this S3 Bucket URI required to be used for specific AWS CLI commands.

  Example:

```sh
aws s3 cp test.txt s3://mybucket/test2.txt
```

## AWS S3 CLI

  **aws s3**
  A high level way to interact with S3 buckets and objects. Good for programmatically working with s3 using bash scripts.

```sh
aws s3 cp test.txt s3://mybucket/test.txt
```

  **aws s3api**
  A low level way to interact with S3 buckets and objects.

```sh
aws s3api put-object \
--bucket text-content \
--key dir/file.jpg \
--body file.jpg
```

 **aws s3control**
 Managing s3 access points, s3 outputs buckets, s3 batch operations, storage lens.

```sh
aws s3control describe-job \ 
--account-id 123456789012 \
--job-id 123447883-abcd-7738-8098-708940983e
```
  **aws s3outputs**
  Manage endpoints for S3 outputs.

```sh
aws s3outputs create-endpoint \
--outpost-id "op-09138409382040092afd132" \
--subnet-id "subnet-14932840328209232309843" \
--security-group-id "sg-04982r230984311h2039302" \
--customer-owned-ipv4-pool "ipv4pool-coip-abcdefg123456780
```

## Request Styles
When making requests by using the REST API there are two styles of requests:

1. Virtual hosted-style requests: bucket name is a subdomain on the host
```md
DELETE /photo.jpg HTTP/1.1
Host: **examplebucket**.s3.us-west-2.amazonaws.com
Date: Mon, 11 Apr 2016 12:00:00 GMT
x-amz-date: Mon, 11 Apr 2016 12:00:00 GMT
Authorization: authorization string
```
2. Path-style requests: bucket name is in the request path

```md
DELETE **/examplebucket**/photo.jpg HTTP/1.1
Host: s3.us-west-2.amazonaws.com
Date: Mon, 11 2016 12:00:00 GMT
x-amz-date: Mon, 11 Apr 2016 12:00:00 GMT
Authorization: authorization string

**S3 supports both virtual-hosted-style and path-style URL but Path-style URLs will be discontinued in the future.**

To force AWS CLI to use Virtual hosted-style requests you need to **globally configure the CLI.**

```sh
aws configure set s3.addressing_style virtual
```

## DualStack Endpoints

There are *two possible endpoints accessing Amazon S3 API.

Standard Endpoint: https://s3.us-east-2.amazonaws.com (handles only IPV4 traffic)

DualStack: https://s3.dualstack.us-east-2.amazonaws.comm (handles both IPV4 and IPV6 traffic)

At one point AWS only offered IPV4 and DualStack is designed as its future replacement since IPV4 addresses are running out and IPV6 has a larger public address space.

*There are other S3 endpoints like Static Website, FIPS, S3 Controls, Access Points.

## Storage Classes
AWS offers a range of S3 storage classes that trade **Retrieval Time, Accessibility and Durability** for **Cheaper Storage**

- **S3 Standard (default)** Fast, Available, and Durable
  - **default storage class** when you upload to S3. It's designed for **general purpose storage for frequently accessed data**
  - **High Durability** 11 9's of durability (99.999999999%)
  - **High Availability** 4 9's of availability (99.99%)
  - **Data Redundancy** Data stored in 3 or more Availability Zones (AZs)
  - **Retrieval Time** within milliseconds (low latency)
  - **High Throughput** optimized for data that is frequently accessed and/or requires real-time access
  - **Scalability** easily scales to storage size and number of requests
  - **Use Cases** Ideal for a wide range of use cases like content distribution, big data analytics, and mobile and gaming applications, where frequent access is required.
  **Pricing** storage per gb, per requests, no retrieval fee, no minimum storage duration.

- *S3 Reduced Redundancy Storage (RSS)* legacy storage class
  - non critical, reproducible data at lower levels of redundancy than S3 Standard
  - RSS was introduced in 2010 and at the time was cheaper than Standard storage.
  - In 2018, S3 Standard infrastructure changed and the cost of S3 Standard fell below the cost of RSS.
  - **RSS currently provides no cost benefit to customers** for the reduced redundancy and has no place in modern storage use-cases.
  - **RSS is no longer cost-effective and is not recommended for us. It may appear in AWS Console as an option due to legacy customers.**

- **S3 Intelligent Tiering** Uses ML to analyze object usage and determine storage class. Extra fee to analyze.

  **S3 Intelligent Tiering** storage class **automatically moves objects into different storage tiers** to reduce storage costs, but charges a low month cost for object monitoring and automation.

    - S3 Intelligence access has the following access tiers:
      - Frequent Access Tier (automatic)
        - The default tier, objects remain here as long as they are being accessed.
      - Infrequent Access Tier (automatic)
        - If object is not accessed after 30 days its moved here
      - Archive Instant Access Tier (automatic)
        - If object is not accessed after 90 days its moved here
      - Archive Access Tier (optional)
        - After activation, if object is not accessed after 90 days, it is moved here
      - Deep Archive Access Tier (optional)
        - After activation, if object is not accessed after 180 days, it is moved here

    **S3 Intelligent Tiering has additional cost to analyze objects for 30 days.**

  Example Implementation using AWS CLI:

```sh
aws s3api put-object \
--bucket my-bucket \
--key 'myfile.parquet' \
--body 'path/to/local/file' \
--storage-class INTELLIGENT_TIERING
```

- **S3 Express One-Zone** single-digit ms performance, special bucket type, one AZ, 50% less than Standard cost
  **Amazon S3 Express One Zone** delivers **consistent single-digit millisecond data access** for your most frequently accessed data and latency-sensitive applications.
    - the lowest latest cloud object storage class available
    - data access speeds up to **10x faster** than S3 Standard
    - request costs **50% lower** than S3 Standard
    - data is stored in a user selected single **Availability Zone** (AZ)
    - data is stored in a new bucket type: **an Amazon S3 Directory bucket**
    **S3 Directory bucket supports simple real-folder structure, you are only allowed 10 by default S3 Directory buckets per account**
    **Express One Zone applies a flat per request charge for request sizes up to 512 KB**

- **S3 Standard-IA (Infrequent Access)** Fast, Cheaper if you access less than once a month. Extra fee to retrieve. **50% less** than Standard (reduced availability)
  - **S3 Standard-IA (Infrequent Access)** storage class is designed **for data that is less frequently accessed** but requires rapid access when needed.
  - **High Durability**: 11 9's of durability like S3 Standard
  - **High Availability**: 3 9's of availability (99.9%) Slower availability compared to S3 Standard
  - **Data Redundancy**: Data stored in 3 or more Availability Zones (AZs)
  - **Cost-Effective Storage**: costs **50% less** from Standard. **As long as you don't access a file more than once a month!**
  - **Retrieval Time**: within milliseconds (low latency)
  - **High Throughput**: optimized for rapid access, although the data is accessed less frequently compared to S3 Standard.
  - **Scalability**: easily scales to storage size and number of requests like S3 Standard
  - **Use Cases**: Ideal for data that is accessed less frequently but requires quick access when needed, such as disaster recovery, backups, or long-term data stores where data is not frequently accessed.
  - **Pricing**: storage per GB, per requests, **has a retrieval fee**, **minimum storage duration charge of 30 days**


- **S3 One-Zone-IA** Fast Objects only exist in one AZ. Cheaper than Standard IA by 20% less, (Reduce durability) Data could get destroyed. Extra fee to retrieve.

  **Storage One-Zone IA (Infrequent Access)** storage class is designed **for data that is less frequently accessed** and has additional saving at reduced availability.
  - **High Durability**: 11 9's of durability like S3 Standard and Standard IA
  - **Lower Availability**: 99.5% since ti is in a single AZ it has even lower availability than Standard IA
  - **Cost-Effective Storage**: costs **20% less from Standard IA**
  - **Data Redundancy**: Data stored in one Availability Zone (AZ) there is a risk of data loss in-case of AZ disaster.
  - **Retrieval Time**: within milliseconds (low latency)
  - **Use Cases**: Ideal for a secondary backup of on-premise data, or for storing data that can be recreated in the event of an AZ failure. It's also suitable for storing infrequently accessed data that is **non mission-critical**
  - **Pricing**: storage per GB, per requests, **has a retrieval fee**, **has a minimum storage duration charge of 30 days**


## Context For S3 Glacier Storage Classes
### There is a separate service called S3 Glacier "Vault"

- S3 Glacier "Vault"
  - **"S3" Glacier** is a stand-alone service from S3 that uses **vaults** over buckets to store data long term.
  - S3 Glacier is the original vault service.
    - it has vault control policies
    - most interactions occur via the AWS CLI
    - Enterprises are still using S3 Glacier Vault
    - **S3 Glacier Deep** Archive is a part of S3 Glacier "Vault"

- S3 Glacier Storage Classes
  - S3 Glacier Storage classes offer similar functionality to S3 Glacier but with greater convenience and flexibility all within S3 Buckets.
  - S3 Glacier Instant is a new class with no attachment to S3 Glacier Vault.
  - S3 Glacier Flexible is using S3 Glacier Vault underneath.
  - S3 Glacier Deep Archive is using S3 Glacier Vault underneath.

### With this context we can understand the S3 Glacier storage classes better.

- **S3 Glacier Instant Retrieval** For long-term cold storage. Get data instantly.
  S3 Glacier Instant Retrieval is a storage class designed for rarely accessed data that still needs immediate access in performance sensitive use cases.
  - **High Durability**: 11 9's of durability like S3 Standard
  - **High Availability**: 3 9's of availability (99.9%) like S3 Standard IA
  - **Cost-Effective Storage**: **68%** lower cost than Standard IA
    - for long lied data that is **accessed once per quarter**
  - **Retrieval Time**: within milliseconds (low latency)
  - **Use Cases**: rarely accessed data that needs immediate access eg image hosting, online file-sharing applications, medical imaging and health records, news media assets, and satellite and arial imaging.
  - Pricing: storage per GB, per requests, **has retrieval fee**, **has minimum storage duration charge of 90 days**
  **Glacier Instant Retrieval is not a separate service and does not require a Vault**

- **S3 Glacier Flexible Retrieval** takes minutes to hours to get data (Standard, Expedited, Bulk Retrieval)

  **S3 Glacier Flexible Retrieval** (formally S3 Glacier) combines S3 and Glacier into a single set of APIs. It's considerably faster than Glacier Vault-based storage.

  - There are 3 **retrieval tiers** (the faster the more expensive)
    - **Expedited Tier** 1-5 mins 
      - for urgent requests. limited to 250 mb archive size
    - **Standard Tier** 3-5 hours
      - no archive size limit. this is the **default** option
    - **Bulk Tier** 5-12 hours
      - no archive size limit, even petabytes worth of data

  - You pay **per GB retrieved** and **number of requests**. This is a separate cost from just the cost of storage.
  - Archived objects will have an additional 40KBs of data:
    - 32 KB for archive index and archive metadata information
    - 8KB for the name of the object
  - **You should store fewer and larger files, instead of smaller files. 40KBs on thousands of files add up**
  **Glacier Flexible Retrieval is not a separate service and does not require a Vault**

- **S3 Glacier Deep Archive** The lowest cost storage class. Data retrieval time is 12 hours.

  **S3 Glacier Deep Archive** combines S3 and Glacier into a single set of APIs. It's more cost-effective than S3 Glacier Flexible but greater cost of retrieval.

  - There are two **retrieval tiers**:
    - **Standard Tier** 12-48 hours
      - No archive size limit. This is the default option.
    - **Bulk Tier** 12-48 hours
      - No archive size limit, even petabytes worth of data.
  
  - Archived objects will have an additional 40KBs of ddata:
    - 32KB for index and metadata information
    - 8KB for the name of the object

  **Glacier Deep Archive is not a separate service and does not require a Vault**

**S3 Outputs has its own storage class.**



## Bucket Versioning
"how we can version all objects"

## Bucket Encryption
"how we can encrypt the contents of a bucket"

## Static Website Hosting
"how we can let our bucket host websites"

**S3 is a globally available service but when you create a bucket you specify a region**

## S3 Security Overview

- **Bucket Policies**: Define permissions for an entire S3 bucket using JSON-based access policy language.
    - **S3 Bucket Policy** is a **resource-based policy** to grant an S3 bucket and bucket objects to other Principles eg AWS Accounts, Users, AWS Services.

- **Below example only allows a specific role to read objects with prod object tag**

```json
{
  "Version":"2012-10-17",
  "Statement":[{
    "Principal":{
      "AWS":"arn:aws:iam::123456789012:role/ProdTeam"
    },
    "Effect":"Allow",
    "Action":[
      "s3:GetObject",
      "s3:GetObjectVersion"
    ],
    "Resource":"arn:aws:s3::my-bucket/*",
    "Condition":{
      "StringEquals":{
        "s3:ExistingObjectTag/environment":"prod"
      }
    }
  }]
}
```
- **Below example restricts access to specific IP**

```json
{
  "Version": "2012-10-17",
  "Id": "S3PolicyId1",
  "Statement": [{
    "Sid": "IPAllow",
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::my-bucket",
      "arn:aws:s3:::my-bucket/*"
    ],
    "Condition": {
      "NotIpAddress": {
        "aws:SourceIp": "192.0.2.0/24"
      }
    }
  }]
}
```


- **Access Control Lists (ACLs)**: Provide a legacy method to manage access permissions on individual objects and buckets.

    - ACLs grant basic read/write permissions to other AWS accounts.
      - you can grant permissions only to other AWS accounts
      - you cannot grant permissions to users in your account
      - you cannot grant conditional permissions
      - you cannot explicitly deny permissions
    - S3 ACLs have been traditionally used to allow other AWS accounts to upload object to a bucket
    - Access Control LIsts (ACLs) are a legacy feature of S3 and there are more robust ways to provide cross-account access via bucket policies and access points.

- **AWS PrivateLink for Amazon S3**: Enables private network access to S3, bypassing the public internet for enhanced security.

- **Cross-Origin Resource Sharing (CORS)**: Allows restricted resources on a web page from another domain to be requested.

    - Cross-Origin Resource Sharing (CORS) is an HTTP-header based mechanism that allows a server to indicate any other origins (domain, scheme, port) than its own from which a browser should permit loading of resource.
    - CORS restrict which websites may access data to be loaded onto its page.
    - Access is controlled via HTTP headers.
      - Request Headers
        - Origin
        - Access-Control-Request-Method
        - Access-Control-Request-Headers
      - Response Headers
        - Access-Control-Allows-Origin
        - Access-Control-Allow-Credentials
        - Access-Control-Expose-Headers
        - Access-Control-Max-Age
        - Access-Control-Allow-Methods
        - Access-Control-Allow-Headers


- **Amazon S3 Block Public Access**: Offers settings to easily block access to all your S3 resources.

    - **Block Public Access** is a safety feature that is enabled by default to **block all public access to an S3 bucket.**
    - Unrestricted access to S3 Buckets is the **#1 security misconfiguration**
    - There are four options:
      - **New** Access Control Lists (ACLs)
      - **Any** Access Control Lists
      - **New** Bucket Policies for Access Points
      - **Any** Bucket Policies or Access Points
    - **Access points can have their own independent Block Public Access setting**

- **IAM Access Analyzer for S3**: Analyzes resource policies to help identify and mitigate potential access risks.

    - **Access Analyzer for S3** will alert you when your S3 buckets are exposed to the **Internet** or **other AWS Accounts**.
    - In order to use Access Analyzer for S3 you need to first create and analyzer in IAM Access Analyzer at the account level.

- **Inter-network Traffic Privacy**: Ensures data privacy by encrypting data moving between AWS services and the Internet.

    - Inter-network traffic privacy is about keeping data private as it travels across different networks.
    - AWS PrivateLink (VPC Interface Endpoints)
      - Allows you to connect an Elastic Network Interface (ENI) directly to other AWS Services eg S3, EC2, Lambda.
      - It can connect to select Third-Party services via the AWS Marketplace.
      - AWS PrivateLink can go cross-account.
      - Has fine-grain permissions via VPC endpoint policies.
      - There is a charge for using AWS PrivateLink.

    - VPC Gateway Endpoint
      - Allows you to connect a VPC directly to S3 (or DynamoDB) staying private within the internal AWS network.
      - VPC Gateway Endpoint can not go cross-account.
      - Does not have fine-grain permissions.
      - There is no charge to use VPC Gateway Endpoints.

- **Object Ownership**: Manages data ownership between AWS accounts when objects are uploaded to S3 buckets.

- **Access Points**: Simplifies managing data access at scale for shared datasets in S3.

    S3 Access Points simplify managing data access at scale for shared datasets in S3.

    S3 Access Points are **named network endpoints that are attached to bucekts** that you can use to perform S3 object operations like get and put.

    Each access point has:
      - distinct permissions via an Access Point Policy
      - distinct network controls 
      - distinct block public access

    Network Origin:
      - internet - requests can come from internet
      - vpc - all requests must come from specified vpc

    S3 Access Point Policy allows you to write permissions for a bucket alongside your bucket policy.

    An access point policy helps you **move specific and complex access configuration out of your bucket policy** keeping your bucket policy simple and easy to read.

    Instead of creating a bucket policy you can create multiple access points that allow you to apply policies to parts of your bucket's content.

    ### Multi Region Access Points
    Multi-Region Access points is a global endpoint to route request to multiple buckets residing in different regions.

    Multi-Region Access Point will return data from the regional bucket with the lowest latency.

    **AWS Global Accelerator** is used to route the closest bucket.
      - requests are accelerated over the internet, VPC or PrivateLink

    S3 Replication Rules can be used to synchronize object to the regional buckets

    ### S3 Object Lambda Access Points
    S3 Object Lambda Access Points allow you to transform the output requests of S3 objects when you want to present data differently.

    S3 Object Lambda Access Points only operates on the outputted objects, the original objects in the S3 bucket remain unmodified.

    S3 Object Lambda can be performed on S3 Operations:

      - HEAD - information about the S3 object, but not the object contents itself
      - GET - an S3 object including its contents
      - LIST - a list of s3 objects

    An Amazon Lambda Function is attached to an S3 Bucket via the Object Lambda Access Point.

    Multiple transformations can be configured per Object Lambda Access Point.


- **Access Grants**: Providing access to S3 data via directory services eg Active Directory

    - **Amazon S3 Access Grants** lets you **map identities in a directory service** (IAM Identity Center, Active Directory, OKTA) to access datasets in S3.

- **Versioning**: Preserves, retrieves, and restores every version of every object stored in an S3 bucket.
    Versioning allows you to store multiple versions of S3 objects.

    - With versioning you can **recover more easily** from unintended user actions and application failures.
    - Versioning-enabled buckets can help you recover objects from accidental deletion or overwrite.

    - store all versions of an object in S3 at the same object key address
    - by default, s3 versioning is disabled on buckets, and you must explicitly enable it
    - once enabled, it cannot be disabled, only suspended on the bucket
    - fully integrates with S3 lifecycle rules
    - mfa delta feature provides extra protection against deletion of your data
    - buckets can be in three states:
      - unversioned (default)
      - versioned
      - versioned suspended

    **S3 Object Replication**

      - Object Replication can help you do the following:
        - replicate objects while retaining metadata
        - replicate objects into different storage classes
        - maintain object copies under different ownership
        - keep objects stored over multiple AWS regions
        - replicate object within 15 minutes
        - sync buckets, replicate existing objects, and replicate previously failed or replicated objects
        - replicate objects and fail over to a bucket in another AWS region
      
      - Replication Options in S3
        - **Cross Region Replication** (live-replication)
        - **Same Region Replication** (live-replication)
        - **Bi-Directional Replication** (live-replication)
        - **S3 Batch Replication** (on-demand)
        - and more ...


- **MFA Delete**: Adds an additional layer of security by requiring MFA for the deletion of S3 objects.

- **Object Tags**: Provides a way to categorize storage by assigning key value pairs to S3 objects.

- **In-Transit Encryption**: Protects data by encrypting it as it travels to and from S3 over the internet.
    - When data is encrypted by the sender and then decrypted the receiver.
    - Data that is secure when moving between locations: TLS, SSL.
    - This encryption ensures that data remains confidential and **cannot be intercepted or viewed** by unauthorized parties while in transit.
    - Data will be **encrypted** sender-side.
    - Data will be **decrypted** server-side.
    - Transport Layer Security (TLS)
      - An encryption protocol for data integrity between two or more communicating computer applications.
      - TLS 1.0, 1.1 are depreciated. **TLS 1.2** and **TLS 1.3 is the current best practice**.
    - Secure Sockets Layer (SSL)
      - An encryption protocol for data integrity between two or more communicating computer applications.
      - SSL 1.0, 2.0, and 3.0 are depreciated.

- **Server-Side Encryption**: Automatically encrypts data when writing it to S3 and decrypts it when downloading.
    - When data is encrypted by the server.
    - The server has the key to decrypt when data is requested.
    - **Server-Side Encryption (SSE)** is **always-on** for all new S3 objects.
    - SSE-S3
      - Amazon S3 manages the keys, encrypts using AES-GCM (256-bit) algorithm.
      - S3 encrypts each object with a unique key
      - S3 uses envelope encryption
      - S3 rotates regularly keys automatically
      - By default all objects will have SSE-S3 applied
      - There is no additional charge for using SSE-S3
      - SSE-S3 uses 256-but Advanced Encryption Standard
          - Galois/Counter Mode (AES-GCM) aks AES256

Example (the flag to **explicitly set** SSE-S3):

```sh
aws s3api put-object \
--bucket mybucket \
--key myfile \
--server-side-encryption AES256 \
--body myfile.txt
```

**By default** SSE-S3 will be applied when no SSE configuration is set.

```sh
aws s3api put-object \
--bucket mybucket \
--key myfile \
--body myfile.txt
```
      **Bucket Key can be set for SSE-S3 for improved performance**

    When you use SSE-KMS an individual data key is used on every object request. In this case S3 has to call AWS KMS everytime a request is made. KMS charges on the number of requests and so this charge can add up.

    S3 Bucket Key let's you generate a short-lived bucket level key from AWS Key that is temporarily stored in S3.
    This will reduce request costs by up to 99%.
    This will decrease request traffic and improve overall performance.

    A unique bucket level key is generated for each requester.
    You can enable bucket key at the bucket level to be applied to all new objects.
    You can enable bucket key at the object level for only specific objects.
    S3 bucket key can be enabled for SS3-S3 and SSE-KMS.

    - SSE-KMS
      - AWS Key Management Service (KMS) and you manage the keys
      - You first create a KMS managed key
      - You choose the KMS key to encrypt your object
      - KMS can automatically rotate keys
      - KMS key policy controls who can decrypt using the key
      - KMS can help meet regulatory compliance
      - KMS keys have their own additional costs
      - AWS KMS keys must be in the same Region as the bucket
      - To upload with KMS you need kms:GenerateDateKey
      - To download with KMS you need kms:Decrypt

Example using KMS with **aws s3api**:

```sh
aws s3api put-object \
--bucket mybucket \
--key example.txt \
--body example.txt \ 
--server-side-encryption "aws:kms" \
--ssekms-key-id 123abcd-12ab-34cd-56ef-1234567890ab
```

Example using a KMS key with **aws s3**:

```sh
aws s3 cp example.txt s3://bucket/example.txt \
--sse aws:kms \
--sse-kms-key-id 123abcd-12ab-34cd-56ef-1234567890ab
```

      **Bucket Key can be set for SSE-KMS for improved performance**

    - SSE-C
      - Customer provided key (you manage the keys)
      - When you provide your own encryption key that Amazon S3 then uses the apply AES-256 encryption to your data.
      - You need to provide the encryption key every time you retrieve objects.
        - The encryption key you upload is removed from AMazon S3 memory after each request.
      - There is no additional charge to use SSE-C
      - Amazon S3 will store a randomly salted Hash-based Message Authentication Code (HMAC) of your encryption key to validate future requests.
      - Presigned URLs support SSE-C
      - With bucket versioning different object versions can be encrypted with different keys
      - You manage encryption keys on the client side, you manage any additional safeguards, such as key rotation, on the client side.

Example:
**generate key**
```sh
$BASE64_ENCODED_KEY=(openssl rand 32 | base64)
```
**use key with s3api**
```sh
aws s3api put-object \
--bucket mybucket \
--key myfile \
--body file://myfile.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key $BASE64_ENCODED_KEY \
--sse-customer-key-md5 `echo -n
$BASE64_ENCODED_KEY | base64 --decode |
md5sum | awk '{print $1}' | base64`
```
    - DSSE-KMS
      - Dual-layer server-side encryption. Encrypts client side than server side.
      - It's SSE-KMS with the **inclusion of client-side encryption**
      - It would be more accurate to call it CSE-KMS
      - With DSSE-KMS data is encrypted twice
      - The key used for client-side encryption comes from KMS
      - There are additional charges for DSSE and KMS keys

      - **Encrypt**
        - client-side requests AWS KMS to generate a data encryption key (DEK) using the CMK.
        - KMS sends two versions of the DEK to you: a plaintext version and an encrypted version
        - You use the plaintext DEK to encrypt your data locally and then discard it from memory
        - encrypted version of the DEK is stored alongside the encrypted data in Amazon S3

      - **Decrypt**
        - You retrieve the encrypted data and the associated encrypted DEK
        - You send the encrypted DEK to AWS KMS which decrypts it using the corresponding CMK and returns the plaintext DEK
        - Use the plaintext DEK to decrypt the data locally and then discard the DEK from memory


Example:

```sh
aws s3api put-object \
--bucket mybucket \
--key example.txt \
--server-side-encryption "aws:kms:dsse" \
--ssekms-key-id 123abcd-12ab-34cd-56ef-1234567890ab \
--body example.txt 
```


    **Server-side encryption only encrypts the contents of an object, not its metadata**

- **Client-Side Encryption**: Encrypts data client-side before uploading to S3 and decrypts it after downloading.
    - When data is encrypted by the client and then sent to the server.
    - The client has the key, the server will serve the encrypted file since it does not have the key to decrypt when data is requested.

    **Client-Side Encryption**  is when you encrypt your own files before uploading them to S3. This provides a guarantee that AWS and no third-party can decrypt your data.

    Various AWS SDK's have built in code to make it easy to encrypt your data.

- **Compliance Validation for Amazon S3**: Ensures S3 services meet compliance requirements like HIPAA, GDPR, etc.

- **Infrastructure Security**: Protects the underlying infrastructure of the S3 service, ensuring data integrity and availability.

## S3 Data Consistency

  **What is data consistency?**
  When data being is kept in two different places the data should **exactly match**

  **Strongly Consistent**
  Every time you request data (query) you can expect consistent data to be returned with x time.

  "We will never return to you old data. But you will have to wait at least 2 seconds for the query to return."

  **Eventually Consistent**
  When you request data you may get back inconsistent data within 2 seconds.

  "We are giving you whatever data is currently in the database, you may get new data or old data, but if you wait a little bit longer it will generally be up to data."

  Amazon S3 offers strong consistency for all read, write, and delete operations.
  **Prior to Jan 2020, S3 did not have strong consistency for all S3 operations.**

## S3 Lifecycle

  S3 Lifecycle allows you to automate the storage class changes, archival or deletion of objects

  - can be used together with **versioning**
  - can be applied to both **current** and **previous** versions
  
  There are two type of actions
    - transition actions
    - expiring actions
  
  **Lifecycle Rule Actions**
    - move current versions of objects between storage classes
    - move noncurrent versions objects between storage classes
    - expire current versions of objects
    - permanently delete noncurrent versions of objects
    - delete expired object delete markers of incomplete multipart uploads
  
  **Lifecycle Filters**
    - filter based on prefix
    - filter based on object tags
    - filter based on object size (mix/max)

## S3 Transfer Acceleration

  S3 Transfer Acceleration is a bucket-level feature that provides fast and secure transfer of files **over long distances** between your end users and an S3 bucket.

  Utilizes **CloudFront's** distributed **Edge Locations** to quickly eter the Amazon Global Network

  Instead of uploading you bucket, users use a **distinct endpoint** to route to an edge location
  
  Example:
  https://s3-accelerate.amazonaws.com
  https://s3-accelerate.dualstack.amazonaws.com

  - only supported on **virtual-hosted style requests**
  - buckets cannot contain period and must be DNS compliant
  - it can take up to 20 minutes after Transfer Acceleration is enabled

Example:

Enable Transfer Acceleration on the bucket.
```sh
aws s3api put-bucket-accelerate-configuration \
--bucket mybucket \
--accelerate-configuration Status=Enabled
```

Ensure you are using virtual-hosted style requests.
```sh
aws configure set s3.address_style virtual
```

Utilize the --endpoint-url flag to ensure the S3 Transfer Acceleration endpoint is being used.
```sh
aws s3 cp file.txt s3://bucketname/keyname \
--region us-east-1 \
--endpoint-url http://s3-accelerate.amazonaws.com
```

You can optionally tell the AWS CLI to always use the S3 Transfer Acceleration endpoint
```sh
aws configure set default.s3.use_accelerate_endpoint true
```

## S3 Presigned URLs

  S3 Presigned URLs provide temporary access to upload or download object data via URL.

  Presigned URLs are commonly used to provide access to **private objects**

  You can use AWS CLI or AWS SDK to generate a Presigned URL.

Example (the expire is in seconds):
```sh
aws s3 presign s3://mybucket/object \
--expires-in 300
```

Output:
```md
http://mybucket.s3.amazonaws.com/object
?X-Amz-Algorithm=AWS4-HMAC-SHA256
&X-Amz-Credential=YOUR_AWS_ACCESS_KEY%2F20231125%Fus-east-1...
&X-Amz-Date=2031125T123456Z
&X-Amz-Expires=300
&X-Amz-SignedHeaders=host
&X-Amz-Signature=GENERATED_SIGNATURE
```

- X-Amz-Algorithm: specifies the signing algorithm typically AWS4-HMAC-SHA256
- X-Amz-Credential: includes your AWS access key and the scope of the signature
- X-Amz-Date: timestamp of when the signature was created
- X-Amz-Expires: defines the duration for which the URL is valid, in this case, 300 seconds
- X-Amz-SignedHeaders: indicates which headers are part of the signing process
- X-Amz-Signature: the actual signature calculated based on your AWS secret access key, the string to sign, and the signing key.

## Mountpoint for Amazon S3

  **Mountpoint for Amazon S3** allows you to mount an S3 bucket to your Linux local file system.

  Mountpoint is an open source client that you install on your Linux OS and provides high-throughput access to objects with basic file-system operations.

  Mountpoint **can**:

    - read files us to 5TB in size
    - list and read existing files
    - create new files

  Mountpoint **cannot**/does not:

    - modify existing files
    - delete directories
    - support support symbolic links
    - support file locking

  It can be used in the following Storage Classes:

    - S3 Standard
    - S3 Standard IA
    - S3 One-Zone IA
    - Reduced Redundancy Storage (RRS)
    - S3 Glacier Instant Retrieval

  Mountpoint is idea for apps that don't need all the features of a shared file system and POSIX-style permissions but require Amazon S3's elastic throughput to read and write large S3 datasets.

Example Usage:

1. Install Mountpoint (using RPM)
```sh
wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm \
sudo yum install ./mount-s3.rpm
mount-s3 --version
```

2. create a folder
```sh
mkdir ~/mnt
```

3. Mount the bucket to the folder
```sh
mount-s3 mybucket ~/mnt
```

4. go into the folder
```sh
cd mnt
```

5. perform basic filesystem operations
```sh
# perform basic operations
# eg. cat, ls, pwd
```

6. Unmount when done
```sh
unmount ~/mnt
```

## Archived Objects

  Archived Objects are rarely-accessed objects in Amazon S3 that **cannot be accessed in real-time** in exchange for a **reduced storage-cost**

  There are two ways to archive objects:

    1. Archive Storage Classes
      - when you know your access patterns
      - requires manual invention to move data
      - lower costs archive storage costs
      - can use S3 Glacier Flexible Retrieval (minutes to hours)
      - can use S3 Glacier Deep Archive (+12 hours)

    2. Archive Access Tiers
      - when you don't know your access pattern
      - automatically moves data
      - slightly higher cost than archive storage classes
      - can use S3 Intelligent-Tiering Archive Access tier (within minutes)
      - can use S3 Intelligent-Tiering Deep Archive Access (12+ hours)

## S3 - Requesters Pay

  Requesters Pay bucket option allow the bucker owner to offset specific S3 costs to the requester (the use requesting the data)

  Bucket owner pays for the data storage but the requester pays for the cost to download & request to download.

  When you want to **share data but not incur the charges associated with others accessing the data**
    - **Collaborative Projects**: External partners pay for their own S3 data uploads/downloads
    - **Client Data Storage**: Clients pay for their S3 storage and transfer costs
    - **Shared Educational Resources**: Researchers cover their S3 usage fees, not the institution
    - **Content Distribution**: Distributors/Customers pay for S3 data transfer and downloads

  You can at anytime toggle Enable or Disable Requesters Pay on a bucket.
  - all requests must authenticate involving requester pays buckets
  - requester assumes an IAM role before making their request
    - the IAM policy will have s3:RequestPayer condition
  - anonymous access to that bucket is not allowed on buckets with Requesters Pay

Example Policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::bucket-name/*",
      "Condition": {
        "StringEquals": {
          "s3:RequestPayer": "requester"
        }
      }
    }
  ]
}
```

## S3 - Requesters Pay Header

  Requesters must include x-amz-request-payer in their API request header for:
    - DELETE, GET, HEAD, POST and PUT requests
    - or as a parameter in a REST request
  
  In practice using the Requester Pay API requester header via the AWS CLI or AWS SDK is common.
  Using the AWS CLI you can use **--request-payer** flag to include the header in your object request.

Example with CLI:
```sh
aws s3 cp \
s3://bucket-name/object local/path/object \
--request-payer requester
```

Example using AWS Python SDK:

```py
resp = s3_client.get_object(
  bucket = bucket,
  key = object_key,
  request_payer = 'requester'
)
```

## S3 - Requesters Pay Troubleshooting

  - **403 (Forbidden Request)** HTTP Error code will occure in the following scenarios:
    - the requester doesn't include the parameter x-amz-request-payer
    - request authentication fail s(something is wrong with the IAm role or IAM policy)
    - the request is anonymous
    - the request is a SOAP request (SOAP requests are not allowed when requesters pay is turned on)
  
  **In the case the requesters forget to include the header, than 403 will occure, no charge will occur to the requester. No charge will occur to the bucket owner.**


## AWS Marketplace for S3

  The AWS Marketplace for S3 provides alternatives to AWS Services that work with Amazon S3.

  **Storage and Backup Recovery**:
    AWS Services:
      - FSx for Lustre
      - Tape Gateway
      - File Gateway

    Third-Party Services:
      - Veeam Backup for AWS
      - Druva: AWS Backup and Disaster Recovery

  **Data Integration and Analytics**:
    AWS Services:
      - Transfer Family
      - DataSync
      - Athena

    Third-Party Services:
      - ChaosSearch
      - Logz.io
      - BryteFlow Enterprise Edition

  **Observability and Monitoring**:
    AWS Services:
      - CloudTrail
      - CloudWatch

    Third-Party Services:
      - DataDog, Splunk, Dynatrace

  **Security and Threat Detection**:
    AWS Services:
      - GaurdDuty
      - Macie

    Third-Party Services:
      - Trend Cloud One
      - InsightIDR (Rapid7)
      - VM-Series Virtual Next Generation Firewalls (NGFW) (Palo Alto Networks)

  **Permissions**:
    AWS Services:
      - IAM

    Third-Party Services:
      - OneLogin Workforce Identity
      - FileCloud EFSS
      - Yarkon S3 Server

## S3 Batch Operations (Console Only Process)

  - S3 Batch operations performs **large-scale** batch operations on Amazon S3 objects
    *billions of object containing exabytes of data*

  The following Batch Operation Types can be performed:
    - Copy: Copies each object listed in the manifest to the specified destination bucket
    - Invoke AWS Lambda function: Run a Lambda function against each object
    - Replace all object tags: Replaces the Amazon S3 object tags of each object
    - Replace access control list (ACL): Replaces the (ACLs) for each object
    - Restore: Sends a restore request to S3 Glacier
    - Object Lock retention: Prevents overwriting or deletion for a fixed amount of time
    - Object Lock legal hold: Prevents overwriting or deleting until the legal hold is removed

  In order to perform a batch operation you need to provide lists of objects in an S3 or supply S3 Inventory report manifest.json.
  You can have Batch Operation generate out a completion report to audit the outcome bulk operation.

## Amazon S3 Inventory

  Amazon S3 Inventory takes inventory of objects in an S3 bucket on a repeating schedule so you have an audit history of object changes.

  Amazon S3 will output the inventory into the destination of another S3 Bucket.

  Frequency:
    - Daily
      - delivered within 48 hours
    - Weekly
      - First report delivered within 48 hours
      - Future reports every Sunday
  Output Format:
    - CSV (Comma-separated values)
    - ORC (Apache Optimized Columnar)
    - Parquet (Apache Parquet)

  Inventory Scope:
    - Specific prefixes to filter objects
    - Specific all or only current versions

  You can specify additional metadata to be included in the report.

# Amazon S3 Select
  - S3 Select lets you use a Structured Query Language (SQL) to filter contents of S3 objects.

  works on objects stored in:
    - CSV, JSON, or Apache Parquet
  works with objects that are compressed with
    - GZIP or BZIP2 (for CSV and JSON objects only)
  works on objects that are
    - server-side encrypted objects

  You can get results back in JSON or CSV

  It can be used in the following Storage Classes:
    - S3 Standard
    - S3 Intelligent-Tiering
    - S3 Standard IA
    - S3 One-Zone IA
    - S3 Glacier Instant Retrieval

Example:

```sh
aws s3api select-object-content \
--bucket my-bucket \
--key my-data-file.csv \
--expression "select * from s3object limit 100" \
--expression-type 'SQL' \
--input-serialization '{"CSV": {}, "CompressionType": "NONE"}' \
--output-serialization '{"CSV": {}}' "output.csv"
```

## S3 Event Notifications

  S3 Event Notifications allows your bucket to notify other AWS Services about S3 event data.

  S3 Event Notifications makes **application integration very easy** for S3.

  Notification Events:
    - new object created events
    - object removal events
    - restore object events
    - reduced redundancy storage (rss) object lost events
    - replication events
    - s3 lifecycle expiration events
    - s3 lifecycle transition events
    - s3 intelligent-tiering automatic archival events
    - object tagging events
    - object acl PUT events

  Possible Destination to other AWS Services
    - Amazon Simple Notification Service (SNS) topics
    - Amazon Simple Queue Service (SQS) queues
      - FIFO not supported
    - AWS Lambda Function
    - Amazon EventBridge

  **Amazon S3 event notifications are designed to be delivered at least once, notifications are delivered in seconds but can sometimes take a minute or longer**

# S3 Storage Class Analysis

  Storage Class Analysis allows you to analyze storage access patterns of objects within a bucket to recommend objects to move between STANDARD to STANDARD_IA

Example:

```sh
aws s3api put-bucket-analytics-configuration \
--bucket my-bucket --id 1 \
--analytics-configuration '{"Id": "1", "StorageClassAnalysis": {}}'
```

  - observes the infrequent access patterns of a filtered set of data over a period of time
  - you can have multiple analysis filters per bucket (up to 100 filters)
  - the results can be exported to CSV
    - export this daily usage to an S3 bucket
    - use data in Amazon QuickSight for data visualization
  - provides storage usage visualizations in the Amazon S3 console that are updated daily
  - after a filter is applied the analysis will be available 24 to 48 hors
  - storage class analysis will analyze an object for 30 days or longer to gather enough information

# S3 Storage Lens

  Amazon S3 Storage Lens is a storage analysis tool for S3 buckets across your entire AWS organization

    - how much storage you have across your organization
    - which are the fastest-growing buckets and prefixes
    - identify cost-optimization opportunities
    - implement data-protection and access-management best practices
    - improve the performance of application workloads
    - metrics can be exported as CSV or Parquet to another S3 bucket
    - usage and metrics can be exported to Amazon CloudWatch

    **S3 Storage Lens aggregates metrics and displays the information in the Account Snapshot as an interactive dashboard that is updated daily.**


# S3 Static Website Hosting

  S3 Static Website Hosting allows you to host and serve a static website from an S3 bucket.

  S3 website endpoints do not support HTTPS
    - Amazon CloudFront must be used to serve HTTPS traffic
  
  S3 Static Website hosting will provide a website endpoint

  Example:
  ```md
  http://bucket-name.s3-website-region.amazonaws.com
  http://bucket-name.s3-website.region.amazonaws.com
  ```

  The format of the website endpoint varies based on region that will either have a hyphen or a period.

  There are two hosting types (via the console)
    - Host a static website
    - Redirect request to objects

  Requester Pays buckets do not allow access through a website endpoint.

# Amazon S3 Multipart Upload

  Amazon S3 supports multipart upload so you can upload a single object in a set of parts.

  Multipart upload advantages:
    - improved throughput
    - in case of network fail you just need to reupload the missing parts
    - once you start a multipart upload, you can upload parts at any time, there is no expiry time to upload
    - you can upload files while you're creating a file

  **For files that are +100MB multipart upload is recommended**

Example:

1. First need to initiate an upload which will return back an Upload ID

```sh
aws s3api create-multipart-upload \
--bucket my-bucket \
--key 'myfile'
```

2. Then upload each part by provided the Upload ID. 
  - parts can be numbered from 1 to 1000
  - collect all the etags for each part

```sh
aws s3api upload-part \
--bucket my-bucket \
--key 'myfile' \
--part-number 1 \
--body part01 \
--upload-id 'aFDKLJDLSKFu48JDF...'
```

3. Then tell S3 that upload is finished
  - need to provide a JSON file with all etags corresponding to each part

```sh
aws s3api complete-multipart-upload \
--bucket my-bucket \
--key 'myfile' \ 
--multipart-upload file://parts.json \
--upload-id 'aFDKLJDLSKFu48JDF...'
```

*parts.json*
```json
{
  "Parts": [
    {"PartNumber": 1, "ETag": "ETAGFORPART1"},
    {"PartNumber": 2, "ETag": "ETAGFORPART2"},
    {"PartNumber": 3, "ETag": "ETAGFORPART3"}
  ]
}
```

## Amazon S3 Byte Range Fetching

  Amazon S3 allows you to **fetch a range of bytes** of data from S3 Objects using the Range header during S3 GetObject API Requests.

Example:

```py
import boto3

s3 = boto3.client('s3')
bucket_name = 'bucket-name'
object_key = 'object-key'

# get the first 100 bytes
byte_range = 'bytes=0-99'
response = s3.get_object(Bucket='mybucket', Key='myobject.txt', Range=byte_range)

# read the partial context
data = response['Body'].read()
```
  - Amazon S3 allows for concurrent connections so you can request multiple parts at the same time.
  - Fetching smaller ranges of a large object also allows your application to improve retry times when requests are interrupted.
  - Typical sizes for byte-range request are between 8-16MB.

Boto3 example opening multiple concurrent S3 connections, holding each part in memory and then reassembling the parts back into a single file:

```py
import boto3

s3 = boto3.client('s3')
bucket = 'b'
ket = 'k'

brange = ['bytes=0-99', 'bytes=100-199', 'bytes=200-299']

# fetch the parts
parts = []
for byte_range in byte_ranges:
  response = s3.get_object(Bucket=bucket, Key=key, Range=brange)
  parts.append(response['Body'].read())

# concatenate the parts
complete_file = b''.join(parts)

# write the complete file to disk
with open('output_file', 'wb') as f:
  f.write(complete_file)

```

*Depending how large the file is you might need to write each part to disk if your program does not have enough memory to hold all parts.*

## S3 Interoperability

  What is Interoperability?

  Interoperability in the context of cloud services is **the capability of cloud services to exchange and utilize information seamlessly with each other.

  Here are common AWS services that often dump data into S3:
    - Amazon EC2: stores snapshots and backups in S3
    - Amazon RDS: Backups and data exports to S3
    - AWS CloudTrail: Stores API call logs in S3
    - Amazon CloudWatch Logs: Exports logs/metric to S3
    - AWS Lambda: Outputs data/logs to S3
    - AWS Glue: ETL results stored in S3
    - Amazon Kinesis: Data streaming to S3 via Firehose
    - Amazon EMR: Uses S3 for input/output data storage
    - AWS Redshift: Unloads data to S3
    - AWS Data Pipeline: Moves/transforms data to/from S3
    - Amazon Athena: Outputs query results to S3
    - AWS IoT Core: Stores IoT data in S3

