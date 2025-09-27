provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecr_repository" "poc_repo" {
  name                 = "devops-poc"
  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE"

  tags = {
    Environment = "dev"
    Project     = "devops-poc"
  }
}