#! /bin/bash

usage() {
   echo
   echo "Usage: nb_lwt_majbad.sh [-h | <dse_host_ip> [<local_dc_update> [<total_update_num> [<total_acct_num> [<lwt_update_ratio>]]]]"
   echo "       - <dse_host_ip>: DSE server IP"
   echo "       - <local_dc_update(yes | no): Whether to use LOCAL_SERIAL/LOCAL_QUORUM or SERIAL/QUORUM for writes"
   echo "       - <total_update_num>: Total number of updates to be made (default: 1000000)"
   echo "       - <total_acct_num>: Total number of accounts to be updated (default: 500)"
   echo "       - <lwt_update_ratio>: The ratio of LWT updates in the total updates (default: 0.5)"
   echo
}

if [[ $# -lt 1 || $1 == "-h" ]]; then
   usage
   exit 10
fi
#DSE_HOST=$1
DSE_HOST="172.31.84.167"

DFT_NB_THREAD_NUM=10

READ_CL=LOCAL_QUORUM
WRITE_CL=LOCAL_QUORUM
LWT_CL=LOCAL_SERIAL
YesOrNo=$(echo "$2" | tr '[:upper:]' '[:lower:]')
if [[ "$YesOrNo" == "no" ]]; then
   WRITE_CL=EACH_QUORUM
   LWT_CL=SERIAL
fi

TOTAL_UPDATE_NUM=1000000
if [[ "$3" != "" ]]; then
   TOTAL_UPDATE_NUM=$3
fi

TOTAL_ACCT_NUM=500
if [[ "$4" != "" ]]; then
   TOTAL_ACCT_NUM=$4
fi

LWT_UPDATE_RATIO=0.5
if [[ "$5" != "" ]]; then
   LWT_UPDATE_RATIO=$5
fi

echo "READ_CL=$READ_CL"
echo "WRITE_CL=$WRITE_CL"
echo "LWT_CL=$LWT_CL"
echo "TOTAL_UPDATE_NUM=$TOTAL_UPDATE_NUM"
echo "TOTAL_ACCT_NUM=$TOTAL_ACCT_NUM"
echo "LWT_UPDATE_RATIO=$LWT_UPDATE_RATIO"
echo
#exit

KS_NAME="mc_liq_demo"
TBL_ACCT="liq_acct"


MC_DEMO_NB_OUTPUT=mc_demo_output
START_TIME=$(date +'%Y-%m-%d_%H-%M-%S')
NB_REG_OUTPUT_DIR=$MC_DEMO_NB_OUTPUT/$START_TIME/$LWT_CL/nonlwt
NB_LWT_OUTPUT_DIR=$MC_DEMO_NB_OUTPUT/$START_TIME/$LWT_CL/lwt

echo "Initialize initial account balances... "
CMDSTR="nb run driver=cql errors=count workload=mc_liq_demo.yaml host=$DSE_HOST keyspace=$KS_NAME table_acct=$TBL_ACCT tags=phase:nolwt-main read_cl=$READ_CL write_cl=$WRITE_CL threads=$DFT_NB_THREAD_NUM acct_num=$TOTAL_ACCT_NUM cycles=$TOTAL_UPDATE_NUM drivermetrics=true --progress console:10s --report-csv-to \"$NB_REG_OUTPUT_DIR\""
echo ">>> executing NB workload <<<"
echo ">>> $CMDSTR"
echo "-----------------------------"
eval $CMDSTR
END_TIME=$(date +'%Y-%m-%d_%H-%M-%S')
echo "-----------------------------"
echo "$START_TIME ~ $END_TIME"
echo "-----------------------------"
echo

echo "Start LWT udpates: LWT Update Ratio: $LWT_UPDATE_RATIO ... "
START_TIME2=$(date +'%Y-%m-%d_%H-%M-%S')
CMDSTR="nb run driver=cql errors=count workload=mc_liq_demo.yaml host=$DSE_HOST keyspace=$KS_NAME table_acct=$TBL_ACCT tags=phase:lwt-main-rndm read_cl=$READ_CL write_cl=$WRITE_CL serial_cl=$LWT_CL lwt_ratio=$LWT_UPDATE_RATIO threads=$DFT_NB_THREAD_NUM acct_num=$TOTAL_ACCT_NUM cycles=$TOTAL_UPDATE_NUM drivermetrics=true --progress console:10s --report-csv-to \"$NB_LWT_OUTPUT_DIR\""
echo ">>> executing NB workload <<<"
echo "> $CMDSTR"
echo "-----------------------------"
eval $CMDSTR
END_TIME2=$(date +'%Y-%m-%d_%H-%M-%S')
echo "-----------------------------"
echo "$START_TIME2 ~ $END_TIME2"
echo "-----------------------------"
echo
