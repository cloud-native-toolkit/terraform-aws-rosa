#!/usr/bin/env bash

# Login to the rosa CLI
$BIN_DIR/rosa login --token=${ROSA_TOKEN}

# Verify quota to deploy ROSA
$BIN_DIR/rosa verify quota --region=${REGION}

# Initialise ROSA for specified region
$BIN_DIR/rosa init --region=${REGION}

# Add tags if required
if [[ -n "${TAGS}" ]]; then
  TAGS_ARG="--tags=${TAGS}"
fi

# Specify existing subnets for existing VPC
if [[ -n "${SUBNETS}" ]]; then
  SUBNET_ARGS="--subnet-ids ${SUBNETS}"
fi

# Kick off cluster creation
$BIN_DIR/rosa create cluster \
  --cluster-name ${CLUSTER_NAME} \
  --region ${REGION} \
  --version ${VERSION} \
  --replicas ${COMPUTE_NODES} \
  --compute-machine-type ${COMPUTE_TYPE} \
  --machine-cidr ${MACHINE_CIDR} \
  --service-cidr ${SERVICE_CIDR} \
  --pod-cidr ${POD_CIDR} \
  --host-prefix ${HOST_PREFIX} \
  --etcd-encryption ${MULTIZONE}  \
  ${SUBNET_ARGS} ${TAGS_ARG} ${PRIVATELINK} ${DRY_RUN} --yes