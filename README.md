# HashiCorp Terraform 2021: Hands-On & Terraform Labs

---

```terraform
provider "aws" {
  access_key = ${var.AWS_ACCESS_KEY}
  secret_key = ${var.AWS_SECRET_KEY}
  region = ${var.AWS_REGION}
}
```

- Variables file extension vars.tf variables.tfvars
- `*`.tfvars must be configured in runtime

```terraform
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
AWS_REGION=""
```

```bash
terraform plan --var AWS_ACCESS_KEY="{{ACCESS_KEY_HERE}}" -var AWS_SECRET_KEY="{{SECRET_KEY_HERE}}"
```

- Packer ia tool to Bundle the Custom AMIs