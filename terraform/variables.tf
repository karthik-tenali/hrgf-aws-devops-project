variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "hrgf-eks-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_type" {
  description = "EC2 instance type for nodes"
  type        = string
  default     = "t3.small"
}

variable "node_disk_size" {
  description = "Disk size for nodes (GB)"
  type        = number
  default     = 30
}

variable "desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "hrgf-app"
}

variable "cicd_iam_user_arn" {
  description = "IAM User ARN for GitHub Actions CI/CD"
  type        = string
  default     = "arn:aws:iam::963108900846:user/github-actions-hrgf"
}
