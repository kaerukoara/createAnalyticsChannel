#!/usr/bin/env bash

set -e

BUCKET_NAME=$1

if [ -z "$BUCKET_NAME" ];
then
  echo "A bucket name must be specified"
  exit 1
fi


echo "Launching (or updating) stack iot-analytics-stack"

# Use this value if you have multiple profiles
# PROFILE="--profile default"
PROFILE=""

TEMP_FILE=$(mktemp)
aws cloudformation package --template-file infra.yaml --s3-bucket $BUCKET_NAME --output-template-file $TEMP_FILE
aws cloudformation $PROFILE deploy --stack-name iot-analytics-stack --template-file $TEMP_FILE --capabilities CAPABILITY_NAMED_IAM || aws cloudformation $PROFILE describe-stack-events --stack-name iot-analytics-stack
rm $TEMP_FILE
