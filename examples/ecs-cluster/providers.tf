provider "aws" {
  region  = "${var.aws_region}"
  version = "1.54"
}

provider "template" {
  version = "1.0"
}

provider "local" {
  version = "1.1"
}

provider "null" {
  version = "1.0"
}

provider "tls" {
  version = "1.1"
}
