require 'aws-sdk-s3'
require 'openssl'

key = OpenSSL::PKey::RSA.new(1024)

# bucket
bucket = 'encrypt-client-fun-ap-12345'
object_key = 'hello.txt'

# encryption client
s3 = Aws::S3::EncryptionV2::Client.new(
    encryption_key: key,
    key_wrap_schema: :rsa_oaep_sha1,
    content_encryption_schema: :aes_gcm_no_padding,
    security_profile: :v2
)

# round-trip an object, encrypted/decrypted locally
resp = s3.put_object(bucket: bucket, key: object_key, body:'handshake')
puts "PUT"
puts resp

resp = s3.get_object(bucket: bucket, key: object_key).body.read
puts "GET WITH KEY"
puts resp

# reading encrypted object without the encryption client
# results in the getting the cipher text
resp = Aws::S3::Client.new.get_object(bucket: bucket, key: object_key).body.read
puts "GET WITHOUT KEY"
puts resp