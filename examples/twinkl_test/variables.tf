variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "environment" {
  description = "one of the environments to deploy the 4 unique buckets to"
  type        = string
}

variable "tags" {
  description = "A map of any additional tags (other than environment and name) to add to the buckets."
  type        = map(string)
}

variable "bucket_prefix" {
  description = "value to prefix the bucket names with."
  type        = string
}

variable "index_file" {
  description = "index file for the website buckets"
  type        = string
}

variable "role_name" {
  description = "The name of the role use the buckets"
  type        = string
}

variable "admin_role" {
  description = "the name of a admin role to view and edit policies"
  type        = string
}