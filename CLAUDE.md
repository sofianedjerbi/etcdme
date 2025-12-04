# Claude Code Guidelines for this Project

## Golden Rule: Infrastructure as Code Only

**NEVER modify cluster resources directly.** All changes must be made through Infrastructure as Code:

- **Terraform/Terragrunt** for infrastructure (Hetzner servers, DNS, Talos images)
- **ArgoCD Applications** for Kubernetes resources
- **Git commits** to persist all changes

If we cannot replicate everything with IaC, the mission has failed.

### What NOT to do:
- `kubectl delete/apply/patch` directly
- `talosctl` commands that modify state (upgrade is acceptable only if not automatable via Terraform)
- Manual helm installs
- Any imperative commands that change cluster state

### What TO do:
- Modify ArgoCD Application manifests in `argocd/apps/`
- Update Terraform/Terragrunt configurations
- Commit changes to git
- Let ArgoCD sync automatically or trigger sync via ArgoCD CLI

## Project Structure

- `terraform/` - Infrastructure as Code (Terragrunt modules)
- `argocd/apps/` - ArgoCD Application definitions
- `argocd/resources/` - Raw Kubernetes manifests managed by ArgoCD
- `infrastructure/` - Helm values and infrastructure configs
