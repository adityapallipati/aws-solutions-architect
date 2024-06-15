require 'openssl'
key = OpenSSL::PKey:RSA,new(1024)

# encryption client
s3 = Aws::S3::Encryption::Client.new(encryption_key: key)

# round-trip an object, encrypted/decrypted locally
s3.put_object(bucket:'aws-sdk', key:'secret', body:'handshake')
s3.get_object(bucket:'aws-sdk', key:'secret').body.read

# reading encrypted object without the encryption client
# results in the getting the cipher text
Aws::S3::Client.new.get_object(bucket:'aws-sdk', key:'secret').body.read
