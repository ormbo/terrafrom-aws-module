output "cluster_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

output "cluster_dns_name" {
  value = aws_redshift_cluster.redshift_cluster.dns_name
}
output "secret_credentials" {
  value = aws_redshift_cluster.redshift_cluster.master_password_secret_arn
}