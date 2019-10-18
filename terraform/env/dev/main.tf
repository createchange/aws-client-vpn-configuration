provider "aws" {
  alias = "use1"
  region = "us-east-1"
}

module "acm" {
  source = "../../modules/acm"
  providers = {
    aws = "aws.use1"
  }
}
