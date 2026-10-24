#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd rollout status deployment/argocd-server --timeout=300s
kubectl -n argocd rollout status deployment/argocd-repo-server --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
echo
echo "Senha do usuario admin:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
echo
echo "Para abrir a UI: kubectl -n argocd port-forward svc/argocd-server 8080:443"
echo "Depois acesse https://localhost:8080 (usuario: admin)"
