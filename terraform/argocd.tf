# 1. Primeiro declaramos o recurso do Namespace
resource "kubernetes_namespace" "argocd_ns" {
  metadata {
    name = "argocd"
  }
}

# 2. Instalação do ArgoCD com tempo de espera estendido
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.27.3"

  namespace = kubernetes_namespace.argocd_ns.metadata[0].name

  # --- SOLUÇÃO PARA O ERRO DE TIMEOUT ---
  timeout         = 900 # Dá 15 minutos para baixar e subir tudo
  force_update    = true
  cleanup_on_fail = true
  replace         = true
  # --------------------------------------

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
