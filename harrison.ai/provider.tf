terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  alias   = "harrison-ai"
  region  = local.region
  profile = local.profile1
}

provider "aws" {
  alias   = "annalise-ai"
  region  = local.region
  profile = local.profile2
}
