# Setup
```bash
git clone --recurse-submodules https://github.com/2024-2025-ECOM-INFO5-G04/ecom.git

cd ecom
```

Done :) 

Now to access and launch access the backend:

```bash
cd backend

./gradlew
```

To access and launch the frontend:

```bash
cd frontend

npm install

npm run start
```

# Deployment

## Generic Path 
We are using Terraform to deploy our application on Azure.

For a classic deployment, you will need to install Terraform and Azure CLI and then run the following commands:

```bash
terraform init
terraform apply
```

To shut down the deployment, you can run:

```bash
terraform destroy
```
## Advanced Path
To deploy it on a new environment, you will need to follow these steps.
### Azure Setup
1. On your Azure account, create a new resource group.
2. Create a new Public IP address linked to this resource group.

### Terraform Setup
You will need to edit the variables.tf file in the terraform folder.

`subscription_id` should be the subscription id of the Azure account you want to deploy to.

`resource_group_name` should be the name of the resource group you have created for the deployment.

`public_address_id` should be the id of the public IP address you have created. 
Format is: `/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/Microsoft.Network/publicIPAddresses/{public_ip_name}`

`location` should be the location of the resource group you have created.

`admin_username` should be the username you want to use to connect to the VM.

`public_ssh_key` should be the public key you want to use to connect to the VM.

### Final Step
Then, you can go back to the generic path and run the terraform commands.