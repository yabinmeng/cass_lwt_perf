#
# -------------------------------------------------
# EC2 instances that serve as DSE OpsCenter server
# -------------------------------------------------
#
resource "aws_instance" "clnt_opsc" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.dse_clnt_opsc_type)
   count           = lookup(var.instance_count, var.dse_clnt_opsc_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_opsc_web.id,aws_security_group.sg_opsc_node.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "mc_demo-opsc_srv_${count.index}"
      Environment  = var.env 
   }

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# EC2 instances that serve as NoSQLBench client
# -------------------------------------------------
#
resource "aws_instance" "clnt_nsb" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.dse_clnt_nb_type)
   count           = lookup(var.instance_count, var.dse_clnt_nb_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "mc_demo-nosqlbench_${count.index}"
      Environment  = var.env 
   }

   user_data = data.template_file.user_data.rendered
}

#
# -------------------------------------------------
# EC2 instances that serve as DSE servers
# -------------------------------------------------
# 
resource "aws_instance" "dse_core" {
   ami             = var.ami_id
   instance_type   = lookup(var.instance_type, var.dse_core_type)
   count           = lookup(var.instance_count, var.dse_core_type)
   vpc_security_group_ids = [aws_security_group.sg_mc_demo_group.id,aws_security_group.sg_ssh.id,aws_security_group.sg_dse_node.id]
   key_name        = aws_key_pair.dse_terra_ssh.key_name
   associate_public_ip_address = true

   tags = {
      Name         = "mc_demo-dse_core_${count.index}"
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