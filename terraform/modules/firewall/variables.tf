variable "firewall_name" {
  description = "Name of the existing firewall to manage"
  type        = string
}

variable "use_current_ip" {
  description = "Automatically add current machine's public IP"
  type        = bool
  default     = true
}

variable "extra_admin_ips" {
  description = "Additional admin IPs to allow (CIDR format)"
  type        = list(string)
  default     = []
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}
