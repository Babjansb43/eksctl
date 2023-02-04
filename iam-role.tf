#role
resource "aws_iam_role" "artifactory" {
  name = "eksctl-k8s"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "eksctl"
  }
}

#policy
resource "aws_iam_policy" "artifactory" {
  name        = "eksctl-policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "ecr:*",
          "eks:*",
          "ec2:*",
        ],
        "Resource" : "*"
      }
    ]
  })
}

#attach
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.artifactory.name
  policy_arn = aws_iam_policy.artifactory.arn
}

#roletoec2

resource "aws_iam_instance_profile" "artifactory" {
  name = "eksctl-profile"
  role = aws_iam_role.artifactory.name
}