terraform {
  required_providers {
     kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
}
resource "kubernetes_namespace" "test" {
  metadata {
    name = "myapp"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "myapp"
    namespace = kubernetes_namespace.test.metadata.0.name
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
          image = "omerharush93/cycode:latest"
          name  = "myapp-container"
          port {
            container_port = 3000
          }
	  env {
            name  = "DB_URI"
            value = "mongodb+srv://omerharush:Zz123456@cluster0.xkhsu.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "myapp"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30000
      port        = 3000
      target_port = 3000
    }
  }
}