# AWS S3 remote state Terraform module

Author: [Yurii Onuk](https://onuk.org.ua)

Terraform module which creates terraform S3 backend with state locking.

Next types of resources are supported:

* [AWS S3 bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [AWS dynamodb table](https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html)
* [AWS S3 bucket policy](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html)
* [AWS kms key](https://www.terraform.io/docs/providers/aws/r/kms_key.html)
* [AWS kms alias](https://www.terraform.io/docs/providers/aws/r/kms_alias.html)

## Terraform version compatibility

- 0.12.29
- 1.1.5

## Usage

main.tf:

```hcl-terraform
provider "aws" {
  region = "${var.region}"
}

module s3_backend {
  source = "git@github.com:equinor/flowify-terraform-aws-s3-remote-state.git?ref=1.0.x"
  version                       = ">= 1.0.0"
  region                        = "${var.region}"
  env_class                     = "${var.env_class}"
  backend_s3_bucket             = "${var.s3_bucket_name}"
  backend_dynamodb_lock_table   = "${var.dynamodb_state_table_name}"
  create_dynamodb_lock_table    = "${var.create_dynamodb_lock_table}"
  create_s3_bucket              = "${var.create_s3_bucket}"
  common_tags                   = "${var.common_tags}"
}
```

output.tf:

```hcl-terraform
output "bucket_region" {
  value = "${module.s3_backend.bucket_region}"
}

output "bucket_name" {
  value = "${module.s3_backend.bucket_name}"
}

output "bucket_arn" {
  value = "${module.s3_backend.bucket_arn}"
}

output "dynamodb_table_name" {
  value = "${module.s3_backend.dynamodb_table_name}"
}

output "dynamodb_table_arn" {
  value = "${module.s3_backend.dynamodb_table_arn}"
}
```

variable.tf:

```hcl-terraform
variable "region" {
  type = "string"
  default = "us-west-2"
  description = "The region where AWS operations will take place"
}

variable "create_dynamodb_lock_table" {
  default     = true
  description = "Boolean:  If you have a dynamoDB table already, use that one, else make this true and one will be created"
}

variable "create_s3_bucket" {
  default     = true
  description = "Boolean.  If you have an S3 bucket already, use that one, else make this true and one will be created"
}

variable "s3_bucket_name" {
  type = "string"
  default = "terraform-state-bucket"
  description = "Name of S3 bucket prepared to hold your terraform state(s)"
}

variable "dynamodb_state_table_name" {
  type = "string"
  default = "backend_tf_lock"
  description = "Name of dynamoDB table to use for state locking"
}

variable "env_class" {
  type = "string"
  description = "Environment class to be used on all the resources as identifier"
}

variable "common_tags" {
  type = "map"
  default = {
    EnvClass    = "dev"
    Environment = "Playground"
    Owner       = "Ops"
    Terraform   = "true"
  }
  description = "A default map of tags to add to all resources"
}
```

terraform.tfvars:

```hcl-terraform
# The region where AWS operations will take place
region  = "us-west-2"

# Name to be used on all the resources as identifier
env_name = "usw101"

s3_bucket_name              = "dev-terraform-state-bucket"
dynamodb_state_table_name   = "backend_tf_lock"

common_tags = {
    EnvClass    = "dev"
    Environment = "Playground"
    Owner       = "Engineering"
    Terraform   = "true"
}
```

## Inputs

 Variable                      | Type       | Default                               | Required | Purpose
:----------------------------- | ---------- | ------------------------------------- | -------- | :----------------------
`backend_dynamodb_lock_table`  | `string`   | `backend_tf_lock`                     |   `no`   | `Name of dynamoDB table to use for state locking`
`backend_s3_bucket`            | `string`   | `terraform-state-bucket`              |   `no`   | `Name of bucket housing terraform state files`
`create_dynamodb_lock_table`   | `boolean`  | `true`                                |   `no`   | `Create dynamodb table for state locking`
`create_s3_bucket`             | `boolean`  | `true`                                |   `no`   | `Create s3 bucket`
`env_class`                    | `string`   | `no`                                  |   `yes`  | `Environment class to be used on all the resources as identifier`
`common_tags`                  | `map`      | `{ Customer = "Equinor" }`            |   `no`   | `A map of tags to add to all resources`

## Outputs

| Name                          | Description                                                |
| ----------------------------- | ---------------------------------------------------------- |
| `bucket_name`                 | `Name of S3 bucket prepared to hold your terraform state(s)` |
| `bucket_arn`                  | `Amazon Resource Names (ARN) for s3 bucket`                  |
| `dynamodb_table_name`         | `Name of dynamoDB table to use for state locking`            |
| `dynamodb_table_arn`          | `Amazon Resource Names (ARN) for dynamodb table`             |

## Terraform Validate Action

Runs `terraform validate -var-file=validator` to validate the Terraform files 
in a module directory via CI/CD pipeline.
Validation includes a basic check of syntax as well as checking that all variables declared.

### Success Criteria

This action succeeds if `terraform validate -var-file=validator` runs without error.

### Validator

If some variables are not set as default, we should fill the file `validator` with these variables.
