# Load balancer security group defining inbound and outbound traffic
resource "aws_security_group" "lb" {
  name        = "hello-world-alb-security-group"
  vpc_id      = aws_vpc.default.id

  # Ingress allows inbound traffic only on port 80 to LB
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress allows any protocol and any port for outbound traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# LB definition - attached to public subnet
resource "aws_lb" "default" {
  name            = "hello-world-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

# Forward traffic on port 80 to whatever LB is attached to
resource "aws_lb_target_group" "hello_world_tg" {
  name        = "hello-world-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
  depends_on  = [aws_lb.default]
}

resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello_world_tg.id
    type = "forward"
  }
}
