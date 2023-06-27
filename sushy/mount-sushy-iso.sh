HTTP_SERVER=10.19.138.94
HTTP_SERVER_PORT=80
NODE=$1
ISO=$2
VM_HOST="10.19.33.6:8888"

read -p "Spin up ${ISO} ISO in ${NODE} VM node [y/N]: " SPIN_UP

if [ "$SPIN_UP" == "y" ]; then
  VM_ID=$(kcli info vm $NODE -f id -v)
  #curl -ks ${VM_HOST}/redfish/v1/Managers/${VM_ID} | jq
  curl -ks ${VM_HOST}/redfish/v1/Systems/${VM_ID} | jq .Boot

  curl -ks -X PATCH -H 'Content-Type: application/json' -d '{
      "Boot": {
          "BootSourceOverrideTarget": "Cd",
          "BootSourceOverrideEnabled": "Continuous"
      }
    }'   "${VM_HOST}/redfish/v1/Systems/${VM_ID}"

  curl -ks ${VM_HOST}/redfish/v1/Systems/${VM_ID} | jq .Boot

  # Check inserted ISO:
  curl -ks ${VM_HOST}/redfish/v1/Managers/${VM_ID}/VirtualMedia/Cd/ | jq  '[{iso_connected: .Inserted}]'
  
  BOOTSTRAP_ISO="http://${HTTP_SERVER}:${HTTP_SERVER_PORT}/${ISO}"
############################

  curl -ks -d '{
      "Image":"'"${BOOTSTRAP_ISO}"'",
      "Inserted": true
    }' -H "Content-Type: application/json" \
   -X POST ${VM_HOST}/redfish/v1/Managers/${VM_ID}/VirtualMedia/Cd/Actions/VirtualMedia.InsertMedia

  curl -ks ${VM_HOST}/redfish/v1/Managers/${VM_ID}/VirtualMedia/Cd/ | jq  '[{iso_connected: .Inserted}]'

  #Start VM
    curl -s -d '{"ResetType":"ForceOff"}' -H "Content-Type: application/json" -X POST http://${VM_HOST}/redfish/v1/Systems/$VM_ID/Actions/ComputerSystem.Reset
  curl -ks -H "Content-Type: application/json" -X POST ${VM_HOST}/redfish/v1/Systems/${VM_ID}/Actions/ComputerSystem.Reset -d '{"ResetType": "ForceOn"}'

fi
