#!/bin/bash
set -xe

if [ -f "./env.tar.gz" ]; then
  ls -la
  rm -rf -- $(ls | grep -v env.tar.gz)
  ls -la
  tar -zxf env.tar.gz
  ls -la
  rm -f env.tar.gz
fi

base_dir=$(pwd)

cd $base_dir/6-org-policies

cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)
$(gcloud scc notifications describe "scc-notify" --organization=${ORGANIZATION_ID} ) || true

#Retrieve Service Account Email
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./development/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./nonproduction/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./production/terraform.tfvars
# cat ./common.auto.tfvars

cd ./common 
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply

terraform plan -input=false -out org_policy_common.tfplan

terraform apply org_policy_common.tfplan

cd ..
pwd
cd ./development
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply

terraform plan -input=false -out org_policy_development.tfplan

terraform apply org_policy_development.tfplan

cd ..
pwd
cd ./nonproduction
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply
terraform plan -input=false -out org_policy_nonproduction.tfplan

terraform apply org_policy_nonproduction.tfplan

cd ..
pwd
cd ./production
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply
terraform plan -input=false -out org_policy_production.tfplan

terraform apply org_policy_production.tfplan

cd ..
pwd
set +e
unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

rm -rf ./development/.terraform
rm -rf ./nonproduction/.terraform
rm -rf ./production/.terraform
rm -rf ./management/.terraform
rm -rf ./identity/.terraform
rm -rf ./common/.terraform
cd ..
pwd
tar -zcf env.tar.gz --exclude env.tar.gz . 
tar -zcf env.tar.gz --exclude env.tar.gz --exclude .git --exclude docs . 
ls -la
pwd
