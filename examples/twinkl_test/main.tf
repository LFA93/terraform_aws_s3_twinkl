module "s3_twinkl" {
  source        = "github.com/LFA93/terraform_aws_s3_twinkl"
  region        = var.region
  environment   = var.environment
  tags          = var.tags
  bucket_prefix = var.bucket_prefix
  index_file    = var.index_file
  role_name     = var.role_name
  admin_role    = var.admin_role
}