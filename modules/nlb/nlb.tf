
#Network Load Balancer

resource "aws_lb" "test" {
  name                       = "${var.default_prefix}-nlb"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = var.default_tags

}
