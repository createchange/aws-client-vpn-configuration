output "{{ item }}_cert_body" {
  value = "${tls_locally_signed_cert.terraform-{{ item }}-raioam-com.cert_pem}"
}

output "{{ item}}_private_key" {
  value = "${tls_private_key.terraform-{{ item }}-raioam-com.private_key_pem}"
}

