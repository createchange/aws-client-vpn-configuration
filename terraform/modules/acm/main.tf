# Generate CA private key and cert
resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name = "raioam.com"
    organization = "RAIOAM"
    country = "US"
  }

  validity_period_hours = 43800
  is_ca_certificate = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
    "cert_signing",
  ]
}

# Generate server private key and cert
resource "tls_private_key" "terraform-server-raioam-com" {
  algorithm = "RSA"
}

resource "tls_cert_request" "terraform-server-raioam-com" {
  key_algorithm = "${tls_private_key.terraform-server-raioam-com.algorithm}"
  private_key_pem = "${tls_private_key.terraform-server-raioam-com.private_key_pem}"

  subject {
    common_name = "terraform.server.raioam.com"
    organization = "RAIOAM"
    country = "US"
  }
}

resource "tls_locally_signed_cert" "terraform-server-raioam-com" {
  cert_request_pem = "${tls_cert_request.terraform-server-raioam-com.cert_request_pem}"

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

# Import server cert
resource "aws_acm_certificate" "terraform-server-raioam-com" {
  private_key = "${tls_private_key.terraform-server-raioam-com.private_key_pem}"
  certificate_body = "${tls_locally_signed_cert.terraform-server-raioam-com.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.ca.cert_pem}"
}
# Generate client private key and cert
resource "tls_private_key" "terraform-jhw-raioam-com" {
  algorithm = "RSA"
}

resource "tls_cert_request" "terraform-jhw-raioam-com" {
  key_algorithm = "${tls_private_key.terraform-jhw-raioam-com.algorithm}"
  private_key_pem = "${tls_private_key.terraform-jhw-raioam-com.private_key_pem}"

  subject {
    common_name = "terraform.jhw.raioam.com"
    organization = "RAIOAM"
    country = "US"
  }
}

resource "tls_locally_signed_cert" "terraform-jhw-raioam-com" {
  cert_request_pem = "${tls_cert_request.terraform-jhw-raioam-com.cert_request_pem}"

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

# Import jhw client cert
resource "aws_acm_certificate" "terraform-jhw-raioam-com" {
  private_key = "${tls_private_key.terraform-jhw-raioam-com.private_key_pem}"
  certificate_body = "${tls_locally_signed_cert.terraform-jhw-raioam-com.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.ca.cert_pem}"
}

# create jhw VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "jhw" {
  description            = "Client VPN Endpoint for jhw"
  server_certificate_arn = "${aws_acm_certificate.terraform-server-raioam-com.arn}"
  client_cidr_block      = "10.0.0.0/16"
  split_tunnel = true
  tags = {
    Name = "terraform-jhw-vpn"
  }

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "${aws_acm_certificate.terraform-jhw-raioam-com.arn}"
  }

  connection_log_options {
    enabled               = false
  }
}
# Generate client private key and cert
resource "tls_private_key" "terraform-smj-raioam-com" {
  algorithm = "RSA"
}

resource "tls_cert_request" "terraform-smj-raioam-com" {
  key_algorithm = "${tls_private_key.terraform-smj-raioam-com.algorithm}"
  private_key_pem = "${tls_private_key.terraform-smj-raioam-com.private_key_pem}"

  subject {
    common_name = "terraform.smj.raioam.com"
    organization = "RAIOAM"
    country = "US"
  }
}

resource "tls_locally_signed_cert" "terraform-smj-raioam-com" {
  cert_request_pem = "${tls_cert_request.terraform-smj-raioam-com.cert_request_pem}"

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

# Import smj client cert
resource "aws_acm_certificate" "terraform-smj-raioam-com" {
  private_key = "${tls_private_key.terraform-smj-raioam-com.private_key_pem}"
  certificate_body = "${tls_locally_signed_cert.terraform-smj-raioam-com.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.ca.cert_pem}"
}

# create smj VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "smj" {
  description            = "Client VPN Endpoint for smj"
  server_certificate_arn = "${aws_acm_certificate.terraform-server-raioam-com.arn}"
  client_cidr_block      = "10.0.0.0/16"
  split_tunnel = true
  tags = {
    Name = "terraform-smj-vpn"
  }

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "${aws_acm_certificate.terraform-smj-raioam-com.arn}"
  }

  connection_log_options {
    enabled               = false
  }
}
# Generate client private key and cert
resource "tls_private_key" "terraform-wrt-raioam-com" {
  algorithm = "RSA"
}

resource "tls_cert_request" "terraform-wrt-raioam-com" {
  key_algorithm = "${tls_private_key.terraform-wrt-raioam-com.algorithm}"
  private_key_pem = "${tls_private_key.terraform-wrt-raioam-com.private_key_pem}"

  subject {
    common_name = "terraform.wrt.raioam.com"
    organization = "RAIOAM"
    country = "US"
  }
}

resource "tls_locally_signed_cert" "terraform-wrt-raioam-com" {
  cert_request_pem = "${tls_cert_request.terraform-wrt-raioam-com.cert_request_pem}"

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

# Import wrt client cert
resource "aws_acm_certificate" "terraform-wrt-raioam-com" {
  private_key = "${tls_private_key.terraform-wrt-raioam-com.private_key_pem}"
  certificate_body = "${tls_locally_signed_cert.terraform-wrt-raioam-com.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.ca.cert_pem}"
}

# create wrt VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "wrt" {
  description            = "Client VPN Endpoint for wrt"
  server_certificate_arn = "${aws_acm_certificate.terraform-server-raioam-com.arn}"
  client_cidr_block      = "10.0.0.0/16"
  split_tunnel = true
  tags = {
    Name = "terraform-wrt-vpn"
  }

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "${aws_acm_certificate.terraform-wrt-raioam-com.arn}"
  }

  connection_log_options {
    enabled               = false
  }
}
