resource "aws_lb" "nlb" {
  count              = var.load_balancer ? 1 : 0
  name               = "${var.name}-nlb"
  load_balancer_type = "network"

  internal = false

  subnets = [var.subnet]
}

resource "aws_lb_listener" "nlb_listener" {
  count             = var.load_balancer ? length(var.ports) : 0
  load_balancer_arn = aws_lb.nlb[0].arn

  protocol = "TCP"

  port = var.ports[count.index]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
  }

  tags = {
    Name = "${var.name}-${var.ports[count.index]}-nlb_listener"
  }
}

resource "aws_lb_target_group" "target_group" {
  count       = var.load_balancer ? length(var.ports) : 0
  name        = "${var.name}-${var.ports[count.index]}-tg"
  port        = var.ports[count.index]
  target_type = "ip"
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    interval            = 10
    protocol            = "TCP"
    unhealthy_threshold = 2
  }
}