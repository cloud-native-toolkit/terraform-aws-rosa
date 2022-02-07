#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
PREFIX_NAME=$(cat terraform.tfvars | grep prefix_name | sed "s/prefix_name=//g" | sed 's/"//g' | sed "s/_/-/g")
REGION=$(cat terraform.tfvars | grep -E "^region" | sed "s/region=//g" | sed 's/"//g')
CLUSTER_NAME=$(cat terraform.tfvars | grep -E "^cluster_name" | sed "s/cluster_name=//g" | sed 's/"//g')

#VPC_NAME="${PREFIX_NAME}-vpc"
#echo "VPC_NAME: ${VPC_NAME}"
echo "REGION: ${REGION}"

aws configure set region ${REGION}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}

echo "Checking for ROSA cluster :  ${VPC_ID}"
CLUSTER_DETAILS=$(rosa list clusters )

exit 0