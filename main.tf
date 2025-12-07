module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  cidr_block   = "10.0.0.0/16"
}


module "subnets" {
    source = "./modules/subnets"
    vpc_id = module.vpc.vpc_id
    project_name = var.project_name
    region = var.aws_region
    
    azs = [
        "us-east-1a",
        "us-east-1b"
    ]

}


output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnet_ids
}

output "private_subnets" {
  value = module.subnets.private_subnet_ids
}

output "interner_gateway" {
    value = module.subnets.interner_gateway_id
}

output "aws_nat_gateway" {
    value = module.subnets.aws_nat_gateway_ids
}


output "nat_elastic_ip" {
    value = module.subnets.aws_eip_ids
}
