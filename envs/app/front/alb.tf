resource "aws_alb_target_group" "arcgisserver" {
  name                 = "${var.name}-arcgisserver-tg"
  port                 = 6443
  protocol             = "HTTPS"
  vpc_id               = data.terraform_remote_state.infra.outputs.aws_vpc_id
  deregistration_delay = 60

  health_check {
    interval            = 30
    path                = "/arcgis/rest/info/healthCheck"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener_rule" "arcgisserver" {
  listener_arn = aws_alb_listener.arcgis.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.arcgisserver.arn
  }

  condition {
    host_header {
      values = ["${terraform.workspace}-s.${data.terraform_remote_state.infra.outputs.root_domain_name}"]
    }
  }
  depends_on = [aws_alb_target_group.arcgisserver]
}

resource "aws_alb_target_group" "arcgisportal" {
  name                 = "${var.name}-arcgisportal-tg"
  port                 = 7443
  protocol             = "HTTPS"
  vpc_id               = data.terraform_remote_state.infra.outputs.aws_vpc_id
  deregistration_delay = 60

  health_check {
    interval            = 30
    path                = "/arcgis/portaladmin/healthCheck"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener_rule" "arcgisportal" {
  listener_arn = aws_alb_listener.arcgis.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.arcgisportal.arn
  }

  condition {
    host_header {
      values = ["${terraform.workspace}-p.${data.terraform_remote_state.infra.outputs.root_domain_name}"]
    }
  }
  depends_on = [aws_alb_target_group.arcgisportal]
}

## Listener
resource "aws_alb_listener" "arcgis" {
  load_balancer_arn = data.terraform_remote_state.infra.outputs.alb_public_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.infra.outputs.aws_acm_certificate_root_arn

  default_action {
    target_group_arn = aws_alb_target_group.arcgisportal.arn
    type             = "forward"
  }
  depends_on = [aws_alb_target_group.arcgisportal]
}

# switch blue green
resource "aws_alb_target_group_attachment" "arcgisserver" {
  target_group_arn = aws_alb_target_group.arcgisserver.arn
  target_id        = (var.target == "blue" ? data.terraform_remote_state.app_blue.outputs.aws_instance_arcgisserver_id : data.terraform_remote_state.app_green.outputs.aws_instance_arcgisserver_id)
  port             = 6443
}

resource "aws_alb_target_group_attachment" "arcgisportal" {
  target_group_arn = aws_alb_target_group.arcgisportal.arn
  target_id        = (var.target == "blue" ? data.terraform_remote_state.app_blue.outputs.aws_instance_arcgisportal_id : data.terraform_remote_state.app_green.outputs.aws_instance_arcgisportal_id)
  port             = 7443
}


