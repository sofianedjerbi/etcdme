# Talos Kubernetes on Hetzner Cloud - Terragrunt Stacks

Enterprise-grade Talos Kubernetes deployment using Terragrunt Stacks pattern.

## Features

- **Stack-Based Architecture** - Composable, reusable infrastructure patterns
- **100% Automated** - Just `terragrunt stack run apply`
- **Smart Caching** - Talos images built once, reused forever
- **Production Ready** - Uses proven, maintained modules
- **Multi-Environment** - Easy to spin up staging, production, etc.

## Structure

```
terraform/
├── root.hcl                    # Backend config (S3 state)
│
├── modules/                    # Terraform modules + unit configs
│   ├── cluster/                # Talos cluster (wraps hcloud-talos)
│   │   ├── terragrunt.hcl
│   │   └── scripts/
│   ├── dns/                    # Route53 DNS records
│   │   ├── main.tf
│   │   └── terragrunt.hcl
│   ├── firewall/               # Hetzner firewall rules
│   │   ├── main.tf
│   │   └── terragrunt.hcl
│   ├── floating-ip/            # Hetzner floating IP
│   │   ├── main.tf
│   │   └── terragrunt.hcl
│   └── talos-images/           # Talos OS image builder
│       ├── main.tf
│       └── terragrunt.hcl
│
├── stacks/                     # Composable stack blueprints
│   ├── network/                # firewall + floating-ip
│   │   └── terragrunt.stack.hcl
│   ├── talos/                  # talos-images + cluster
│   │   └── terragrunt.stack.hcl
│   └── dns/                    # dns records
│       └── terragrunt.stack.hcl
│
└── live/                       # Environment instantiations
    └── etcdme/                 # Production environment
        └── terragrunt.stack.hcl
```

## Stack Composition

```
live/etcdme
    ├── stack: network
    │   ├── unit: firewall
    │   └── unit: floating-ip
    ├── stack: talos
    │   ├── unit: talos-images
    │   └── unit: cluster
    └── stack: dns
        └── unit: dns
```

## Prerequisites

### 1. Environment Setup

```bash
cp .env.example .env
# Edit .env with:
# - HCLOUD_TOKEN (Hetzner API)
# - AWS credentials (for Route53)
# - LAB_DOMAIN (e.g., etcd.me)

direnv allow
```

### 2. Terragrunt 0.78.0+

Stacks require Terragrunt v0.78.0 or later:

```bash
terragrunt --version
```

## Usage

### Deploy Full Environment

```bash
cd terraform/live/etcdme

# Generate stack configurations
terragrunt stack generate

# Review plan
terragrunt stack run plan

# Deploy everything
terragrunt stack run apply
```

### Deploy Individual Stacks

```bash
cd terraform/live/etcdme

# Generate first
terragrunt stack generate

# Deploy just network
cd .terragrunt-stack/network
terragrunt run-all apply

# Deploy just cluster
cd .terragrunt-stack/talos
terragrunt run-all apply
```

### Destroy Environment

```bash
cd terraform/live/etcdme
terragrunt stack run destroy
```

## Adding New Environment

Create `terraform/live/staging/terragrunt.stack.hcl`:

```hcl
locals {
  cluster_name = "staging"
}

stack "network" {
  source = "../../stacks/network"
  path   = "network"
  values = {
    cluster_name = local.cluster_name
    datacenter   = "fsn1"
  }
}

# ... rest of stacks
```

## Resources

- [Terragrunt Stacks](https://terragrunt.gruntwork.io/docs/features/stacks/)
- [Talos Documentation](https://www.talos.dev/)
- [hcloud-talos Module](https://github.com/hcloud-talos/terraform-hcloud-talos)
