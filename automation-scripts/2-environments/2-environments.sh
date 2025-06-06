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

# Set base directory 
base_dir=$(pwd)

cd $base_dir/2-environments
ls -la
# ln -s terraform.mod.tfvars terraform.tfvars

#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

# Retrieve Actual Bucket Name
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./terraform.tfvars

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw environment_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}
ls -la 
cat ./terraform.tfvars
cat ./envs/development/terraform.tfvars
cat ./envs/nonproduction/terraform.tfvars
cat ./envs/production/terraform.tfvars

#Terraform init,plan,validate,apply for development env
./tf-wrapper.sh init development
./tf-wrapper.sh plan development
set +e
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply development

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
set +e
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply nonproduction

#Terraform init,plan,validate,apply for production env
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
set +e
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply production

./tf-wrapper.sh init management
./tf-wrapper.sh plan management
set +e
./tf-wrapper.sh validate management $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply management

./tf-wrapper.sh init identity
./tf-wrapper.sh plan identity
set +e
./tf-wrapper.sh validate identity $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply identity
set +e

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

rm -rf ./envs/development/.terraform
rm -rf ./envs/nonproduction/.terraform
rm -rf ./envs/production/.terraform
rm -rf ./envs/management/.terraform
rm -rf ./envs/identity/.terraform
cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
tar -zcf env.tar.gz --exclude env.tar.gz --exclude .git --exclude docs . 
ls -la
pwd