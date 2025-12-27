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
  wait       = false # <--- Adicione isso para evitar timeout prematuro
  namespace  = kubernetes_namespace.argocd_ns.metadata[0].name

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

# Este recurso cria a definição da Application dentro do Kubernetes logo após instalar o ArgoCD
resource "kubernetes_manifest" "root_application" {
  depends_on = [helm_release.argocd] # Espera o ArgoCD estar pronto

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-application"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/lucascardosobarbeiro/projetos-devops.git"
        targetRevision = "HEAD"
        path           = "k8s-config" # Aponta para onde estão as definições de apps no Git
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

resource "helm_release" "argocd_rollouts" {
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  namespace        = "argo-rollouts"
  create_namespace = true
}
