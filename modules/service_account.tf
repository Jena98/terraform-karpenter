data "aws_iam_policy_document" "karpenter" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_role_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter" {
  assume_role_policy = data.aws_iam_policy_document.karpenter.json
  name               = var.service_account_role_name

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.service_account_role_name })
  )
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  policy_arn = aws_iam_policy.karpenter.arn
  role       = aws_iam_role.karpenter.name
}

output "service_account_role_name" {
  value = aws_iam_role.karpenter.name
}

output "service_account_arn" {
  value = aws_iam_role.karpenter.arn
}

output "sa_policy_document" {
  value = data.aws_iam_policy_document.karpenter.json
}