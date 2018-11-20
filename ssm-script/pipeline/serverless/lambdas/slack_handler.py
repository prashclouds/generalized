import os
import json
import boto3
from urllib.parse import parse_qs

import sys
sys.path.insert(0, 'lambdas/')
from branch_utility_functions import *
from git_lambda_function import *



def handler(event, context):
    REGION                  = os.environ["AWS_REGION"]
    BUCKET_NAME             = os.environ['BUCKET_NAME']
    ENVIRONMENT_NAME        = os.environ["ENVIRONMENT_NAME"]
    PARAMETER_STORE_CLIENT  = boto3.client('ssm',region_name=REGION)
    SLACK_TOKEN             = PARAMETER_STORE_CLIENT.get_parameter( Name="/" + ENVIRONMENT_NAME + "/SlackToken")['Parameter']['Value']

    SLACK_KEYS              = parse_qs(event['postBody'])
    REQUEST_TOKEN           = SLACK_KEYS["token"][0].split(" ")[0]
    try:
        METHOD_NAME             = SLACK_KEYS["text"][0].split(" ")[0]
    except:
        METHOD_NAME="help"

    is_valid = False
    for token in SLACK_TOKEN.split(",") :
        if REQUEST_TOKEN == token :
            is_valid = True
    if not is_valid :
        return { "statusCode": 200 , "text": "_REQUEST_TOKEN is not equal to SLACK_TOKEN_" , "response_type": "in_channel" }

    switcher = {
        "add_branch": add_branch.handler,
        "remove_branch": remove_branch.handler,
        "list_environments": list_environments.handler,
        "deploy": trigger_deploy.trigger_slack_deploy,
        "help": help
    }
    return switcher.get(METHOD_NAME, error)(event)


def error(event):
    return { "statusCode": 200 , "text": "_Execute help for help_" , "response_type": "in_channel" }

def help(event):
    message="*VELOCICAST APP*"
    attachments=[
        {
            "author_name": "add_branch",
            "footer": "Add a main branch to an environment",
            "title": "Arguments:",
            "color": "#e9a833",
            "fields": [
                {
                    "title": "Environment name",
                    "value": "The environment to add the branch to",
                    "short": "false"
                },
                {
                    "title": "Branch name",
                    "value": "The name of the branch to add",
                    "short": "false"
                }
            ]
        },
        {
            "author_name": "remove_branch",
            "footer": "Remove the main branch from an environment",
            "title": "Arguments:",
            "color": "#4d728a",
            "fields": [
                {
                    "title": "Environment name",
                    "value": "The environment to remove the main branch from",
                    "short": "false"
                }
            ]
        },
        {
            "author_name": "deploy",
            "footer": "Executes the deploy of a branch to an environment",
            "title": "Arguments:",
            "color": "#e9a833",
            "fields": [
                {
                    "title": "Environment name",
                    "value": "The environment to deploy the branch to",
                    "short": "false"
                },
                {
                    "title": "Branch name",
                    "value": "The name of the branch to deploy",
                    "short": "false"
                }
            ]
        },
        {
            "author_name": "list_environments",
            "footer": "Lists all the active environments",
            "title": "This method takes no arguments",
            "color": "#4d728a"
        },
        {
            "author_name": "help",
            "footer": "Displays this message",
            "color": "#4d728a"
        }
    ]
    return { "statusCode": 200 , "text": message, "attachments": attachments, "response_type": "in_channel" }


# LOCAL TESTING
# export AWS_REGION=us-east-1
# export BUCKET_NAME=pipeline-codepipeline
# export BUCKET_KEY=environment_state
# export ENVIRONMENT_NAME=pipeline
# export AWS_PROFILE=af
# print(handler({"postBody" : "token=abc123&text=help+test5+fas"},""))
