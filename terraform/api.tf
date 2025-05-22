#VPC
resource "aws_api_gateway_rest_api" "api" {
  name = "Techno-API-ibrahim"
  description = "techno-api"
  endpoint_configuration {
    ip_address_type = "dualstack"
    types = ["REGIONAL"]
  }
}

#PATH GENERATE-TOKEN
resource "aws_api_gateway_resource" "api-generate-token" { 
  rest_api_id = aws_api_gateway_rest_api.api.id 
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id 
  path_part   = "generate-token" 
}

#METHOD POST
resource "aws_api_gateway_method" "api-generate-token-post" { 
  rest_api_id   = aws_api_gateway_rest_api.api.id 
  resource_id   = aws_api_gateway_resource.api-generate-token.id 
  http_method   = "POST" 
  authorization = "NONE" 
}

resource "aws_api_gateway_integration" "int-generate-token" { 
  rest_api_id             = aws_api_gateway_rest_api.api.id 
  resource_id             = aws_api_gateway_resource.api-generate-token.id 
  http_method             = aws_api_gateway_method.api-generate-token-post.http_method 
  integration_http_method = "POST" 
  type                    = "AWS_PROXY" 
  uri                     = aws_lambda_function.post-lambda.invoke_arn 
}

#PATH VALIDATE
resource "aws_api_gateway_resource" "api-validate-token" { 
  rest_api_id = aws_api_gateway_rest_api.api.id 
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id 
  path_part   = "validate-token" 
}

#GET METHOD
resource "aws_api_gateway_method" "api-method-validate" { 
  rest_api_id   = aws_api_gateway_rest_api.api.id 
  resource_id   = aws_api_gateway_resource.api-validate-token.id 
  http_method   = "GET" 
  authorization = "NONE" 
}

resource "aws_api_gateway_integration" "api-int-get" { 
  rest_api_id             = aws_api_gateway_rest_api.api.id 
  resource_id             = aws_api_gateway_resource.api-validate-token.id 
  http_method             = aws_api_gateway_method.api-method-validate.http_method 
  integration_http_method = "POST" 
  type                    = "AWS_PROXY" 
  uri                     = aws_lambda_function.get-lambda.invoke_arn 
}

#PERMS API
resource "aws_lambda_permission" "lambda-post-perms" { 
  statement_id  = "AllowAPIGatewayInvokePOST" 
  action        = "lambda:InvokeFunction" 
  function_name = aws_lambda_function.post-lambda.function_name 
  principal     = "apigateway.amazonaws.com" 
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}//" 
}

resource "aws_lambda_permission" "lambda-get-perms" { 
  statement_id  = "AllowAPIGatewayInvokeGET" 
  action        = "lambda:InvokeFunction" 
  function_name = aws_lambda_function.get-lambda.function_name 
  principal     = "apigateway.amazonaws.com"
   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}//" 
  }

resource "aws_api_gateway_deployment" "api-deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api-generate-token.id,
      aws_api_gateway_resource.api-validate-token.id,
      aws_api_gateway_method.api-generate-token-post.id,
      aws_api_gateway_method.api-method-validate.id,
      aws_api_gateway_integration.api-int-get.id,
      aws_api_gateway_integration.int-generate-token.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api-stage" {
  deployment_id = aws_api_gateway_deployment.api-deploy.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}