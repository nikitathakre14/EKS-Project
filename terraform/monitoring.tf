resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.cluster_name}-cloudwatch"
    Environment = var.environment
  }
}

resource "aws_route53_record" "failover_monitor" {
  zone_id = "Z123"
  name    = "app.example.com"
  type    = "A"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = "alb-dns"
    zone_id                = "Zxxx"
    evaluate_target_health = true
  }
}
