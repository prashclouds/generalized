### Terraform


```sh
env=prod
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/braulio.tfvars
terraform apply -var-file=config/braulio.tfvars
terraform destroy -var-file=config/${env}.tfvars
```


terraform init -backend-config=config/backend-braulio.conf
terraform plan -var-file=config/braulio.tfvars


terraform init -backend-config=config/backend-utility.conf
