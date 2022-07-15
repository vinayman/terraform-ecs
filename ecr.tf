resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}"
  tags = {
    Name        = "${var.app_name}"
    Environment = var.app_environment
  }
}

locals {
  app_image = "${aws_ecr_repository.aws-ecr.repository_url}:${var.image_tag}"
}

output "ecr-uri" {
  value = aws_ecr_repository.aws-ecr.repository_url
}
