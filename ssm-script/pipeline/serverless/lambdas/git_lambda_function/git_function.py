import json
import os
import shutil
from zipfile import ZipFile
import boto3
from urllib.parse import parse_qs
import urllib.parse
import urllib.request
import sys
sys.path.insert(0, 'lambdas/git_lambda_function')
import git_lambda

def handler(event, context):
    delete_files    = "rm -rf /tmp/*"
    os.system(delete_files)
    git_lambda.setup()
    print(event)
    REGION                  = os.environ["AWS_REGION"]
    client_parameter_store  = boto3.client('ssm',region_name=REGION)
    s3                      = boto3.resource('s3')
    BUCKET_NAME             = os.environ['BUCKET_NAME']
    ENVIRONMENT_NAME        = os.environ["ENVIRONMENT_NAME"]
    USER_NAME               = client_parameter_store.get_parameter( Name="/" + ENVIRONMENT_NAME + "/BitBucketUserName")['Parameter']['Value']
    APP_PASSWORD            = client_parameter_store.get_parameter( Name="/" + ENVIRONMENT_NAME + "/BitBucketAppPassword")['Parameter']['Value']
    branch_name  = event['body']['push']['changes'][0]['new']['name']
    print(branch_name)
    clone       =   "git clone -b " + branch_name + " https://" + USER_NAME + ":" + APP_PASSWORD + "@bitbucket.org/afrontier/velocicast.git /tmp/repo"
    os.system(clone)
    shutil.make_archive('/tmp/Gitpull', 'zip', "/tmp/repo")
    s3.meta.client.upload_file('/tmp/Gitpull.zip', BUCKET_NAME, 'Gitpull.zip')
    return { "statusCode": 200 }
