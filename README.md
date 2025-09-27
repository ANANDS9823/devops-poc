# Hello World Microservice

A simple Flask microservice that fetches a message from AWS SSM Parameter Store and returns it on `/`.

## Usage

### 1. Set Parameter in AWS SSM

```sh
aws ssm put-parameter \
  --name "/hello-world/message" \
  --value "Hello from AWS SSM!" \
  --type "String" \
  --overwrite
