import json
import boto3


import boto3

client = boto3.client('s3', region_name='il-central-1')

# List objects in the bucket
response = client.list_objects_v2(Bucket='dwh-bucket-file-storage-gateway')

for date_time in response['Contents']:
    # print('File Name: {} Last modified: {}'.format(date_time['Key'],date_time['LastModified']))
    f = open("filesModified.txt", "a")
    f.write("'File Name: {} Last modified: {}'.format(date_time['Key'],date_time['LastModified'])")
f.close()

PutFileS3 = client.put_object(Bucket='dwh-bucket-file-storage-gateway', Key="filesModified.txt")

