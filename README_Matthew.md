## Question One

- Generate the Terraform templates to import the `annalise-ai-datalake` bucket into Terraform in order to manage it as IaC, including any suggested configuration improvements that could be made to the harrison.ai Terraform templates.
Add KMS key
Add S3 bucket-level Public Access Block configuration
Add Bucket security policies
Add intelligent_tiering

- Detail how to import the bucket into Terraform.
Add backend.tf
terraform init
terraform import module.s3_bucket.aws_s3_bucket.this[0] annalise-ai-datalake
terraform plan

- Describe how you would copy the data in `annalise-ai-datalake` to `harrison-ai-landing`.  You may wish to provide Terraform templates for any resources that would be used by this process, but it is not required.
Create s3 access point and IAM Role on harrison-ai-landing
Create VPCE and IAM Role on annalise-ai-datalake
Share harrison-ai-landing kms key with annalise-ai account
aws sts assume-role —role-are "harrison-ai-landing IAM Role" —role-session-name "Data-copy"
aws s3 cp s3://SOURCE_BUCKET_NAME/pathxxx/* s3://"s3 access point alias"/pathxxx/* —sse aws:kms —sse-kms-key-id "harrison-ai-landing kms arn"


- Please include a README, citing any third-party code, tutorials or documentation you have used.  If your solution includes any unusual deployment steps, please note them in your README file.

https://github.com/terraform-aws-modules/terraform-aws-s3-bucket

- Commit the solution to your copy of this GitHub repository, and push it for review


## Question Two

Please find it in list_s3_objects.py

Additionally, describe how you would:

- Speed up the bucket listing process for very large buckets containing millions of objects.
I would like to use S3 paginators/asyncio/ProcessPoolExecutor to list large numbers of keys in parallel
- Handle the process being interrupted before completion.
Configure a DLQ on AWS Lambda to retry

Commit the solution to your copy of this GitHub repository, and push it for review.
