variable "environment" {
  description = "The environment to deploy (dev or prod)"
  type        = string
  default     = "dev"
}

resource "aws_s3_bucket" "example" {
  count = var.environment == "prod" ? 1 : 0

  bucket = var.environment == "prod" ? "my-prod-bucket" : null

  tags = {
    Environment = var.environment
  }
}
