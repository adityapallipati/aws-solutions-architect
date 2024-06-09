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
- Object Prefixes: simulates file system folders in a flat hierarchy
- Object Metadata: attach data alongside the content, to describe the contents of the data
- Object tags: benefits resource tagging but at the object level
- Object Locking: makes data files immutable
- Object Versioning: have multiple versions of a data file

## Bucket Versioning
"how we can version all objects"

## Bucket Encryption
"how we can encrypt the contents of a bucket"

## Static Website Hosting
"how we can let our bucket host websites"

**S3 is a globally available service but when you create a bucket you specify a region**
