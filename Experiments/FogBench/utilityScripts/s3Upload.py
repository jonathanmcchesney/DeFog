#!/usr/bin/env python3
import boto3
import sys

# Create an S3 client
s3 = boto3.client('s3')

filename = sys.argv[1] # first parameter
bucket_name = 'csc4006benchbucket' # update to change destination

# Uploads the given file using a managed uploader, which will split up large
# files automatically and upload parts in parallel.
s3.upload_file(filename, bucket_name, filename)
