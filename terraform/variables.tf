#
# The local directory where the SSH key files are stored (e.g. /home/<users>/.ssh)
#
variable "ssh_key_localpath" {
   default = "/Users/yabinmeng/.ssh"
}

#
# The local private SSH key file name 
#
variable "ssh_key_filename" {
   default = "id_rsa_aws"
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
# AWS resource tag identifier
#
variable "tag_identifier" {
   default = "mc_demo"
} 

#
# Environment description
#
variable "env" {
   default = "automation_test"
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
variable "opsc_srv_type" {
   default = "opsc_srv"
}
variable "nb_clnt_type" {
   default = "nb_clnt"
}
variable "dse_app_dc1_type" {
   default = "dse_app_dc1"
}
variable "dse_app_dc2_type" {
   default = "dse_app_dc2"
}

# How many instances for each category
variable "instance_count" {
   type = map
   default = {
      opsc_srv    = 1
      nb_clnt     = 1
      dse_app_dc1 = 3
      dse_app_dc2 = 3
   }
}

# Instance type for each category
variable "instance_type" {
   type = map
   default = {
      opsc_srv    = "m5a.2xlarge"
      nb_clnt     = "m5a.2xlarge"
      dse_app_dc1 = "i3.4xlarge"
      dse_app_dc2 = "i3.4xlarge"
   }
}
