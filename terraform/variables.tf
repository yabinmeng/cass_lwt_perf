provider "aws" {
   region     = var.region
}

#
# The local directory where the SSH key files are stored (e.g. /home/<users>/.ssh)
#
variable "ssh_key_localpath" {
   default = "<local_ssh_file_folder>"
}

#
# The local private SSH key file name 
#
variable "ssh_key_filename" {
   default = "id_rsa_aws"
}

# 
# SSH key used to access the EC2 instances
#
resource "aws_key_pair" "dse_terra_ssh" {
    key_name = var.keyname
    public_key = file("${var.ssh_key_localpath}/${var.ssh_key_filename}.pub")
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
  #default = "us-east-1"
  default = "eu-west-2"
}

#
# Default OS image: Ubuntu
# NOTE: AMI ID is specific to the chosen AWS region
#
variable "ami_id" {
   # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type (64-bit x86)
   # - for region: us-east-1 (N. Virginia)
   #default = "ami-0bcc094591f354be2"

   # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type (64-bit x86)
   # - for region: eu-west-2 (London)
   default = "ami-05c424d59413a2876"
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
      cassandra = 3
   }
}

# Instance type for each category
variable "instance_type" {
   type = map
   default = {
      opsc      = "m5a.2xlarge"
      nb        = "m5a.2xlarge"
      cassandra = "i3.4xlarge"
   }
}
