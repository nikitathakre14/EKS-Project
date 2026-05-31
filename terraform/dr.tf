resource "aws_route53_record" "failover" {
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
