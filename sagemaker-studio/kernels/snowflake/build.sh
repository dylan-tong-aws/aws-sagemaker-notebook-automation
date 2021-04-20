#!/bin/bash

help()
{
    echo "Usage: -r <aws-region> -a <account-id> -s <role-arn>"
}

while getopts r:a:s: opt;
do
   case "$opt" in
      r) region="${OPTARG}" ;;
      a) account="${OPTARG}" ;;
      s) role="${OPTARG}" ;;
   esac
done

if [ -z "$region" ] || [ -z "$account" ] || [ -z "$role" ]
then
   help
   exit 0
fi

# Build the image
IMAGE_NAME=smstudio-tf-snowflake;
ECR_URI=$account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME;

echo "Logging into ECR.";
aws --region $region ecr get-login-password | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com/smstudio-custom

echo "Building $ECR_URI";
docker build . -t $IMAGE_NAME -t $ECR_URI

#echo "Pushing image to $IMAGE_NAME to $ECR_URI";
#docker push $account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME

#echo "Creating custom SageMaker Image."
#aws --region $region sagemaker create-image \
#    --image-name $IMAGE_NAME \
#    --role-arn $role

#aws --region $region sagemaker create-image-version \
#    --image-name $IMAGE_NAME \
#    --base-image "$account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME"

# Verify the image-version is created successfully. Do NOT proceed if image-version is in CREATE_FAILED state or in any other state apart from CREATED.
#aws --region $region sagemaker describe-image-version --image-name $IMAGE_NAME
#Create a AppImageConfig for this image
#aws --region $region sagemaker create-app-image-config --cli-input-json file://app-image-config-input.json
#Update existing domain
#aws --region $region sagemaker update-domain --cli-input-json file://update-domain-input.json