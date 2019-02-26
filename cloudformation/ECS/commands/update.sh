cd "${BASH_SOURCE%/*}" || exit
cd ..
COMMAND=$(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' config.yml) 
eval $COMMAND 
aws cloudformation update-stack --region us-west-2 --stack-name "$StackName" --template-body file://master.yml --parameters ParameterKey=KeyPair,ParameterValue="$KeyPair" --capabilities CAPABILITY_NAMED_IAM