resource "aws_ecr_repository" "ecr" {
  name                 = "${var.product_name}-${var.env_name}-ecr"
  image_tag_mutability = "MUTABLE"
}