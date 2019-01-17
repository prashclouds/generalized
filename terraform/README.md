### Terraform


```sh
env=prod
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars --auto-aprove
terraform destroy -var-file=config/${env}.tfvars
```