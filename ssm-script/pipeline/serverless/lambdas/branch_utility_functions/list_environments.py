import os
import json
import boto3
from urllib.parse import parse_qs

def handler(event):
    BUCKET_NAME      = 		os.environ["BUCKET_NAME"]
    BUCKET_KEY       = 		os.environ["BUCKET_KEY"]
    message          =      ""
    s3 = boto3.resource('s3')
    try:
      current_json = s3.Object(BUCKET_NAME, BUCKET_KEY).get()['Body'].read().decode('utf-8')
      current_json = eval(current_json)
    except Exception :
      return { "statusCode": 200 , "text": "\"DATABASE does not exist, Ask your administrator for help\"" , "response_type": "in_channel" }

    if len(current_json) == 0 :
        message = "_There are no environments at the moment_"
        return { "statusCode": 200 , "text": "Available environments:\n" + message , "response_type": "in_channel" }
    else:
        attachments = []
        for index in range(len(current_json)):
            element = current_json[index]
            attachments.append({"title": element["cluster_name"] + " -> Branch : " + ' '.join(element["branches"]) , "color": "#e9a833"})
        return { "statusCode": 200 , "text": "Available environments:", "attachments": attachments, "response_type": "in_channel" }
