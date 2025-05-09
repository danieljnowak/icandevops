import json
import random
import os
import boto3
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext

# Initialize utilities
logger = Logger()
tracer = Tracer()
app = APIGatewayRestResolver()

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('QUOTES_TABLE_NAME', 'dannowak-quotes')
table = dynamodb.Table(table_name)

@app.get("/quotes/random")
@tracer.capture_method
def get_random_quote():
    """Get a random quote from DynamoDB"""
    try:
        # In a real implementation, this would scan the table with a limit
        # and then select a random item, but for simplicity we'll hardcode some quotes
        fallback_quotes = [
            {
                "id": "1",
                "text": "Infrastructure as code is worth the initial investment.",
                "author": "Dan Nowak",
                "category": "tech"
            },
            {
                "id": "2",
                "text": "The best automation is invisible.",
                "author": "Unknown",
                "category": "tech"
            },
            {
                "id": "3", 
                "text": "Measure twice, deploy once.",
                "author": "DevOps Proverb",
                "category": "tech"
            }
        ]
        
        # Try to get quotes from DynamoDB
        try:
            response = table.scan(Limit=100)
            quotes = response.get('Items', [])
            
            # If we have quotes in the database, use those
            if quotes:
                quote = random.choice(quotes)
            else:
                # Otherwise use our fallback quotes
                quote = random.choice(fallback_quotes)
                
        except Exception as e:
            logger.warning(f"Error accessing DynamoDB: {str(e)}. Using fallback quotes.")
            quote = random.choice(fallback_quotes)
        
        return {
            "statusCode": 200,
            "body": json.dumps(quote),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            }
        }
    except Exception as e:
        logger.error(f"Error retrieving quote: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to retrieve quote"}),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            }
        }

@app.get("/quotes/categories/<category>")
@tracer.capture_method
def get_quote_by_category(category):
    """Get a random quote from a specific category"""
    try:
        # In a real implementation, we would query by category
        # For simplicity, we'll filter the hardcoded quotes
        fallback_quotes = [
            {
                "id": "1",
                "text": "Infrastructure as code is worth the initial investment.",
                "author": "Dan Nowak",
                "category": "tech"
            },
            {
                "id": "2",
                "text": "The best automation is invisible.",
                "author": "Unknown",
                "category": "tech"
            },
            {
                "id": "3", 
                "text": "Measure twice, deploy once.",
                "author": "DevOps Proverb",
                "category": "tech"
            },
            {
                "id": "4", 
                "text": "The journey of a thousand miles begins with a single step.",
                "author": "Lao Tzu",
                "category": "inspiration"
            }
        ]
        
        try:
            # Try to query DynamoDB for quotes in the specified category
            response = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr("category").eq(category)
            )
            quotes = response.get('Items', [])
            
            # If we have quotes in the database, use those
            if quotes:
                quote = random.choice(quotes)
            else:
                # Otherwise use our fallback quotes filtered by category
                filtered_quotes = [q for q in fallback_quotes if q.get("category") == category]
                if filtered_quotes:
                    quote = random.choice(filtered_quotes)
                else:
                    return {
                        "statusCode": 404,
                        "body": json.dumps({"error": f"No quotes found for category: {category}"}),
                        "headers": {
                            "Content-Type": "application/json",
                            "Access-Control-Allow-Origin": "*"
                        }
                    }
                
        except Exception as e:
            logger.warning(f"Error accessing DynamoDB: {str(e)}. Using fallback quotes.")
            filtered_quotes = [q for q in fallback_quotes if q.get("category") == category]
            if filtered_quotes:
                quote = random.choice(filtered_quotes)
            else:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": f"No quotes found for category: {category}"}),
                    "headers": {
                        "Content-Type": "application/json",
                        "Access-Control-Allow-Origin": "*"
                    }
                }
        
        return {
            "statusCode": 200,
            "body": json.dumps(quote),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            }
        }
    except Exception as e:
        logger.error(f"Error retrieving quote: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to retrieve quote"}),
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            }
        }

@logger.inject_lambda_context
@tracer.capture_lambda_handler
def lambda_handler(event, context: LambdaContext):
    """Main Lambda handler function"""
    return app.resolve(event, context) 