module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-ansible"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
   user_data = file("ec2-provision.sh")
  tags = merge(
    var.common_tags,
    {
      component="ansible"
    },
  {
    Name= "${local.ec2_name}-ansible"
  }
  )
}

module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-mongodb"
  ami = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="mongodb"
    },
  {
    Name= "${local.ec2_name}-mongodb"
  }
  )
}

module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-redis"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="redis"
    },
  {
    Name= "${local.ec2_name}-redis"
  }
  )
}


module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-mysql"
  ami = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="mysql"
    },
  {
    Name= "${local.ec2_name}-mysql"
  }
  )
}


module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-rabbitmq"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="rabbitmq"
    },
  {
    Name= "${local.ec2_name}-rabbitmq"
  }
  )
}

module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-catalogue"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="catalogue"
    },
  {
    Name= "${local.ec2_name}-catalogue"
  }
  )
}

module "user" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-user"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="user"
    },
  {
    Name= "${local.ec2_name}-user"
  }
  )
}

module "cart" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-cart"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="cart"
    },
  {
    Name= "${local.ec2_name}-cart"
  }
  )
}

module "shipping" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-shipping"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.shipping_sg_id.value]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="shipping"
    },
  {
    Name= "${local.ec2_name}-shipping"
  }
  )
}

module "payment" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-payment"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.payment_sg_id.value]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="payment"
    },
  {
    Name= "${local.ec2_name}-payment"
  }
  )
}

module "web" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.ec2_name}-web"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.web_sg_id.value]
  subnet_id              = local.public_subnet_ids

  tags = merge(
    var.common_tags,
    {
      component="web"
    },
  {
    Name= "${local.ec2_name}-web"
  }
  )
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  

  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb"
      type    = "A"
      ttl     = 1
      records = [
        "${module.mongodb.private_ip}",
      ]
    },
     {
      name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
        "${module.redis.private_ip}",
      ]
    },
     {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        "${module.mysql.private_ip}",
      ]
    },
     {
      name    = "rabbitmq"
      type    = "A"
      ttl     = 1
      records = [
        "${module.rabbitmq.private_ip}",
      ]
    },
     {
      name    = "catalogue"
      type    = "A"
      ttl     = 1
      records = [
        "${module.catalogue.private_ip}",
      ]
    },
     {
      name    = "user"
      type    = "A"
      ttl     = 1
      records = [
        "${module.user.private_ip}",
      ]
    },
     {
      name    = "cart"
      type    = "A"
      ttl     = 1
      records = [
        "${module.cart.private_ip}",
      ]
    },
     {
      name    = "shipping"
      type    = "A"
      ttl     = 1
      records = [
        "${module.shipping.private_ip}",
      ]
    },
     {
      name    = "payment"
      type    = "A"
      ttl     = 1
      records = [
        "${module.payment.private_ip}",
      ]
    },
     {
      name    = "web"
      type    = "A"
      ttl     = 1
      records = [
        "${module.web.private_ip}",
      ]
    },
  ]

  # depends_on = [module.zones]
}

