import boto3
import json
import hashlib

# Replace these values with your AWS credentials and region
aws_access_key_id = 'YOUR_ACCESS_KEY_ID'
aws_secret_access_key = 'YOUR_SECRET_ACCESS_KEY'
region_name = 'ap-southeast-2'
bucket_name = 'YOUR_BUCKET_NAME'
queue_url = 'YOUR_QUEUE_URL'
session = boto3.Session()
s3_client = session.client('s3', aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, region_name=region_name)
sqs_client = session.client('sqs', aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, region_name=region_name)

def list_s3_objects(bucket):
    response = s3_client.list_objects(Bucket=bucket_name)
    objects = []
    if 'Contents' in response:
        objects = response['Contents']

    for obj in objects:
        key = obj['Key']
        hashkey = hashlib.sha256(key.encode('utf-8')).hexdigest() + ".ext"
        message_body = {
            'bucket': bucket_name,
            'key': hashkey
        }
    
        sqs_message = json.dumps(message_body)
        response = sqs_client.send_message(QueueUrl=queue_url, MessageBody=sqs_message)

    return response

def main():
    list_s3_objects(bucket_name)

if __name__ == '__main__':
    main()
