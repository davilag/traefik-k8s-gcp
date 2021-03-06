credentials        = "./terraform-gke-keyfile.json"
project_id         = "dag-k8s"
region             = "us-central1"
zones              = ["us-central1-c"]
name               = "gke-cluster"
machine_type       = "g1-small"
min_count          = 1
max_count          = 1
disk_size_gb       = 10
service_account    = "{service_account_name}@{project_name}.iam.gserviceaccount.com"
initial_node_count = 1
traefik_auth       = ""
domain             = "gcp.davidavila.eu"