#!/bin/bash

# AWS SDK
npm i

# Parameter Store
nodejs ssm_get_secrets.js 'ssm_vars' /7mb/quadrant/$DEPLOYMENT_ENVIRONMENT/$SERVICE_NAME $AWS_DEFAULT_REGION

# Export variables
source ssm_vars

# Start service
$1 $2