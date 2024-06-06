require 'aws-sdk-s3'   # Load the AWS SDK for Ruby, specifically for S3 services.
require 'pry'          # Load the Pry gem, which is a powerful alternative to the standard IRB shell for Ruby.
require 'securerandom' # Load the SecureRandom library for generating random UUIDs.

# Define the S3 bucket name from the environment variables.
bucket_name = ENV['BUCKET_NAME']
region = 'us-east-2'

# Initialize the AWS S3 client.
client = Aws::S3::Client.new

# Create the S3 bucket if it doesn't already exist.
resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
        location_constraint: region  # Specify the region where the bucket will be created.
    }
})


# Randomly determine the number of files to create and upload, between 1 and 6.
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Loop through the number of files to create.
number_of_files.times.each do |i|
    puts "i: #{i}"
    filename = "file_#{i}.txt"   # Generate a filename based on the current index.
    output_path = "/tmp/#{filename}"  # Define the local path where the file will be created.

    # Create a file at the specified path and write a random UUID to it.
    File.open(output_path, 'w') do |f|
        f.write(SecureRandom.uuid)
    end

    # Read the created file and upload it to the S3 bucket.
    File.open(output_path, 'rb') do |f|
        client.put_object(
            bucket: bucket_name,
            key: filename,
            body: f
        )
    end
end