# 
# -------------------------------------------------
# Security group rules:
# - open SSH port (22) to public (adjust if needed)
# -------------------------------------------------
#
resource "aws_security_group" "sg_ssh" {
   name = "sg_ssh"
   tags = {
      Name         = "mc_demo-sg_ssh"
      Environment  = var.env 
   }

   ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }
}

# 
# -------------------------------------------------
# Security group rules: 
# - open OpsCenter HTTPS access from anywhere
#   (assuming OpsCenter web access is enabled)
# -------------------------------------------------
#
resource "aws_security_group" "sg_opsc_web" {
   name = "sg_opsc_web"
   tags = {
      Name         = "mc_demo-sg_opsc_web"
      Environment  = var.env 
   }

   # OpsCenter server HTTPS port
   ingress {
      from_port = 8443
      to_port = 8443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   # OpsCenter server HTTPS port
   ingress {
      from_port = 8888
      to_port = 8888
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
}

#
# -------------------------------------------------
# Security group rules:
# - Dummy security groups that mark the group
# -------------------------------------------------
#
resource "aws_security_group" "sg_mc_demo_group" {
   name = "sg_mc_demo_group"
   tags = {
      Name         = "mc_demo-sg_mc_demo_group"
      Environment  = var.env 
   }
}


#
# -------------------------------------------------
# Security group rules:
# - Ports required for proper OpsCenter/Datastax-agent function
# -------------------------------------------------
#
resource "aws_security_group" "sg_opsc_node" {
   name = "sg_opsc_node"
   tags = {
      Name         = "mc_demo-sg_opsc_node"
      Environment  = var.env 
   }

   # Outbound: allow everything to everywhere
   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # OpsCenter Definitions port
   ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Stomp ports: agent -> opsc
   ingress {
      from_port = 61619
      to_port = 61620
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }
}

#
# -------------------------------------------------
# Security group rules:
# - Ports required for proper DSE function
# -------------------------------------------------
#
resource "aws_security_group" "sg_dse_node" {
   name = "sg_dse_node"
   tags = {
      Name         = "mc_demo-sg_dse_node"
      Environment  = var.env 
   }

   # Outbound: allow everything to everywhere
   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # DSE inter-node cluster communication port
   # - 7000: No SSL
   # - 7001: With SSL
   ingress {
      from_port = 7000
      to_port = 7001
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Spark master inter-node communication port
   ingress {
      from_port = 7077
      to_port = 7077
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # JMX monitoring port
   ingress {
      from_port = 7199
      to_port = 7199
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Port for inter-node messaging service
   ingress {
      from_port = 8609
      to_port = 8609
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Native transport port
   ingress {
      from_port = 9042
      to_port = 9042
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Native transport port, with SSL
   ingress {
      from_port = 9142
      to_port = 9142
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }

   # Stomp port: opsc -> agent
   ingress {
      from_port = 61621
      to_port = 61621
      protocol = "tcp"
      security_groups = [aws_security_group.sg_mc_demo_group.id]
   }
}