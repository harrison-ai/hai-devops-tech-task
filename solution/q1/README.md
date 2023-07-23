# Solution to question 1

## Terraform

```
cd terraform
```

### v1.5.0+

New [config-driven import](https://www.hashicorp.com/blog/terraform-1-5-brings-config-driven-import-and-checks) allows to declare what resources are planned for import via `import` blocks.
Their code is generated at plan step with the help of `-generate-config-out` argument.
Once plan is applied, new (generated) code is committed to the repository.

Configuration for both buckets is split between 2 files: `main.tf` and `annalise_ai_generated.tf`.
I am using config-driven import to acquire Annalise AI bucket into TF state. The workflow assumes 
that only `main.tf` exists initially, later once plan with new generated code is applied (and annalise resources are confirmed to be present in the state via `terraform state list`) - `annalise_ai_generated.tf`
is committed into the repo.
```
terraform init
terraform plan -generate-config-out=annalise_ai_generated.tf
# review contents of annalise_ai_generated.tf
terraform apply
# confirm that bucket is present in TF state
# commit annalise_ai_generated.tf into the repo
```

To avoid naming conflicts, `cd-test` bucket name prefix is used.

This setup assumes that both buckets are owned by same account, which is unlikely the real case.
To accomodate for cases when `annalise-ai-datalake` bucket is owned by another account,
append its account ID in the end of all buckets in `import` blocks:

### < v1.5.0

Is using TF 1.5.0 is not possible, the old way of importing existing infrastructure would be via
conditional flags and manual `terraform import` command. So the flow would be next:

1. Add `count` fields to all resources related to `annalise-ai-datalake` bucket:
2. Set `annalise_bucket_migrated` variable and set it to `false`:
3. Run `terraform import` of all resources related to that bucket (bucket itself, acl, public access, SSE...):
4. Change `annalise_bucket_migrated` to `true`:

## Utility script

```
cd util
```

To copy files between `annalise-ai-datalake` and `harrison-ai-landing` buckets, we use simple program
in Go. It uses basic S3 API calls to list files in source bucket (`annalise-ai-datalake`) and copy them
to destination (`harrison-ai-landing`). To accelerate the process, simple concurrency with channel
and goroutines is used - `listS3Keys` produces the list of all keys into `keyChannel` which is later consumed
by one or several goroutines (~threads) to do concurrent `copyS3Object` calls. There should be a reasonable
limit to concurrency, local tests on 30G of dataset show that 4-core CPU can efficiently run 16 goroutines,
without too much of CPU saturation (never reaches 90%) and more than twice faster throughput than default
aws cli tools (`aws s3 sync`).

To use the script, build it with docker and execute with AWS credentials passed as environment variables:
```
docker build -t util-q1:0.0.3 .
docker run --rm -ti \
  -e SRC_BUCKET=cd-test-annalise-ai-datalake \
  -e DST_BUCKET=cd-test-harrison-ai-landing \
  -e AWS_ACCESS_KEY_ID=$(grep aws_access_key_id ~/.aws/credentials | awk '{print $3}') \
  -e AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key ~/.aws/credentials | awk '{print $3}') \
  util-q1:0.0.3
```

The script has verbose logging to standard output to track the progress - it can be useful when executed in
managed environment, like Jenkins / RunDeck / GH actions / Octopus Deploy. If there was unexpected failure during execution, `START_KEY` can be used to continue from latest copied file (obtained from logging output
of previous interrupted execution):
```
docker run --rm -ti \
  ...
  -e START_KEY=123456789012345678901234567890.ext
  ...
  util-q1:0.0.3
```

The copy process should start from exactly same place where it failed, unless the object was deleted
in source bucket. If it's the case, just pick the closest existing to the one that failed that appears 
in `listS3Keys` output.