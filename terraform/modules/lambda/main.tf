# -------------------------------
# IAM Role for Lambda Functions
# -------------------------------

# Create an IAM role that allows Lambda to execute and interact with DynamoDB
resource "aws_iam_role" "lambda_role" {
  name = "lambda_url_shortener_role"

  # Define the trust policy so that Lambda can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# -------------------------------
# IAM Policy for Lambda to Access DynamoDB & CloudWatch Logs
# -------------------------------

# Attach a policy that allows Lambda to read/write to the DynamoDB table
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Allows Lambda to access DynamoDB for URL shortener"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.url_shortener_table.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# -------------------------------
# DynamoDB Table for URL Shortener
# -------------------------------

resource "aws_dynamodb_table" "url_shortener_table" {
  name         = "url-shortener-table"
  billing_mode = "PAY_PER_REQUEST"  # Free-tier friendly
  hash_key     = "short_code"       # Partition key

  attribute {
    name = "short_code"
    type = "S"
  }

  # Enable point-in-time recovery (optional, for backup purposes)
  point_in_time_recovery {
    enabled = true
  }
}

# -------------------------------
# Lambda Function: Shorten URL
# -------------------------------

resource "aws_lambda_function" "shorten_lambda" {
  function_name    = "shorten-url"
  handler         = "shorten.lambda_handler"
  runtime         = "python3.9"
  role           = aws_iam_role.lambda_role.arn
  filename       = "shorten.zip"  # Ensure this file is built and uploaded
  
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.url_shortener_table.name
    }
  }
}

# -------------------------------
# Lambda Function: Redirect to Original URL
# -------------------------------

resource "aws_lambda_function" "redirect_lambda" {
  function_name    = "redirect-url"
  handler         = "redirect.lambda_handler"
  runtime         = "python3.9"
  role           = aws_iam_role.lambda_role.arn
  filename       = "redirect.zip"  # Ensure this file is built and uploaded
  
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.url_shortener_table.name
    }
  }
}
