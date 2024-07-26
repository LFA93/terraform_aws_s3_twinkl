module "s3_twinkl" {
# Thanks for enlightening me on for_each on modules Leigh :D 
  for_each = var.environment
  source = "../terraform_aws_s3_twinkl"
  region = var.region  
  environment = each.key
  tags = var.tags
  bucket_prefix = var.bucket_prefix
  index_file = var.index_file
  role_name = var.role_name
  admin_role = var.admin_role
}