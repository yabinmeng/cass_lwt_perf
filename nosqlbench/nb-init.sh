#! /bin/bash

usage() {
   echo
   echo "Usage: nb_create_schema.sh [-h | <dse_host_ip> <create_schema> <acct_num>]"
   echo "       - <dse_host_ip>: DSE server IP"
   echo "       - <create_schema> (yes | no): Whether or not to create schema before populating data"
   echo "       - <create_schema>: The number of accounts (default: 400)"
   echo
}

if [[ $# -lt 2 || $1 == "-h" ]]; then
   usage
   exit 10
fi
DSE_HOST=$1

DFT_NB_THREAD_NUM=5

# If needed, create keyspace and tables  (with customized keyspace and/or table names)
# - default names are the same as nosqlbench scenario defaults
KS_NAME="mc_liq_demo"
TBL_ACCT="liq_acct"
TBL_TXN="transaction"

##############
# create schema
YesOrNo=$(echo "$2" | tr '[:upper:]' '[:lower:]')
if [[ "$YesOrNo" == "yes" ]]; then
   echo "Create C* schema for the demo ..."
   CMDSTR="nb run driver=cql workload=mc_liq_demo.yaml host=$DSE_HOST keyspace=$KS_NAME table_acct=$TBL_ACCT table_txn=$TBL_TXN tags=phase:schema"
   #echo $CMDSTR
   eval $CMDSTR
   echo
fi

##############
# populate initial data into "liquidity account" and "transaction" tables
echo "Populate data records into "liquidity account" table..."
TOTAL_ACCT_NUM=400
if [[ "$3" != "" ]]; then
   TOTAL_ACCT_NUM=$3
fi
CMDSTR="nb run driver=cql workload=mc_liq_demo.yaml host=$DSE_HOST keyspace=$KS_NAME table_acct=$TBL_ACCT tags=phase:create-liquid-accounts threads=$DFT_NB_THREAD_NUM acct_num=$TOTAL_ACCT_NUM cycles=$TOTAL_ACCT_NUM"
#echo $CMDSTR
eval $CMDSTR
echo

echo "Populate data records into "transaction" table..."
TOTAL_TXN_NUM=5000
CRED_DEBIT_RATIO=0.5
CMDSTR="nb run driver=cql workload=mc_liq_demo.yaml host=$DSE_HOST keyspace=$KS_NAME table_txn=$TBL_TXN tags=phase:create-transactions threads=$DFT_NB_THREAD_NUM cred_deb_ratio=$CRED_DEBIT_RATIO txn_num=$TOTAL_TXN_NUM cycles=$(($TOTAL_TXN_NUM*2))"
#echo $CMDSTR
eval $CMDSTR
echo
