#!/usr/bin/env python3
import boto3
import sys

# Create an S3 client
s3 = boto3.client('s3')

filename = sys.argv[1]
output = sys.argv[2]
bucket_name = 'csc4006benchbucket'

# Uploads the given file using a managed uploader, which will split up large
# files automatically and upload parts in parallel.
s3.upload_file(filename, bucket_name, output)
