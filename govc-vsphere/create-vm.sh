#!/bin/sh
case "$1" in
    -h|--help|?)
    echo "Usage: This script uses GOVC to perform virtual machine creation and requires 2 input parameters."
    echo "1st arg: vCenter server address, user and password."
    echo "2st arg: Information to create virtual machines and source templates."
    echo "3st arg: destroy vms ,only support input "destroy""
    exit 0 
;;
esac

if [ ! -n "$1" ]; then
    echo "Please enter the first parameter: used to refer to the vCenter variable."
    exit
fi


if [ ! -n "$2" ]; then
    echo "Please enter the second parameter: used to refer to the virtual machine and template information variables"
    exit
fi
source $1
source $2

if ! [ `command -v jq` ];then
   echo "jq is not installed, please use "dnf install jq" to install it."
fi
if ! [ `command -v govc` ];then
   echo "govc is not installed,please installit."
fi

if [ -z $3 ]; then
  echo "Start deploying the target virtual machine in $GOVC_URL"
  for((i=0;i<=${#VMS[@]};i++)); do
  {  NEW_VM_NAME=$(echo $VMS |jq -r .[$i].vm_name)
    CPU=$(echo $VMS |jq -r .[$i].vm_cpu)
    MEM=$(echo $VMS |jq -r .[$i].vm_mem)
    IP=$(echo $VMS |jq -r .[$i].vm_ip)
    MASK=$(echo $VMS |jq -r .[$i].vm_mask)
    GATE=$(echo $VMS |jq -r .[$i].vm_gateway)
    DNS=$(echo $VMS |jq -r .[$i].vm_dns)
    govc vm.clone -vm "$TEMP_VM_NAME" -ds="$DS" -cluster="$CLUSTER_NAME" -pool="$RESOURCE_POOL" -c=$CPU -m=$MEM -on=false -annotation="$DESC" "$NEW_VM_NAME"
    govc vm.customize -vm $NEW_VM_NAME -ip $IP -netmask $MASK -gateway $GATE -dns-server "$DNS" "$SPEC"
    govc vm.power -on "$NEW_VM_NAME"
  }&
  done
  echo "All vms has deploy."
else
  if [ $3 == 'destroy' ]; then
    echo "Start destroy the target virtual machine in $GOVC_URL"
    for((i=0;i<=${#VMS[@]};i++)); do
      {  NEW_VM_NAME=$(echo $VMS |jq -r .[$i].vm_name)
     govc vm.destroy "$NEW_VM_NAME"
    }&
    done
    echo "All vms has destroy."
  else
     echo "The third parameter only supports "destroy"."
  fi
fi

