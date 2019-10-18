# Generate client private key and cert
resource "tls_private_key" "terraform-{{ item }}-raioam-com" {
  algorithm = "RSA"
}

resource "tls_cert_request" "terraform-{{ item }}-raioam-com" {
  key_algorithm = "${tls_private_key.terraform-{{ item }}-raioam-com.algorithm}"
  private_key_pem = "${tls_private_key.terraform-{{ item }}-raioam-com.private_key_pem}"

  subject {
    common_name = "terraform.{{ item }}.raioam.com"
    organization = "RAIOAM"
    country = "US"
  }
}

resource "tls_locally_signed_cert" "terraform-{{ item }}-raioam-com" {
  cert_request_pem = "${tls_cert_request.terraform-{{ item }}-raioam-com.cert_request_pem}"

  ca_key_algorithm = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 43800

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

# Import {{ item }} client cert
resource "aws_acm_certificate" "terraform-{{ item }}-raioam-com" {
  private_key = "${tls_private_key.terraform-{{ item }}-raioam-com.private_key_pem}"
  certificate_body = "${tls_locally_signed_cert.terraform-{{ item }}-raioam-com.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.ca.cert_pem}"
}

# create {{ item }} VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "{{ item }}" {
  description            = "Client VPN Endpoint for {{ item }}"
  server_certificate_arn = "${aws_acm_certificate.terraform-server-raioam-com.arn}"
  client_cidr_block      = "10.0.0.0/16"
  split_tunnel = true
  tags = {
    Name = "terraform-{{ item }}-vpn"
  }

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "${aws_acm_certificate.terraform-{{ item }}-raioam-com.arn}"
  }

  connection_log_options {
    enabled               = false
  }
}
