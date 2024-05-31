/* Not required anymore - but keeping for reference

resource "aws_iam_policy" "s3_access" {
  name = "s3_access_cribl_output"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "ec2AssumeRole",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::chris-test-bucket-cribl/*",
          "arn:aws:s3:::chris-test-bucket-cribl"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2_s3_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ec2AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.s3_access.arn]

  tags = {
    "project" = "splunk_sandbox"
  }
}


resource "aws_iam_instance_profile" "Cribl_Test_EC2_Role" {
  name = "Cribl_Test_EC2_Role"
  role = data.aws_iam_role.Cribl_Test_EC2_Role.name
}

*/