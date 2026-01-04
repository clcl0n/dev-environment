# ========= #
#  Scripts  #
# ========= #

init-dev-operators:
	tofu -chdir=./modules/operators init -var-file=../../environments/dev/dev.operators.tfvars

init-dev-resources:
	tofu init -var-file=./environments/dev/dev.resources.tfvars

plan-dev-operators:
	tofu -chdir=./modules/operators plan -var-file=../../environments/dev/dev.operators.tfvars -out plan.tfplan

plan-dev-resources:
	tofu plan -var-file=./environments/dev/dev.resources.tfvars -out plan.tfplan

destroy-dev-operators:
	tofu -chdir=./modules/operators destroy -var-file=../../environments/dev/dev.operators.tfvars

destroy-dev-resources:
	tofu destroy -var-file=./environments/dev/dev.resources.tfvars

apply-dev-operators:
	tofu -chdir=./modules/operators apply plan.tfplan

apply-dev-resources:
	tofu apply plan.tfplan