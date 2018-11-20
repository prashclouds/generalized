import os
import json
import boto3
from urllib.parse import parse_qs

def handler(event):
    BUCKET_NAME         = 		os.environ["BUCKET_NAME"]
    BUCKET_KEY          = 		os.environ["BUCKET_KEY"]

    slack_request=parse_qs(event['postBody'])
    try:
        CLUSTER_NAME    = slack_request["text"][0].split(" ")[1]
    except Exception :
      return { "statusCode": 200 , "text": "\"Invalid amount of parameter for add_branch, please use help command\"" , "response_type": "in_channel" }


    message          =      ""
    s3 = boto3.resource('s3')
    try:
      current_json = s3.Object(BUCKET_NAME, BUCKET_KEY).get()['Body'].read().decode('utf-8')
      current_json = eval(current_json)
    except Exception :
      return { "statusCode": 200 , "text": "\"DATABASE does not exist, Ask your administrator for help\"" , "response_type": "in_channel" }


    if len(current_json) == 0 :
        message = "_There are no environments at the moment_"
    else:
        flag = True
        for index in range(len(current_json)):
          element = current_json[index]
          if element["cluster_name"] == CLUSTER_NAME :
            message = "*"+CLUSTER_NAME+"*"
            attachments = [{
                "color": "#e9a833",
                "fields": [
                    {
                        "title": "Environment",
                        "value": CLUSTER_NAME,
                        "short": "true"
                    },
                    {
                        "title": "Removed Branch",
                        "value": " ".join(element["branches"]),
                        "short": "true"
                    }
                ]
            }]
            element["branches"].clear()
            flag = False
            break
        if flag :
            message = "The environment (" + CLUSTER_NAME + ") does not exist"
            return { "statusCode": 200, "message": message, "response_type": "in_channel" }

    s3 = boto3.client('s3')
    s3.put_object(Bucket=BUCKET_NAME,Key=BUCKET_KEY,Body=str(current_json).encode("utf-8"))
    return { "statusCode": 200, "attachments": attachments , "response_type": "in_channel" }
