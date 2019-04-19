#!/usr/bin/env python3
import boto3 # AWS utility
import sys # System utility to accept command line arguements

# Create an S3 boto client
s3 = boto3.client('s3')

# instatntiate the input filename/path to transfer and S3 bucket name
filename = sys.argv[1] # first parameter
bucket_name = 'csc4006benchbucket' # update to change destination

# Uploads the parameter filename/path input using a managed uploader, which will split up large
# files automatically and upload parts in parallel.
s3.upload_file(filename, bucket_name, filename)
