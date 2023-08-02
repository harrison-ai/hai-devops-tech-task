resource "aws_s3_bucket" "this" {
  bucket  = "harrison-ai-landing"
  acl     = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7

    providers = {
    aws = aws.annalise-ai
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.bucket_name

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

    tags = {
      Owner = "annalise-ai"
  }

  
  # Bucket policies
  attach_policy                            = true
#  policy                                   = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = aws_kms_key.objects.arn
  attach_deny_unencrypted_object_uploads   = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  intelligent_tiering = {
    general = {
      status = "Enabled"
      filter = {
        prefix = "/"
        tags = {
          Environment = "dev"
        }
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 180
        }
      }
    }
  }
  
  providers = {
    aws = aws.annalise-ai
  }

}