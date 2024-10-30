Creation Date: 2024-10-29

Tags: #devops #dataengineering

Related to: [[DevOps]]
________________________________
# Pre-requisites
1. **WSL Ubuntu** ("Windows Subsystem for Linux") installed on your system.
2. **Visual Studio Code** (VS Code) installed.
3. **Azure CLI** installed on your WSL Ubuntu instance.
4. **Terraform CLI** installed on your WSL Ubuntu instance.
5. **Azure subscription**.

After you have installed all the prerequisites, create your project repository. You can decide where and how to organize your project folders.

For example, you might create a folder structure like this: 
`C:\deta-enjinia\terraform-projects`

# Reference
< insert links / tutorials >

# Simplified Steps
In this section, you’ll find simplified steps to guide you from logging into Azure to creating a service principal and Azure storage account.

### Key commands (in order):
```bash
terraform init
```

```bash
terraform validate
```

```bash
terraform plan -auto-approve -var-file="secrets.tfvars"
```

```bash
terraform apply -auto-approve -var-file="secrets.tfvars"
```

```bash
terraform destroy -auto-approve -var-file="secrets.tfvars"
```

**Tip:** After finishing your `main.tf` script, you can format it using the command below:
```bash
terraform fmt
```

### 1. Login to your Azure account
```bash
az login
```

### 2. Set the subscription you want to use. This command will only need to be run once per session
```bash
DEFAULT_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
az account set --subscription $DEFAULT_SUBSCRIPTION_ID
```

### 3. Create the service principal. You can use any name you prefer; in this example, we’ll name it `tf-sp`
```bash
az ad sp create-for-rbac --name tf-sp --role Contributor --scopes /subscriptions/$DEFAULT_SUBSCRIPTION_ID
```

### 4. Create a file .env with the variables below
```bash
ARM_SUBSCRIPTION_ID=<subscription id>
ARM_CLIENT_ID=<appId value>
ARM_CLIENT_SECRET=<password value>
ARM_TENANT_ID=<tenant value>
ARM_SERVICE_PRINCIPAL_NAME=tf-sp
```

### 5. Create Terraform files
#### 5.1. Create variables.tf and define the `subscription_id` variable.
```terraform
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  sensitive   = true
}
```

#### 5.2. Create a Terraform file, which we’ll call `main.tf` in this example. 
This file will serve as the main module for building your infrastructure. For syntax guidance, refer to the examples in the provided GitHub repository.

#### 5.3. Create `secrets.tfvars` to store your `subscription_id` value.
In the `secrets.tfvars` file, store the actual value for `subscription_id`. 
**Important:** This file should not be included in version control (e.g. add secrets.tfvars to your `.gitignore` file):

```terraform
subscription_id = "your-actual-subscription-id"
```

The `secrets.tfvars` file provides a secure way to supply sensitive values separately from your main Terraform files.
### 6. Initialise the working directory by running the command below.
```bash
terraform init
```

### 7. Validate your configuration:
```bash
terraform validate
```
### 8. Run `terraform plan` to validate your configuration file. This command checks for syntax errors and displays the resources that will be created.
```bash
terraform plan -auto-approve -var-file="secrets.tfvars"
```

Using `-var-file="secrets.tfvars"` loads the `subscription_id` value without exposing it directly in your main configuration files.

**Important**: Starting from version 4.0, specifying the subscription ID in the provider section is mandatory. Refer to this link: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory

### 9.1 Run `terraform apply` to build or modify your infrastructure deployment. You’ll be prompted to confirm the actions by typing `yes`

### 9.2 If you prefer to skip the confirmation prompt, you can use the following command:
```bash
terraform apply -auto-approve -var-file="secrets.tfvars"
```

### 10. To delete the resources you created (e.g., `terraform-rg` and `labaigoadlsauc1`), run the following command:
```bash
terraform destroy -auto-approve -var-file="secrets.tfvars"
```