#!/bin/bash -e

function fail {
    echo "${1}"
    exit 1
}

if [[ -z "${1}" ]]; then
    echo
    echo "Usage:  ${0} STAGE COMMAND CONFIG"
    echo
    echo "Stages:"
    echo "    dev"
    echo "    uat"
    echo "    prod"
    echo
    echo "Commands:"
    echo "    deploy"
    echo "    remove"
    echo
    echo "Configs:"
    echo "    serverless-infrastructure"
    echo "    serverless"
    echo
    echo "Examples:"
    echo "    ${0} dev deploy serverless-infrastructure"
    exit 1
fi
stage="${1}"
command="${2}"
config="${3}"

if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then
    fail "AWS_ACCESS_KEY_ID not found, please set AWS credentials"
fi

if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    fail "AWS_SECRET_ACCESS_KEY not found, please set AWS credentials"
fi

if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    fail "AWS_SECRET_ACCESS_KEY not found, please set AWS credentials"
fi

if [[ -n "${AWS_DEFAULT_REGION}" ]]; then
    export DEPLOY_REGION=${AWS_DEFAULT_REGION}
fi

if [[ -n "${AWS_REGION}" ]]; then
    export DEPLOY_REGION=${AWS_REGION}
fi

if [[ -z "${DEPLOY_REGION}" ]]; then
    fail "unknown AWS region, please set either AWS_REGION or AWS_DEFAULT_REGION"
fi

if [[ -z "${SUBNET_ID_A}" ]]; then
    fail "SUBNET_ID_A not found, see README for instructions"
fi

if [[ -z "${SUBNET_ID_B}" ]]; then
    fail "SUBNET_ID_B not found, see README for instructions"
fi

if [[ -z "${VPC_ID}" ]]; then
    fail "VPC_ID not found, see README for instructions"
fi

if [[ ${config} == "serverless-infrastructure" ]]; then

    if [[ -z "${DB_INSTANCE_CLASS}" ]]; then
        fail "DB_INSTANCE_CLASS not found, see README for instructions"
    fi

    if [[ -z "${CACHE_INSTANCE_CLASS}" ]]; then
        fail "CACHE_INSTANCE_CLASS not found, see README for instructions"
    fi

    if [[ -z "${DB_ALLOCATED_STORAGE}" ]]; then
        fail "DB_ALLOCATED_STORAGE not found, see README for instructions"
    fi

elif [[ ${config} == "serverless" ]]; then

    if [[ -z "${CLOUDFRONT_BUCKET_NAME}" ]]; then
        fail "CLOUDFRONT_BUCKET_NAME not found, see README for instructions"
    fi

else
    fail "unrecognized CONFIG [${config}]"
fi

NODE_ENV=production \
NODE_OPTIONS=--max_old_space_size=4096 \
exec /build/node_modules/.bin/serverless \
  "${command}" \
  --stage "${stage}" \
  --region "${DEPLOY_REGION}" \
  --config "${config}.yml"
