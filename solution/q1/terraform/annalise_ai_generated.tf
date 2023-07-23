# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "cd-test-annalise-ai-datalake"
resource "aws_s3_bucket_public_access_block" "src_bucket_access" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "cd-test-annalise-ai-datalake"
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# __generated__ by Terraform from "cd-test-annalise-ai-datalake"
resource "aws_s3_bucket_server_side_encryption_configuration" "src_bucket_sse" {
  bucket                = "cd-test-annalise-ai-datalake"
  expected_bucket_owner = null
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = null
      sse_algorithm     = "AES256"
    }
  }
}

# __generated__ by Terraform from "cd-test-annalise-ai-datalake"
resource "aws_s3_bucket_ownership_controls" "src_bucket_oc" {
  bucket = "cd-test-annalise-ai-datalake"
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# __generated__ by Terraform from "cd-test-annalise-ai-datalake"
resource "aws_s3_bucket_acl" "src_bucket_acl" {
  acl                   = null
  bucket                = "cd-test-annalise-ai-datalake"
  expected_bucket_owner = null
  access_control_policy {
    grant {
      permission = "FULL_CONTROL"
      grantee {
        email_address = null
        id            = "68d919450898ab8e94e05859f59772abdf5993d0f616fedd20533f5e17724fa2"
        type          = "CanonicalUser"
        uri           = null
      }
    }
    owner {
      display_name = "c"
      id           = "68d919450898ab8e94e05859f59772abdf5993d0f616fedd20533f5e17724fa2"
    }
  }
}

# __generated__ by Terraform from "cd-test-annalise-ai-datalake"
resource "aws_s3_bucket" "src_bucket" {
  bucket              = "cd-test-annalise-ai-datalake"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all            = {}
}
