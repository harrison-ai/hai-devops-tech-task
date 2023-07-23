# Solution to question 2

## Utility script

Similar to what was used in Question 1, except one difference: on consuming end of the channel,
messages are written to SQS (instead of being copied to landing bucket).

To use the script, same routine (build and execute with AWS creds in the env):
```
cd util
docker build -t util-q2:0.0.1 .
docker run --rm -ti \
  -e SRC_BUCKET=cd-test-annalise-ai-datalake \
  -e QUEUE_URL=https://sqs.ap-southeast-2.amazonaws.com/070364244157/queue-for-s3 \
  -e AWS_ACCESS_KEY_ID=$(grep aws_access_key_id ~/.aws/credentials | awk '{print $3}') \
  -e AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key ~/.aws/credentials | awk '{print $3}') \
  util-q2:0.0.1
```

The script has same verbose logging / START_KEY handle to be able to restart from last failure. 
```
docker run --rm -ti \
  ...
  -e START_KEY=123456789012345678901234567890.ext
  ...
  util-q2:0.0.1
```

## Big amount of data

To cope with big amount of data in datalake bucket, one could generate list of files with AWS Athena
and shard it into N chunks. Later launch N instances of this script in parallel. Those instances should
be able to communicate with "main" instance over HTTP, since processes might be distributed across multiple
VMs.