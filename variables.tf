variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "eu-west-2"
  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca|cn|af|me)-(north|south|east|west|central|northeast|southeast)-[0-9]$", var.region))
    error_message = "Invalid AWS region."
  }
}

# environment variable that can only be "dev" "prod" or "staging"
variable "environment" {
  description = "The name of the environment to deploy to"
  type        = string
  validation {
    condition     = can(regex("^(dev|prod|staging)$", var.environment))
    error_message = "Invalid environment. use 'dev', 'prod' or 'staging'."
  }
}

# tag variable for any extra tags
variable "tags" {
  description = "A map of any additional tags (other than environment and name) to add to the buckets."
  type        = map(string)
  default     = {}
}

# bucket name prefix
variable "bucket_prefix" {
  description = "value to prefix the bucket names with."
  type        = string
  /*
  main.tf appends "{environment}[A-D]" so we need to make sure the characters limit of 63 is not exceeded (63 - len("staging") - 1 = 55)
  regex also to limit particular characters as per:
  https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-trail-naming-requirements.html#cloudtrail-s3-bucket-naming-requirements
  */
  validation {
      condition     = can(regex("^[a-z0-9.-]{3,55}$", var.bucket_prefix))
      error_message = "Invalid bucket prefix."
  }
}

variable "index_file" {
  description = "index file for the website buckets"
  type        = string
  default     = "index.html"
}

# the role to use to get/put objects in the buckets
variable "role_name" {
  description = "The name of the role use the buckets"
  type        = string
}

# the role who can view and edit the policies
variable "admin_role" {
  description = "the name of a admin role to view and edit policies"
  type        = string
}