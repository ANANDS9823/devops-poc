variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "cluster_name" {
  default = "devops-eks-cluster"
}