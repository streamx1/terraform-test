terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}

#
provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# 
resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  namespace  = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  version    = "1.24.0"

  create_namespace = true
  timeout          = 600
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  chart      = "gateway"
  namespace  = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  version    = "1.24.0"
  
  set {
    name  = "service.type"
    value = "NodePort"
  }
  timeout = 600
}

# 
resource "kubernetes_deployment" "httpd" {
  metadata {
    name      = "httpd"
    namespace = "default"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "httpd"
      }
    }
    template {
      metadata {
        labels = {
          app = "httpd"
        }
      }
      spec {
        container {
          name  = "httpd"
          image = "httpd:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

#
resource "kubernetes_service" "httpd" {
  metadata {
    name      = "httpd"
    namespace = "default"
  }

  spec {
    selector = {
      app = "httpd"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30000
    }
    type = "NodePort"

  }
}

# 
resource "kubernetes_manifest" "httpd_ingress" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "httpd"
      namespace = "default"
    }
    spec = {
      hosts = ["*"]
      gateways = ["istio-system/istio-ingressgateway"]
      http = [{
        route = [{
          destination = {
            host = "httpd.default.svc.cluster.local"
            port = {
              number = 80
            }
          }
        }]
      }]
    }
  }
}
