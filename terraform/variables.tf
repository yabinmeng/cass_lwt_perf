provider "aws" {
   region     = var.region
}

# 
# SSH key used to access the EC2 instances
#
resource "aws_key_pair" "dse_terra_ssh" {
    key_name = var.keyname
    public_key = file("${var.ssh_key_localpath}/${var.ssh_key_filename}.pub")
}

#
# The local directory where the SSH key files are stored
#
variable "ssh_key_localpath" {
   default = "/Users/yabinmeng/.ssh"
}

#
# The local private SSH key file name 
#
variable "ssh_key_filename" {
   default = "id_rsa_aws_mc_demo"
}

#
# AWS EC2 key-pair name
#
variable "keyname" {
   default = "dse-sshkey-mc-demo"
}

#
# Default AWS region
#
variable "region" {
  default = "us-east-1"
}

#
# Default OS image: Ubuntu
#
variable "ami_id" {
   # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type (64-bit x86)
   default = "ami-0bcc094591f354be2"
}

#
# Environment description
#
variable "env" {
   default = "mc-demo"
}

#
# EC2 instance categories in the test
# -----------------------------------------------
# -  "Client instance for OpsCenter Server"
# -  "Client instance for NoSQLBench"
# -  "DSE server (Core/Cassandra) instance"
# NOTE: make sure the type string matches the "key" string
#       in variable "instance_count/instance_type" map
# 
variable "dse_clnt_opsc_type" {
   default = "opsc"
}
variable "dse_clnt_nb_type" {
   default = "nb"
}
variable "dse_core_type" {
   default = "cassandra"
}

# How many instances for each category
variable "instance_count" {
   type = map
   default = {
      opsc      = 1
      nb        = 1
      cassandra = 2
   }
}

# Instance type for each category
variable "instance_type" {
   type = map
   default = {
      opsc      = "m5a.2xlarge"
      nb        = "m5a.2xlarge"
      cassandra = "i3.4xlarge"
      #cassandra = "m5.2xlarge"
   }
}
