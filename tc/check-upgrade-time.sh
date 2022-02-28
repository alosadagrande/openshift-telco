#!/bin/bash

VERSION=4.9.19

echo "Upgrade started at: $(date)"
start=$(date)

while true; 
do 
  status=$(oc get clusterversion version --no-headers | awk -v version=$VERSION '{ if($2==version) print "Upgrade finished"; else print}'); 
  echo $status
  if [ "$status" = "Upgrade finished" ]
  then
    stop=$(date)
    break 
  fi
  sleep 30 
done

echo "Upgrade to version $VERSION started at $start and finished at $stop"
