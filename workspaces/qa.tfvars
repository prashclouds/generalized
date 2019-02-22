environment   = "qa"
cluster_name  = "unitq"
region        = "us-west-2"

### VPC MODULE
vpc= {
    cidr          = "10.2.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default",
  }
