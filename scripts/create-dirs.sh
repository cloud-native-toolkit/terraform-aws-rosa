#!/usr/bin/env bash

INPUT=$(tee)

TMP_DIR=$(echo "${INPUT}" | grep "tmp_dir" | sed -E 's/.*"tmp_dir": ?"([^"]*)".*/\1/g')
KUBE_CONFIG_DIR=$(echo "${INPUT}" | grep "kube_config" | sed -E 's/.*"kube_config": ?"([^"]*)".*/\1/g')

if [[ -n "${TMP_DIR}" ]]; then
  mkdir -p "${TMP_DIR}"
fi

if [[ -n "${KUBE_CONFIG_DIR}" ]]; then
  mkdir -p "${KUBE_CONFIG_DIR}"
fi

echo "{\"tmp_dir\": \"${TMP_DIR}\", \"kube_config\": \"${KUBE_CONFIG_DIR}\"}"
