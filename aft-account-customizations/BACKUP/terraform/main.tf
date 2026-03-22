# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

########################################
#######   AFT Core Parameters    #######
########################################
resource "aws_ssm_parameter" "account_id" {
  # checkov:skip=CKV_AWS_337:This SSM parameter is not a SecureString and there is no need to encrypt it using KMS
  provider = aws.aft-management

  name        = "/org/core/accounts/backup"
  type        = "String"
  description = "Delegated AWS Backup account Id"
  value       = data.aws_caller_identity.current.account_id
  tags        = local.tags
}

########################################
####### AWS Backup Configuration #######
########################################

resource "aws_backup_global_settings" "backup" {
  provider = aws.org-management

  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
  }
}

resource "aws_organizations_delegated_administrator" "backup" {
  provider   = aws.org-management
  depends_on = [aws_backup_global_settings.backup]

  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "backup.amazonaws.com"
}