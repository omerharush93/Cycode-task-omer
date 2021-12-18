terraform {
  required_providers {
     kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
# resource "kubernetes_namespace" "test" {
#   metadata {
#     name = "myapp"
#   }
# }
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "myapp"
#     namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "omerharush93/cycode:${var.version}"
          name  = "myapp-container"
          port {
            container_port = 3000
          }
          env {
            name  = "DB_URI"
            value = ${var.db_uri}
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "myapp"
#     namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 3000
      target_port = 3000
    }
  }
}
variable "db_uri" {
  type        = string
  description = "The DB URI of the service."
}
variable "version" {
  type        = string
  description = "Docker image tag version"
# resource "kubernetes_config_map" "test" {
#   metadata {
#     name = "db-uri"
#   }

#   data = {
#     database_uri = ${var.db_uri}
#   }

# }
