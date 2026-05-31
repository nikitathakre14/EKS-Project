resource "aws_kms_key" "eks" {
  description = "EKS encryption key"
  tags = {
    Name        = "${var.cluster_name}-kms"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "central-logs-bucket-123"
  acl    = "private"

  tags = {
    Name        = "${var.cluster_name}-logs"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudtrail" "trail" {
  name                          = "${var.cluster_name}-trail"
  s3_bucket_name                = aws_s3_bucket.logs.id
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true

  tags = {
    Name        = "${var.cluster_name}-cloudtrail"
    Environment = var.environment
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS managed node group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow traffic from within the EKS node group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-nodes-sg"
    Environment = var.environment
  }
}
