output "cluster_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

output "cluster_id" {
  value = aws_redshift_cluster.redshift_cluster.id
}