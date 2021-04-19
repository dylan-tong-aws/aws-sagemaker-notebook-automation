#!/bin/bash

help()
{
    echo "Usage: -region <aws-region> -account <account-id> -role <role-arn>"
}

while getopts "region:account:role" opt
do
   case "$opt" in
      region ) region="$OPTARG" ;;
      account ) account="$OPTARG" ;;
      role ) role="$OPTARG" ;;
      ? ) help ;;
   esac
done

if [ -z "$region" ] || [ -z "$account" ] || [ -z "$role" ]
then
   help
fi

# Build the image
IMAGE_NAME=smstudio-tf-snowflake
aws --region $region ecr get-login-password | docker login --username AWS --password-stdin $acccount.dkr.ecr.$region.amazonaws.com/smstudio-custom
docker build . -t $IMAGE_NAME -t $account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME

docker push $account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME

aws --region $region sagemaker create-image \
    --image-name $IMAGE_NAME \
    --role-arn $role

aws --region $region sagemaker create-image-version \
    --image-name $IMAGE_NAME \
    --base-image "$account.dkr.ecr.$region.amazonaws.com/smstudio-custom:$IMAGE_NAME"

# Verify the image-version is created successfully. Do NOT proceed if image-version is in CREATE_FAILED state or in any other state apart from CREATED.
aws --region $region sagemaker describe-image-version --image-name $IMAGE_NAME
#Create a AppImageConfig for this image
aws --region $region sagemaker create-app-image-config --cli-input-json file://app-image-config-input.json
#Update existing domain
aws --region $region sagemaker update-domain --cli-input-json file://update-domain-input.json




