#!/bin/bash

# Set your AWS access key and secret key
AWS_ACCESS_KEY_ID="ABCDEFD6O123456"
AWS_SECRET_ACCESS_KEY="ABCDEF/uAT8B12345678920321456"

# Set your default region and output format
DEFAULT_REGION="us-west-2"
DEFAULT_OUTPUT="json"

# Set MFA serial number and token code
MFA_SERIAL="arn:aws:iam::123456789:mfa/swathi"
echo "Please enter valid duo mobile token"
read MFA_TOKEN_CODE

# Configure AWS CLI
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set default.region "$DEFAULT_REGION"
aws configure set default.output "$DEFAULT_OUTPUT"

# Get session token with MFA
SESSION_TOKEN_JSON=$(aws sts get-session-token --serial-number "$MFA_SERIAL" --token-code "$MFA_TOKEN_CODE")

# Extract session token, secret key, and access key from JSON response
SESSION_TOKEN=$(echo "$SESSION_TOKEN_JSON" | jq -r '.Credentials.SessionToken')
SESSION_SECRET=$(echo "$SESSION_TOKEN_JSON" | jq -r '.Credentials.SecretAccessKey')
SESSION_ACCESS=$(echo "$SESSION_TOKEN_JSON" | jq -r '.Credentials.AccessKeyId')

# Set temporary credentials in environment variables
export AWS_ACCESS_KEY_ID="$SESSION_ACCESS"
export AWS_SECRET_ACCESS_KEY="$SESSION_SECRET"
export AWS_SESSION_TOKEN="$SESSION_TOKEN"

echo "AWS configuration and session token acquisition have been automated."
