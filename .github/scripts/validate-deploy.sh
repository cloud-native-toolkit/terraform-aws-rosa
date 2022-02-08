#!/usr/bin/env bash
BIN_DIR=$(cat .bin_dir)
echo "BIN_DIR: ${BIN_DIR}"
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

echo "Login to ROSA cli "
rosa login --token=${AWS_ROSA_TOKEN}

echo "Checking for ROSA cluster :  ${CLUSTER_NAME}"
CLUSTER_DETAILS=$(rosa list clusters )

exit 0