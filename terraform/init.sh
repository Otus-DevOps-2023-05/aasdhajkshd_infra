#!/bin/bash
[[ -f "$(pwd)/key.json" ]] && \
    export service_account_key_file=$(pwd)/key.json
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ACCESS_KEY=""
export YC_SECRET_KEY=""
