#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CLUSTER_NAME="$1"
REGION="$2"
export AWS_DEFAULT_REGION=${REGION}
export AWS_ACCESS_KEY_ID=${TF_VAR_access_key}
export AWS_SECRET_ACCESS_KEY=${TF_VAR_secret_key}


echo "Inputs CLUSTER_NAME  : ${CLUSTER_NAME} , REGION: ${REGION} "
TMP_DIR="$3"
ROSA_USER_FILE="$4"
CLUSTER_INFO_FILE="$5"

count=0
CLUSTER_STATUS=""

${BIN_DIR}/rosa  login 
${BIN_DIR}/rosa  init --region=${REGION}
${BIN_DIR}/rosa describe cluster --cluster ${CLUSTER_NAME} --region=${REGION} -o json  >>  ${TMP_DIR}/${CLUSTER_INFO_FILE}
eval "$(cat ${TMP_DIR}/${CLUSTER_INFO_FILE} | ${BIN_DIR}/jq -r '@sh "CLUSTER_STATUS=\(.status.state)"')"


echo "cluster_status : ${CLUSTER_STATUS}"
if [[ ${CLUSTER_STATUS} ==  "ready" ]]; then
    echo "Cluster ${CLUSTER_NAME} created and in  ready status"
    ${BIN_DIR}/rosa create admin --cluster ${CLUSTER_NAME} >> ${TMP_DIR}/${ROSA_USER_FILE}
    sleep 60
else 
    if [[ ${CLUSTER_STATUS} ==  "error" ]]; then
        echo "Cluster ${CLUSTER_NAME} is  in error status. Can not  create cluster admin user. Please check the cluster status/ config using rosa describe cluster --cluster=${CLUSTER_NAME} "
        exit 1
    else
        echo "Cluster ${CLUSTER_NAME} is NOT in ready status. Can not  create cluster admin user. Please check the cluster status/ config using rosa describe cluster --cluster=${CLUSTER_NAME} "            
    fi
fi

