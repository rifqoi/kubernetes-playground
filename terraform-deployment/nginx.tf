resource "kubernetes_deployment" "nginx-deployment" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx-deployment"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-deployment"
        }
      }

      spec {
        container {
          image = "nginx"
          name = "nginx"
          port {
            container_port = 80
          }
        }
      }

    }
  }
}

resource "kubernetes_service" "nginx-service" { 
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx-deployment.spec.0.template.0.metadata[0].labels.app
    }
    type = "NodePort"
    port {
      node_port = 30001
      port = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress_v1" "nginx-ingress" { 
  metadata {
    name = "nginx-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.nginx-service.metadata.0.name
              port {
                number = 80
              }
            }

          }
        }
      }
    }
  }
}
