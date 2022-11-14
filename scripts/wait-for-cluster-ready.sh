#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

CLUSTER_NAME="$1"
REGION="$2"
export AWS_DEFAULT_REGION=${REGION}
export AWS_ACCESS_KEY_ID=${TF_VAR_access_key}
export AWS_SECRET_ACCESS_KEY=${TF_VAR_secret_key}


echo "Inputs CLUSTER_NAME  : ${CLUSTER_NAME} , REGION: ${REGION} "

count=0
${BIN_DIR}/rosa  login 
${BIN_DIR}/rosa  init --region=${REGION}
while true ; do
  cluster_status=$(${BIN_DIR}/rosa describe cluster --cluster ${CLUSTER_NAME} --region=${REGION} -o json | ${BIN_DIR}/jq -r ."status.state")
  
  echo "cluster_status : ${cluster_status}"
  if [[ ${count} -gt 12 ]]; then
    echo "Timed out waiting for cluster ${CLUSTER_NAME} status to be ready"
    break;
  else 
     
    if [[ ${cluster_status} ==  "ready" ]]; then
      echo "Cluster ${CLUSTER_NAME} created and in  ready status"
      break;
    fi
    if [[ ${cluster_status} ==  "error" ]]; then
      echo "Cluster ${CLUSTER_NAME} creation in error state. Please review logs."
      exit 1;
    fi
  fi
  
  count=$((count + 1)) 
  echo "Waiting for cluster - ${CLUSTER_NAME} status to be ready "
  sleep 300
done
