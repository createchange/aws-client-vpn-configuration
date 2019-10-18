output "jhw_cert_body" {
  value = "${tls_locally_signed_cert.terraform-jhw-raioam-com.cert_pem}"
}

output "jhw_private_key" {
  value = "${tls_private_key.terraform-jhw-raioam-com.private_key_pem}"
}

output "smj_cert_body" {
  value = "${tls_locally_signed_cert.terraform-smj-raioam-com.cert_pem}"
}

output "smj_private_key" {
  value = "${tls_private_key.terraform-smj-raioam-com.private_key_pem}"
}

output "wrt_cert_body" {
  value = "${tls_locally_signed_cert.terraform-wrt-raioam-com.cert_pem}"
}

output "wrt_private_key" {
  value = "${tls_private_key.terraform-wrt-raioam-com.private_key_pem}"
}

