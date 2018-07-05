provider "aws" {
  region = "ap-southeast-2"
}

resource "null_resource" "pre_cmd" {
  triggers {
    uuid = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "echo 'Start run.'"
  }
}

data "aws_region" "current" {}

resource "aws_s3_bucket" "cfn_templates" {
  bucket = "bp-demo-aws-terraform-${data.aws_region.current.name}"
}

resource "aws_s3_bucket_object" "cfn_template" {
  bucket                 = "${aws_s3_bucket.cfn_templates.id}"
  key                    = "dynamodb.json"
  source                 = "template.json"
  server_side_encryption = "AES256"
}

resource "aws_cloudformation_stack" "dynamodb" {
  depends_on   = ["null_resource.pre_cmd", "aws_s3_bucket_object.cfn_template"]
  name         = "terraform-demo"
  template_url = "https://${aws_s3_bucket.cfn_templates.bucket_regional_domain_name}/${aws_s3_bucket_object.cfn_template.id}"

  parameters = {
    HashKeyElementName = "hash"
  }

  provisioner "local-exec" {
    command = "echo 'Run finished.'"
  }
}
