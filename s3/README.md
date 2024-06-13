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
    - Below example only allows a specific role to read objects with prod object tag

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
    - Below example restricts access to specific IP

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

- **Inter-network Traffic Privacy**: Ensures data privacy by encrypting data moving between AWS services and the Internet.

- **Object Ownership**: Manages data ownership between AWS accounts when objects are uploaded to S3 buckets.

- **Access Points**: Simplifies managing data access at scale for shared datasets in S3.

- **Access Grants**: Providing access to S3 data via directory services eg Active Directory

- **Versioning**: Preserves, retrieves, and restores every version of every object stored in an S3 bucket.

- **MFA Delete**: Adds an additional layer of security by requiring MFA for the deletion of S3 objects.

- **Object Tags**: Provides a way to categorize storage by assigning key value pairs to S3 objects.

- **In-Transit Encryption**: Protects data by encrypting it as it travels to and from S3 over the internet.

- **Server-Side Encryption**: Automatically encrypts data when writing it to S3 and decrypts it when downloading.

- **Client-Side Encryption**: Encrypts data client-side before uploading to S3 and decrypts it after downloading.

- **Compliance Validation for Amazon S3**: Ensures S3 services meet compliance requirements like HIPAA, GDPR, etc.

- **Infrastructure Security**: Protects the underlying infrastructure of the S3 service, ensuring data integrity and availability.

