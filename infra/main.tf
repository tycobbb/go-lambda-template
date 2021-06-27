terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

// conf localstack provider
provider "aws" {
  region                      = var.region
  s3_force_path_style         = true
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  // conf all services to use localstack url
  endpoints {
    lambda = var.endpoint
    iam    = var.endpoint
  }
}

// lambda: endpoint
resource "aws_lambda_function" "echo" {
  runtime          = "go1.x"
  function_name    = var.fn_name
  handler          = var.fn_name
  filename         = var.fn_archive
  source_code_hash = filebase64sha256(var.fn_archive)
  role             = aws_iam_role.echo.arn
}

resource "aws_iam_role" "echo" {
  name = var.fn_iam

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
