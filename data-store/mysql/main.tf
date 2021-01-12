provider "aws" {
  region = "eu-west-2"
}
resource "aws_db_instance" "example" {
  identifier_prefix   = "collinsongroup"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database"
  username            = "admin"
  password            = "password"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-remote-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {

    bucket = "terraform-remote-state"
    key    = "data-store/mysql/terraform.tfstate"
    region = "eu-west-2"
  }
}