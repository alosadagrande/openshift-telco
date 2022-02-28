#!/bin/bash

echo "RAN DU profile started at: $(date)"
start=$(date)

while true; 
do 
  status=$(oc get policies ztp-cnfdc8-policies.cnfdc8-validator-validator-policy -n cnfdc8 --no-headers | awk '{ if($3=="Compliant") print "Profile finished"; else print}');
  echo $status
  if [ "$status" = "Profile finished" ]
  then
    stop=$(date)
    break 
  fi
  sleep 30 
done

echo "RAN DU profile installation started $start and finished at $stop"
