resource "helm_release" "keda-helm" { 
  name = "keda"
  repository = "https://kedacore.github.io/charts"
  chart = "keda"
  create_namespace = true
  namespace = "keda"
}

resource "helm_release" "chaosmesh-helm" { 
  name = "chaos-mesh"
  repository = "https://charts.chaos-mesh.org"
  chart = "chaos-mesh"
  create_namespace = true
  namespace = "chaos-testing"
}
