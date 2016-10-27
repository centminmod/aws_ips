#!/bin/bash
#################################################################
# written by George Liu centminmod.com
# http://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html
#################################################################
AWS_REGIONS='ap-northeast-1 ap-northeast-2 ap-south-1 ap-southeast-1 ap-southeast-2 cn-north-1 eu-central-1 eu-west-1 sa-east-1 us-east-1 us-gov-west-1 us-west-1 us-west-2'

if [ ! -f /usr/bin/jq ]; then
  yum -q -y install jq
fi

get() {
 mkdir -p /root/tools/aws_ips
 cd /root/tools/aws_ips
 rm -rf ipranges.json
 wget -cnv https://ip-ranges.amazonaws.com/ip-ranges.json -O ipranges.json >/dev/null 2>&1
}

allips() {
  if [ -f /root/tools/aws_ips/ipranges.json ]; then
    jq -r '.prefixes | .[].ip_prefix' < ipranges.json | sort
  fi
}

region_list() {
  if [ -f /root/tools/aws_ips/ipranges.json ]; then
    cd /root/tools/aws_ips
    for r in $AWS_REGIONS; do
      echo
      echo "--------------------------------------------------"
      echo "$r ip ranges"
      jq  ".prefixes[] | select(.region==\"$r\")" < ipranges.json | sed -e 's|{||g' -e 's|}||g'
    done
  fi
}

regioncode_list() {
  if [ -f /root/tools/aws_ips/ipranges.json ]; then
    cd /root/tools/aws_ips
    for r in $AWS_REGIONS; do
      echo
      echo "[CODE]"
      echo "--------------------------------------------------"
      echo "$r ip ranges"
      jq  ".prefixes[] | select(.region==\"$r\")" < ipranges.json | sed -e 's|{||g' -e 's|}||g'
      echo "[/CODE]"
    done
  fi
}

case "$1" in
  ips )
get
allips
    ;;
  region )
get
region_list
    ;;
  regioncode )
get
regioncode_list
    ;;
  *)
  echo "$0 {ips|region|regioncode}"
    ;;
esac