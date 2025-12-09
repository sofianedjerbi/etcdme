# etcd.me

High-availability Kubernetes on Hetzner Cloud. Built for resilience.

## Live

**[etcd.me](https://etcd.me)** | [Portfolio](https://sofianedjerbi.com)

## High Availability

- **3 control plane nodes** with etcd quorum
- **Self-healing** workloads via Kubernetes
- **Automated failover** with Cilium Gateway API
- **GitOps reconciliation** ensures desired state

## Stack

- **Talos Linux** - Immutable, API-driven Kubernetes OS
- **Terragrunt** - Infrastructure as Code
- **ArgoCD** - GitOps with automatic drift correction
- **SOPS + age** - Encrypted secrets in Git
- **Cilium** - eBPF networking + Gateway API
- **Cloudflare** - Global DNS with health checks

## Structure

```
terraform/
  modules/        # Reusable infra (cluster, dns, firewall)
  live/           # Per-cluster stacks
argocd/
  base/           # Shared manifests
  overlays/       # Per-cluster config
tasks/            # Automation
```

## Bootstrap

```bash
task tg -- stack run apply terraform/live/etcdme-nbg1-dc3
task argocd:bootstrap
```

## Services

Postgres, Keycloak, Grafana, Uptime Kuma, n8n, and more.

---

Built by [Sofiane Djerbi](https://sofianedjerbi.com)
