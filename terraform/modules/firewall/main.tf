# Standalone firewall management module
# This module manages admin IPs for the cluster firewall independently
# to avoid chicken-and-egg problems with API health checks

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

# Get current public IPs
data "http" "ipv4" {
  count = var.use_current_ip ? 1 : 0
  url   = "https://ipv4.icanhazip.com"
}

data "http" "ipv6" {
  count = var.use_current_ip ? 1 : 0
  url   = "https://ipv6.icanhazip.com"
}

locals {
  # Build source IPs list
  current_ipv4 = var.use_current_ip && length(data.http.ipv4) > 0 ? ["${trimspace(data.http.ipv4[0].response_body)}/32"] : []
  current_ipv6 = var.use_current_ip && length(data.http.ipv6) > 0 ? ["${trimspace(data.http.ipv6[0].response_body)}/128"] : []

  source_ips = distinct(concat(
    var.extra_admin_ips,
    local.current_ipv4,
    local.current_ipv6
  ))
}

# Get existing firewall
data "hcloud_firewall" "cluster" {
  name = var.firewall_name
}

# Update firewall rules
resource "hcloud_firewall" "cluster" {
  name   = var.firewall_name
  labels = data.hcloud_firewall.cluster.labels

  rule {
    description = "Allow Incoming Requests to Kube API"
    direction   = "in"
    protocol    = "tcp"
    port        = "6443"
    source_ips  = local.source_ips
  }

  rule {
    description = "Allow Incoming Requests to Talos API"
    direction   = "in"
    protocol    = "tcp"
    port        = "50000"
    source_ips  = local.source_ips
  }

  lifecycle {
    # Ignore changes to apply_to since that's managed by the cluster module
    ignore_changes = [apply_to]
  }
}

output "source_ips" {
  value = local.source_ips
}
