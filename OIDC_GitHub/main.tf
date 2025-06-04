resource "aws_iam_role" "github_action_role" {
  name  = "GitHub-Actions-Role-CICD"
  assume_role_policy = file("${path.module}/oidc_trust_policy.json")
}

resource "aws_iam_policy" "github_action_cicd_policy" {
  name   = "negev-github-action-ecr-policy"
  policy = file("${path.module}/policy.json")
}

resource "aws_iam_role_policy_attachment" "github_action_cicd_attach" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.github_action_cicd_policy.arn
}