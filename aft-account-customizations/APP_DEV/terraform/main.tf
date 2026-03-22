# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = lookup(local.vpc, "identifier", "")
  cidr = local.cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 3, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k)]

}