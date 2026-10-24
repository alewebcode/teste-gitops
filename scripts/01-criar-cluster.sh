#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if kind get clusters | grep -qx gitops-lab; then
  echo "Cluster gitops-lab ja existe."
else
  kind create cluster --config cluster/kind-config.yaml
fi
kubectl config use-context kind-gitops-lab
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes
