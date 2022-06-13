#!/usr/bin/env bash
INPUT=$(tee)


BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]+)".*/\1/g')
TMP_DIR=$(echo "${INPUT}" | grep "tmp_dir" | sed -E 's/.*"tmp_dir": ?"([^"]+)".*/\1/g')
CRED_FILE_NAME=$(echo "${INPUT}" | grep "cred_file_name" | sed -E 's/.*"cred_file_name": ?"([^"]+)".*/\1/g')
CLUSTER_INFO_FILE=$(echo "${INPUT}" | grep "cluster_info_file_name" | sed -E 's/.*"cluster_info_file_name": ?"([^"]+)".*/\1/g')

USER=$(cat ${TMP_DIR}/${CRED_FILE_NAME}  | grep "\\--username" | tail -1 | sed -n -e 's/^.*\(--username \)/\1/p')
ADMIN_USER=$(echo $USER | awk  '{print $2}')
ADMIN_PWD=$(echo $USER | awk  '{print $4}')    

echo "ADMIN_USER: ${ADMIN_USER}" >&2

CLUSTER_ID=""
OCP_CONSOLE_URL=""
OCP_SERVER_URL=""
CLUSTER_BASE_DOMAIN=""
OPENSHIFT_VERSION=""
CLUSTER_STATUS=""


eval "$(cat ${TMP_DIR}/${CLUSTER_INFO_FILE} | ${BIN_DIR}/jq -r '@sh "CLUSTER_ID=\(.id) OCP_CONSOLE_URL=\(.console.url) OCP_SERVER_URL=\(.api.url) CLUSTER_BASE_DOMAIN=\(.dns.base_domain) OPENSHIFT_VERSION=\(.openshift_version) CLUSTER_STATUS=\(.state)"')"


echo "{\"adminUser\": \"${ADMIN_USER}\", \"adminPwd\": \"${ADMIN_PWD}\", \"clusterID\": \"${CLUSTER_ID}\",\"consoleUrl\": \"${OCP_CONSOLE_URL}\",\"serverURL\": \"${OCP_SERVER_URL}\", \"clusterDNS\": \"${CLUSTER_BASE_DOMAIN}\", \"openshiftVersion\": \"${OPENSHIFT_VERSION}\", \"clusterStatus\": \"${CLUSTER_STATUS}\"}"


