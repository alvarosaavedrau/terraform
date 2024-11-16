resource "aws_instance" "awsInstance" {
  for_each = var.aws_instance

  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  associate_public_ip_address = each.value.associate_public_ip_address
  availability_zone           = each.value.availability_zone
  key_name                    = aws_key_pair.localKey[each.value.key_name].key_name

  ebs_block_device {
    delete_on_termination = each.value.delete_on_termination
    device_name           = each.value.device_name
    encrypted             = each.value.encrypted
    volume_size           = each.value.volume_size
    volume_type           = each.value.volume_type
  }
}

resource "aws_key_pair" "localKey" {
  for_each = var.key_pair

  key_name   = each.value.key_name
  public_key = file(each.value.public_key)
}