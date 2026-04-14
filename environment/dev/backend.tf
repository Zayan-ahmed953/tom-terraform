terraform {
  backend "s3" {
    bucket         = "aisrc-terraform-state"
    key            = "terraform/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "aisrc-terraform-state-lock"
  }
}
