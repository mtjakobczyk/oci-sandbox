# oci-sandbox
Sandbox space for testing various OCI features

# Instance pools
Project folder: `instance-pools/`
This mini-project shows how to manage OCI Instance Pools  using Terraform.

```shell
git clone https://github.com/mtjakobczyk/oci-sandbox.git
cd instance-pools/

# Provision a new instance pool with 2 nodes
export TF_VAR_instance_pool_target_size=2
terraform apply --auto-approve && terraform refresh -var 'outputPoolIPs=true'

# Scale up to 3 nodes
export TF_VAR_instance_pool_target_size=3
terraform apply --auto-approve && terraform refresh -var 'outputPoolIPs=true'

# Scale down to 1 node
export TF_VAR_instance_pool_target_size=1
terraform apply --auto-approve && terraform refresh -var 'outputPoolIPs=true'

# Scale down to 0 nodes
export TF_VAR_instance_pool_target_size=0
terraform apply --auto-approve && terraform refresh -var 'outputPoolIPs=true'

# Scale up to 2 nodes
export TF_VAR_instance_pool_target_size=2
terraform apply --auto-approve && terraform refresh -var 'outputPoolIPs=true'

# Terminate the cloud infrastructure
export TF_VAR_instance_pool_target_size=2
terraform destroy --auto-approve
```
Why do we invoke terraform twice ? It is a workaround to the feature gap in Terraform 0.11.x (no null check for data source). First command (`terraform apply ...`) provisions or updates the cloud infrastructure. Second command (`terraform refresh ...`) fetches the list of private IPs for instance pool nodes
