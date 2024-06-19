#!/bin/bash

# Download splunk
curl -Lso /tmp/splunk.deb https://download.splunk.com/products/splunk/releases/9.2.0.1/linux/splunk-9.2.0.1-d8ae995bf219-linux-2.6-amd64.deb

# Install splunk
dpkg -i /tmp/splunk.deb

# Start splunk
/opt/splunk/bin/splunk start --accept-license --answer-yes --seed-passwd "Administrator1!"

# Get some dummy data in

mkdir -p /var/log/dummy
curl -Lso /tmp/dummy.zip https://docs.splunk.com/images/Tutorial/tutorialdata.zip
/opt/splunk/bin/splunk add monitor /var/log/dummy/ -host_segment 1 -index default -auth admin:Administrator1!
