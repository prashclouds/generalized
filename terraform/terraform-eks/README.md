### Terraform

## Prerequisites 

- Terraform v0.11.11
- Pem key already created
- To be able to deploy any environment first we will need to create the utility vpc, wich will have the openvpn server to be able to connect to the instances inside the private subnets.

## Deploy utility vpc

Move inside the vpc directory, modify the variables.tf and make sure that the vpcs will reside into the same region and the CIDR block must be different for each vpc, otherwise you wont be able to create a vpc peering.
Modify the key_name variable with the name of your pem key that you will use to connect to the openvpn server.
Modify the openvpn username and password, preferable use aws parameter store to retrieve these values.
Once the terraform is deployed the vpn server will need to be set up 
https://openvpn.net/vpn-server-resources/amazon-web-services-ec2-tiered-appliance-quick-start-guide/
```sh
cd utility/
terraform init
terraform apply
```
## Deploy your environment [dev,qa,prod]

Once the utility vpc is deployed, go back to the folder above and make sure that your backend configuration files are set properly, these files are located inside the config folder, make sure that the bucket and dynamo table exist, the dynamo table must have the string key `LockID`.

Modify the remote_state.tf file and make sure that the settings match with the `utility/provider.tf`, this is used to retrieve the outputs of the utility vpc and create the peering connection.
```sh
data "terraform_remote_state" "utility" {
  backend = "s3"
  config ={
    bucket  = "unitq-terraform-development"
    key     = "backend-utility.tfstate"
    encrypt = true
    region  = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
```

Modify your environment parameters on the tfvars file inside the config folder, make sure that your vpc CIDR does not overlaps between environments, add the name of your pem key to the worker map variable.

Make sure to replace roleARN variable with the role you want to assign for the users that will have access to the EKS cluster through kubectl

```sh
env=qa
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
terraform destroy -var-file=config/${env}.tfvars
```


## Allow Worker nodes and Users to connect your cluster

After applying the terraform you must copy the output [EKS_WORKER_ROLE]
and replace the values on the file below and create it.

Also make sure to replace <USER ROLE ARN> with the role you want to assign for the users that will have access to the EKS cluster through kubectl
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: <EKS_WORKER_ROLE>
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: <USER ROLE ARN>
      groups:
        - system:masters
```
Then perform `kubectl apply -f <name_of_your_file.yml>`

To update the kubeconfig you can execute the following command, this will update the kubeconfig and if your iam user has the role that will allow you access to the cluster you can start using kubectl

```sh
aws eks update-kubeconfig --name <cluster-name>
```
## Set up your OpenVPN

- SSH into the OpenVPN instance using the [pem key](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:sort=keyName) provided in the cluster parameters, you can also look for what key is in use by checking the description details of the ec2 instance on the EC2 section of the AWS console
- Once you have logged in into the machine you have to execute the following command
```sh 
sudo ovpn-init --ec2
```
- You will see a wizard asking for some questions like what port you should have your admin console, what interface should listen for connections and others, you can go with the default configuration, so hit enter and use default settings.
- Change the password for the user openvpn from the unix system `sudo passwd openvpn`, this user will be required to have a password for the admin login
- Login into the admin console by using the Public IP address like this https://publicIP/admin
- Go to https://publicIP/admin/user_permissions to create and set passwords for users so they can login and download their client.opvn profile
- You can download the client for openvpn from your server url once you are logged in.

For further instructions or questions refer to the documentation:
- https://openvpn.net/vpn-server-resources/amazon-web-services-ec2-tiered-appliance-quick-start-guide#running-the-openvpn-access-server-setup-wizard