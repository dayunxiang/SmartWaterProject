#!/bin/sh
app_name="SmartLeakDetection" 
build_path="/Users/pelldav/University/Tesi/SmartWaterProject/"
dist_path="/Users/pelldav/University/Tesi/SmartWaterProject/dist/"

## Go to path 
cd $build_path

## Start the server Glassfish
asadmin start-domain domain1

## Build the war
ant

list_app=`asadmin list-applications --type web`

if echo "$list_app" | grep -q "$app_name"; then
  ## App just deployed, need to Undeploy and then Deploy the new version  
  asadmin undeploy $app_name 
  asadmin deploy  $dist_path$app_name.war
else
  ## No app deployed, need to Deploy  
  asadmin deploy  $dist_path$app_name.war
fi
