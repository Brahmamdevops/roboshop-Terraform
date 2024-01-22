module "roboshop" {
  source = "../../terraform-aws-vpc"
  # source = "git::https://github.com/daws-76s/terraform-aws-vpc.git?ref=main"
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  project_name = var.project_name
  environment = var.environment

  #### public subnet ####
  public_subnets_cidr = var.public_subnets_cidr

  #### private subnet ####
  private_subnets_cidr = var.private_subnets_cidr

  #### database subnet ####
  database_subnets_cidr =  var.database_subnets_cidr

  is_peering_required = var.is_peering_required
}