output "floating_ip" {
  description = "Floating IP address for the cluster"
  value       = module.kubernetes.control_plane_public_vip_ipv4
}

output "kubeconfig" {
  description = "Kubeconfig for cluster access"
  value       = module.kubernetes.cluster_kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talosconfig for Talos API access"
  value       = module.kubernetes.cluster_talosconfig
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = module.kubernetes.cluster_endpoint
}
