/* Source bucket, Annalise AI

Using new config-driven import feature (requires TF v1.5.0) 
https://developer.hashicorp.com/terraform/language/import/generating-configuration

*/

import {
  to = aws_s3_bucket.src_bucket
  id = "cd-test-annalise-ai-datalake"
}

import {
  to = aws_s3_bucket_ownership_controls.src_bucket_oc
  id = "cd-test-annalise-ai-datalake"
}

import {
  to = aws_s3_bucket_acl.src_bucket_acl
  id = "cd-test-annalise-ai-datalake"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.src_bucket_sse
  id = "cd-test-annalise-ai-datalake"
}

import {
  to = aws_s3_bucket_public_access_block.src_bucket_access
  id = "cd-test-annalise-ai-datalake"
}

// Destination bucket, Harrison AI

resource "aws_s3_bucket" "dst_bucket" {
  bucket = "${var.bucket_prefix}-harrison-ai-landing"
}

resource "aws_s3_bucket_ownership_controls" "dst_bucket_oc" {
  bucket = aws_s3_bucket.dst_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "dst_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.dst_bucket_oc]

  bucket = aws_s3_bucket.dst_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "dst_bucket_sse" {
  bucket = aws_s3_bucket.dst_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "dst_bucket_access" {
  bucket                  = aws_s3_bucket.dst_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
