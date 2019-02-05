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

Modify your environment parameters on the tfvars file inside the config folder, make sure that your vpc CIDR does not overlaps between environments, add the name of your pem key to the worker map variable.

Make sure to replace roleARN variable with the role you want to assign for the users that will have access to the EKS cluster through kubectl

```sh
env=qa
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
terraform destroy -var-file=config/${env}.tfvars
```
