# Technical Assessment Task for DevOps roles at harrison.ai

This is a technical assessment task for DevOps-related roles at [harrison.ai](harrison.ai). There are three questions, each outlined below.

You should take a copy of this repo, implement your solution for each question, and push them to GitHub for review and discussion in a follow-up interview. You're welcome to use a private repository, as long as it is visible to the following users:

* @rfk
* @comozo
* @schattingh
* @dcarrion87

## Question One

harrison.ai and annalise.ai are business partners.

harrison.ai has an S3 bucket in their AWS Organisation named `harrison-ai-landing`.  Their business partner annalise.ai is required to copy data from an S3 bucket in their own AWS account into the `harrison-ai-landing` bucket, providing harrison.ai with complete ownership of the data.  The Terraform templates that were used to create the `harrison-ai-landing` bucket are available in this repo in the `harrison.ai` directory.

The S3 bucket in annalise.ai was created manually in the AWS Console and already contains all the data ready to be copied.  It contains approximately 100 million objects with an average size of 100KB.  The bucket is configured as follows:
- Name: annalise-ai-datalake
- No versioning
- Private ACL
- AES256 encryption

You task is to provide infrastructure-as-code and a playbook for executing the data-copying process:

- Generate the Terraform templates to import the `annalise-ai-datalake` bucket into Terraform in order to manage it as IaC, including any suggested configuration improvements that could be made to the harrison.ai Terraform templates.
- Detail how to import the bucket into Terraform.
- Describe how you would copy the data in `annalise-ai-datalake` to `harrison-ai-landing`.  You may wish to provide Terraform templates for any resources that would be used by this process, but it is not required.
- Please include a README, citing any third-party code, tutorials or documentation you have used.  If your solution includes any unusual deployment steps, please note them in your README file.
- Commit the solution to your copy of this GitHub repository, and push it for review


## Question Two

Provide a script that will list all objects in an S3 bucket and place a message on an SQS queue for each object in the bucket.  The SQS message format should be as follows:

```
{'bucket:' 'my-s3-bucket', 'key': 'my-object'}
```

The naming format of all objects in the bucket is as follows:

```
<sha256 hash digest>.ext
```

e.g:

```
f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2.ext
```

Additionally, describe how you would:

- Speed up the bucket listing process for very large buckets containing millions of objects.
- Handle the process being interrupted before completion.


Commit the solution to your copy of this GitHub repository, and push it for review.


## Question Three (for discussion during the interview)


**This question will be asked and discussed during the interview**.
It is provided here to allow time for any background reading or research that may be required.
Please feel free to add notes or comments in your copy of this GitHub repo for reference,
but this is not required.

You have an S3 bucket that contains 3 billion objects with an average size of 100KB, in the `STANDARD` Storage Class.  You are tasked with moving all objects in the bucket to the `GLACIER` Storage Class.  Describe how you would achieve this, providing justifications for the design decisions you made.
