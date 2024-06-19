#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -c Cribl_IP"
   echo -e "\t-c The IP of the Cribl S2S listener"
   exit 1 # Exit script after printing help
}

while getopts "c:" opt
do
   case "$opt" in
      c ) CRIBL_IP="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Make Splunk UF directory and set perms
export SPLUNK_HOME="/opt/splunkforwarder"
mkdir $SPLUNK_HOME
chown -R splunkfwd:splunkfwd $SPLUNK_HOME

# Get latest version
UF_URL="$(curl https://www.splunk.com/en_us/download/universal-forwarder.html | grep -o -P 'data-link="[^"]+' | cut -c 12- | grep "amd64" | grep ".deb" | uniq)"


# Download splunk
curl -Lso /tmp/splunk_uf.deb $UF_URL

# Install splunk
dpkg -i /tmp/splunk_uf.deb

# Start splunk
$SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --seed-passwd "Administrator1!"

# Forward logs to Cribl

$SPLUNK_HOME/bin/splunk add forward-server $CRIBL_IP:9997
/usr/bin/s3cmd get s3://cg-resources-var/splunk-add-on-for-unix-and-linux_910.tgz /tmp/splunk-add-on-nix.tgz 
$SPLUNK_HOME/bin/splunk install app /tmp/splunk-add-on-nix.tgz -auth admin:Administrator1!
mkdir $SPLUNK_HOME/etc/apps/Splunk_TA_nix/local
cp $SPLUNK_HOME/etc/apps/Splunk_TA_nix/default/inputs.conf $SPLUNK_HOME/etc/apps/Splunk_TA_nix/local/inputs.conf
#sed -i 's/disabled = 1/disabled = 0/g' $SPLUNK_HOME/etc/apps/Splunk_TA_nix/local/inputs.conf
$SPLUNK_HOME/bin/splunk restart