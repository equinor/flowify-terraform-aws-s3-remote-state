# Variables
# https://www.terraform.io/docs/configuration/variables.html

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "Region where the S3 bucket will be created"
}

variable "common_tags" {
  type = map(string)
  default = {
    EnvClass    = "dev"
    Environment = "Playground"
    Owner       = "Ops"
    Terraform   = "true"
  }
  description = "A default map of tags to add to all resources"
}

variable "env_class" {
  type        = string
  description = "Environment class to be used on all the resources as identifier"
}

variable "backend_dynamodb_lock_table" {
  type        = string
  default     = "backend_tf_lock"
  description = "Table to hold state lock when updating.  You may want a distinct one for each separate TF state."
}

variable "backend_s3_bucket" {
  type        = string
  default     = "terraform-state"
  description = "Name of S3 bucket prepared to hold your terraform state(s)"
}

variable "acl" {
  type        = string
  default     = "bucket-owner-full-control"
  description = "Canned ACL applied to bucket. https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl"
}

variable "versioning" {
  type        = string
  default     = "true"
  description = "Multiple versions of the same bucket, allow for state recovery in the case of accidental deletions and human error"
}

variable "create_dynamodb_lock_table" {
  default     = false
  description = "Boolean:  If you have a dynamoDB table already, use that one, else make this true and one will be created"
}

variable "create_s3_bucket" {
  default     = false
  description = "Boolean.  If you have an S3 bucket already, use that one, else make this true and one will be created"
}

variable "use_bucket_encryption" {
  default     = true
  description = "Boolean.  Encrypt bucket with account default CMK"
}

variable "use_bucket_versioning" {
  default     = true
  description = "Boolean.  Leave true for safety, or set to false and role the dice on your fate."
}

variable "prevent_unencrypted_on" {
  default     = true
  description = "Boolean. Turn on policy to prevent unencrypted data at transport"
}

variable "key_name" {
  type        = string
  default     = "terraform.tfstate"
  description = "Path to your state.  Examples: state/usw101.dev/terraform.tfstate, etc.."
}

variable "deletion_window_in_days_kms_key" {
  type        = string
  default     = "7"
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days."
}

variable "enable_key_rotation" {
  default     = true
  description = "Specifies whether key rotation is enabled."
}

