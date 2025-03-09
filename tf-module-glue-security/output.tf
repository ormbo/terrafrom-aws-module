output "iam-role-glue-name" {
    value = aws_iam_role.glue_role.name
}
output "iam-role-glue-arn" {
    value = aws_iam_role.glue_role.arn
}

output "glue_security_group_id" {
    value = aws_security_group.glue-security-group.id
}