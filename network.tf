resource "aws_vpc" "vpc" {
  for_each = var.vpc

  cidr_block           = each.value.cidr_block
  instance_tenancy     = each.value.instance_tenancy
  enable_dns_hostnames = each.value.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    {
      "Name" = "vpc-${each.key}"
    }
  )
}

resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.vpc[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    var.common_tags,
    {
      "Name" = "subnet-${each.key}-${each.value.vpc_name}"
    }
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_internet_gateway" "internetGateway" {
  for_each = var.internet_gateway

  vpc_id = aws_vpc.vpc[each.value.vpc_name].id

  tags = merge(
    var.common_tags,
    {
      "Name" = "interget_gateway-${each.key}-${each.value.vpc_name}"
    }
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_security_group" "securityGroup" {
  for_each = var.security_group_rule

  name        = each.value.sg_name
  description = each.value.sg_description
  vpc_id      = aws_vpc.vpc[each.value.vpc_name].id

  tags = merge(
    var.common_tags,
    {
      "Name" = "security_group-${each.key}-${each.value.vpc_name}"
    }
  )

  depends_on = [aws_vpc.vpc]
}

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = aws_vpc.main.cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }