#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

CLUSTER_NAME="$1"

BIN_DIR=$(cat .bin_dir)
cat .bin_dir

count=0
${BIN_DIR}/rosa  login 
${BIN_DIR}/rosa  init
while true ; do
  cluster_status=$(${BIN_DIR}/rosa describe cluster --cluster ${CLUSTER_NAME} -o json | ${BIN_DIR}/jq -r ."status.state")
  
  echo "cluster_status : ${cluster_status}"
  if [[ ${count} -gt 20 ]]; then
    echo "Timed out waiting for cluster ${CLUSTER_NAME} status to be ready"
    break;
  else 
     
    if [[ ${cluster_status} ==  "ready" ]]; then
      break;
    fi
  fi
  count=$((count + 1)) 
  echo "Waiting for cluster - ${CLUSTER_NAME} status to be ready  to be ready"
  #cluster_status='$(${BIN_DIR}/rosa describe cluster --cluster swe-cluster -o json | ${BIN_DIR}/jq -r ."status.state")'
  sleep 300
done