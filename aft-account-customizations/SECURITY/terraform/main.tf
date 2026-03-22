# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

########################################
#######   AFT Core Parameters    #######
########################################
resource "aws_ssm_parameter" "account_id" {
  # checkov:skip=CKV_AWS_337:This SSM parameter is not a SecureString and there is no need to encrypt it using KMS
  provider = aws.aft-management

  name        = "/org/core/accounts/ct-security-tooling"
  type        = "String"
  description = "Control Tower Security Tooling account Id"
  value       = data.aws_caller_identity.current.account_id
  tags        = local.tags
}

############################################
#######     GuardDuty delegation     #######
############################################
resource "aws_guardduty_organization_admin_account" "primary" {
  provider = aws.org-management-primary

  admin_account_id = data.aws_caller_identity.current.account_id
}


############################################
#######   Security Hub delegation    #######
############################################
# aws_securityhub_account is necessary to enable consolidated control findings feature, 
# as Terraform resources for securityhub organization configuration level doesn't support setting it up.
# https://github.com/hashicorp/terraform-provider-aws/issues/30022
# https://github.com/hashicorp/terraform-provider-aws/pull/30692
# https://github.com/hashicorp/terraform-provider-aws/issues/39687
resource "aws_securityhub_organization_admin_account" "securityhub" {
  provider   = aws.org-management-primary
  depends_on = [aws_securityhub_account.primary]

  admin_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_securityhub_account" "primary" {
  provider = aws.primary

  control_finding_generator = var.securityhub_control_finding_generator
}
