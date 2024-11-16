variable "aws_region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "vpc" {
  type = map(object({
    cidr_block           = string
    instance_tenancy     = string
    enable_dns_hostnames = bool
  }))
  default = {}
}

variable "subnets" {
  type = map(object({
    vpc_name                = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = {}
}

variable "internet_gateway" {
  type = map(object({
    vpc_name = string
  }))
  default = {}
}

variable "aws_instance" {
  type = map(object({
    ami_id                      = string
    instance_type               = string
    associate_public_ip_address = bool
    availability_zone           = string
    key_name                    = string
    delete_on_termination       = bool
    device_name                 = string
    encrypted                   = bool
    volume_size                 = number
    volume_type                 = string
  }))
  default = {}
}

variable "key_pair" {
  type = map(object({
    key_name   = string
    public_key = string
  }))
  default = {}
}

variable "security_group_rule" {
  type = map(object({
    sg_name        = string
    sg_description = string
    vpc_name       = string
  }))
  default = {}
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
