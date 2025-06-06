terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.1"   # Certifique-se de usar uma versão suportada
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "civo" {
  # O token deve ser fornecido por meio de uma variável de ambiente, arquivo tfvars ou variável com default.
}

resource "civo_kubernetes_cluster" "my_page_cluster" {
  name        = "my-page"
  firewall_id = var.firewall_id
  network_id  = var.network_id  

  pools {
    node_count = 2
    size       = "g4s.kube.xsmall" # Confirme que este tamanho está disponível
  }
}

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.my_page_cluster.kubeconfig  # Usando o atributo 'kubeconfig'
  filename = "${path.module}/kubeconfig.yaml"
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

resource "kubectl_manifest" "deployment" {
  yaml_body = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cesae-devops-my-page
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cesae-devops-my-page
  template:
    metadata:
      labels:
        app: cesae-devops-my-page
    spec:
      containers:
      - name: cesae-devops-my-page
        image: carlajesusdesign/cesae-devops-my-page:latest
        ports:
        - containerPort: 80
EOF
}

resource "kubectl_manifest" "service" {
  yaml_body = <<EOF
apiVersion: v1
kind: Service
metadata:
  name: cesae-devops-my-page-service
spec:
  selector:
    app: cesae-devops-my-page
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
EOF
}
