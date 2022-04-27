#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

CLUSTER_NAME="$1"
REGION="$2"
export AWS_DEFAULT_REGION=${REGION}
echo "Inputs CLUSTER_NAME  : ${CLUSTER_NAME} , REGION: ${REGION} "
export ROSA_TOKEN="$3"
# BIN_DIR=$(cat .bin_dir)
# cat .bin_dir

BIN_DIR="$4"
# if [[ -n "${BIN_DIR}" ]]; then
#   export PATH="${BIN_DIR}:${PATH}"
# fi
${BIN_DIR}/rosa  login 
${BIN_DIR}/rosa  init --region=${REGION}

echo "Going to delete cluster - ${CLUSTER_NAME}  to be deleted "
${BIN_DIR}/rosa delete cluster --cluster=${CLUSTER_NAME} --region=${REGION} --yes
echo "Waiting for cluster - ${CLUSTER_NAME} to be deleted "   

sleep 1200

echo "Cluster deletion done"
count=0
while true ; do
  found=$(${BIN_DIR}/rosa list clusters --region=${REGION} | grep ${CLUSTER_NAME} -c )
 
  if [[ ${count} -gt 4 ]]; then
    echo "Timed out waiting for cluster ${CLUSTER_NAME} to be deleted"
    break;
  else 
     if [[ ${found} -eq 0 ]]; then
        echo "Cluster ${CLUSTER_NAME} got deleted successfully"
        break;
    fi
  fi
  count=$((count + 1)) 
  echo "Waiting for cluster - ${CLUSTER_NAME}  to be deleted "
  sleep 300      
done