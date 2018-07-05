#!/bin/sh
set -ex

aws cloudformation create-stack \
  --stack-name terraform-demo \
  --region ap-southeast-2 \
  --template-body file://template.json \
  --parameters ParameterKey=HashKeyElementName,ParameterValue=hash
