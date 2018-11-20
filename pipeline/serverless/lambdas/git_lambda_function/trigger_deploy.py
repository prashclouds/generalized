import boto3
import os

def trigger_slack_deploy(event):
    client = boto3.client('lambda')

    LAMBDA_NAME         = os.environ["LAMBDA_NAME"]

    BODY                = event['postBody']
    payload="{\"postBody\" :  \"" + BODY + "\"  }"
    response = client.invoke(
        FunctionName=LAMBDA_NAME,
        InvocationType='Event',
        Payload=payload.encode("utf-8")
    )

    return { "statusCode": 200 , "text": "_Starting the deployment_" , "response_type": "in_channel" }


def trigger_git_pull(event, context):
    client = boto3.client('lambda')

    LAMBDA_NAME         = os.environ["LAMBDA_NAME"]
    BRANCH_NAME         = event['body']['push']['changes'][0]['new']['name']
    payload="{\"body\" : { \"push\" : { \"changes\" : [ { \"new\" : { \"name\" : \"" + BRANCH_NAME + "\" }  } ] } } }"
    response = client.invoke(
        FunctionName=LAMBDA_NAME,
        InvocationType='Event',
        Payload=payload.encode("utf-8")
    )

    return { "statusCode": 200 }
