provider "aws" {
  region  = var.aws_region
  version = "~> 4.21.0"
}

provider "template" {
  version = "2.1"
}

provider "local" {
  version = "1.3"
}

provider "null" {
  version = "2.1"
}

provider "tls" {
  version = "2.1"
}

