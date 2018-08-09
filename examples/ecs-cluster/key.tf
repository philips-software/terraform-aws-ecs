resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "local_file" "public_ssh_key" {
  depends_on = ["tls_private_key.ssh"]

  content  = "${tls_private_key.ssh.public_key_openssh}"
  filename = "${var.public_key_file}"
}

resource "local_file" "private_ssh_key" {
  depends_on = ["tls_private_key.ssh"]

  content  = "${tls_private_key.ssh.private_key_pem}"
  filename = "${var.private_key_file}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("${var.public_key_file}")}"
}
