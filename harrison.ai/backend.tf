terraform {
  backend "s3" {
    bucket         =  "harrison-ai-terraform"
    key            =  "harrison-ai-s3.tfstate"
    region         =  "ap-southeast-2"
    dynamodb_table =  "harrison-ai-terraform-state-lock"
    encrypt        =  true
  }
}