#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

CLUSTER_NAME="$1"
# REGION="$2"

BIN_DIR=$(cat .bin_dir)
cat .bin_dir

count=0

while true ; do
  cluster_status=$(${BIN_DIR}/rosa describe cluster --cluster ${CLUSTER_NAME} -o json | ${BIN_DIR}/jq -r ."status.state")
  echo "cluster_status : ${cluster_status}"
  if [[ ${count} -eq 80 ]]; then
    echo "Timed out waiting for cluster ${CLUSTER_NAME} status to be ready"
    exit 1
  else 
     
    if [[ ${cluster_status} ==  "ready" ]]; then
      break;
    else 
      count=$((count + 1)) 
    fi
  fi

  echo "Waiting for cluster status to be ready ${CLUSTER_NAME} to be ready"
  cluster_status='$(${BIN_DIR}/rosa describe cluster --cluster swe-cluster -o json | ${BIN_DIR}/jq -r ."status.state")'
  sleep 30
done