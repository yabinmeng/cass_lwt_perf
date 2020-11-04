#
# -------------------------------------------------
# EC2 instances that serve as DSE OpsCenter server
# -------------------------------------------------
#
resource "aws_instance" "opsc_srv" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.opsc_srv_type)
   count           = lookup(var.instance_count, var.opsc_srv_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_opsc_web.id,aws_security_group.sg_opsc_node.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "${var.tag_identifier}-${var.opsc_srv_type}_${count.index}"
      Environment  = var.env 
   }

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# EC2 instances that serve as NoSQLBench client
# -------------------------------------------------
#
resource "aws_instance" "nb_clnt" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.nb_clnt_type)
   count           = lookup(var.instance_count, var.nb_clnt_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "${var.tag_identifier}-${var.nb_clnt_type}_${count.index}"
      Environment  = var.env 
   }

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# EC2 instances that serve as DSE servers, DC1
# -------------------------------------------------
# 
resource "aws_instance" "dse_app_dc1" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.dse_app_dc1_type)
   count           = lookup(var.instance_count, var.dse_app_dc1_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "${var.tag_identifier}-${var.dse_app_dc1_type}-${count.index}"
      Environment  = var.env 
   }  

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# EC2 instances that serve as DSE servers, DC2
# -------------------------------------------------
# 
resource "aws_instance" "dse_app_dc2" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.dse_app_dc2_type)
   count           = lookup(var.instance_count, var.dse_app_dc2_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "${var.tag_identifier}-${var.dse_app_dc2_type}-${count.index}"
      Environment  = var.env 
   }  

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# Minimum software that 
# -------------------------------------------------
# 
data "template_file" "user_data" {
   template = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install python-minimal -y
              apt-get install ntp -y
              apt-get install ntpstat -y
              ntpq -pcrv
   EOF
}