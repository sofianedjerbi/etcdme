variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "control_plane_nodepools" {
  description = "Control plane node pool configuration"
  type = list(object({
    name     = string
    type     = string
    location = string
    count    = number
  }))
}

variable "worker_nodepools" {
  description = "Worker node pool configuration"
  type = list(object({
    name     = string
    type     = string
    location = string
    count    = number
  }))
  default = []
}

variable "cilium_helm_values" {
  description = "Custom Helm values for Cilium (enables Gateway API)"
  type        = any
  default     = {}
}

variable "control_plane_config_patches" {
  description = "Talos machine config patches for control plane nodes"
  type        = any
  default     = []
}

variable "worker_config_patches" {
  description = "Talos machine config patches for worker nodes"
  type        = any
  default     = []
}

variable "kubeconfig_path" {
  description = "Path to write kubeconfig file"
  type        = string
  default     = null
}

variable "talosconfig_path" {
  description = "Path to write talosconfig file"
  type        = string
  default     = null
}
