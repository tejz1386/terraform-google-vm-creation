terraform {
  required_providers {
    external = {
      source = "hashicorp/external"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.55"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
