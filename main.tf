resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name           = "my-node-pool"
  location       = var.region
  node_locations = var.zones
  cluster        = google_container_cluster.primary.name
  node_count     = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }
  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "helm_release" "traefik" {
  name  = "traefik"
  chart = "./charts/traefik"
  values = [
    file("./charts/traefik/values.yaml")
  ]

  set {
    name  = "authSecret"
    value = var.traefik_auth
  }

  set {
    name  = "domain"
    value = "traefik.${var.domain}"
  }
}
