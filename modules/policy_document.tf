resource "aws_iam_policy" "karpenter" {
  name        = var.service_account_policy_name
  description = "karpenter policy"

  policy = <<EOF
{
   "Statement":[
      {
         "Action":[
            "ssm:GetParameter",
            "iam:PassRole",
            "ec2:DescribeImages",
            "ec2:RunInstances",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeInstanceTypeOfferings",
            "ec2:DescribeAvailabilityZones",
            "ec2:DeleteLaunchTemplate",
            "ec2:CreateTags",
            "ec2:CreateLaunchTemplate",
            "ec2:CreateFleet",
            "ec2:DescribeSpotPriceHistory",
            "pricing:GetProducts"
         ],
         "Effect":"Allow",
         "Resource":"*",
         "Sid":"Karpenter"
      },
      {
         "Action":"ec2:TerminateInstances",
         "Condition":{
            "StringLike":{
               "ec2:ResourceTag/Name":"*karpenter*"
            }
         },
         "Effect":"Allow",
         "Resource":"*",
         "Sid":"ConditionalEC2Termination"
      }
   ],
   "Version":"2012-10-17"
}
EOF

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.service_account_policy_name })
  )
}