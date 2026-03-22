# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

########################################
#######   AFT Core Parameters    #######
########################################
resource "aws_ssm_parameter" "account_id" {
  # checkov:skip=CKV_AWS_337:This SSM parameter is not a SecureString and there is no need to encrypt it using KMS
  provider = aws.aft-management

  name        = "/org/core/accounts/ct-log-archive"
  type        = "String"
  description = "Control Tower Log Archive Account Id"
  value       = data.aws_caller_identity.current.account_id
  tags        = local.tags
}


########################################
#######       VPC Flow Logs      #######
########################################

resource "aws_ssm_parameter" "primary_vpc_flow_logs_s3_bucket_name" {
  # checkov:skip=CKV_AWS_337:This SSM parameter is not a SecureString and there is no need to encrypt it using KMS
  provider = aws.primary

  name        = "/org/core/central-logs/vpc-flow-logs"
  type        = "String"
  description = "S3 bucket ARN for centralized VPC Flow Logs"
  value       = lookup(module.aft_custom_fields.values, "flow_logs_bucket_arn", null)
  tags        = local.tags
}
