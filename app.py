from flask import Flask
import boto3
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

def get_ssm_parameter(name):
    ssm = boto3.client("ssm", region_name=os.getenv("AWS_REGION", "ap-south-1"))
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response["Parameter"]["Value"]

# Read config from AWS SSM Parameter Store
MESSAGE_PARAM_NAME = os.getenv("MESSAGE_PARAM", "/hello-world/message")
try:
    message = get_ssm_parameter(MESSAGE_PARAM_NAME)
except Exception as e:
    message = f"Error fetching parameter: {str(e)}"

@app.route("/")
def hello():
    return {"message": message}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
