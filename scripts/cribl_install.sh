#! /bin/bash

# Get Cribl and separate the bin files by edge and stream
curl -Lso /tmp/cribl.tgz $(curl https://cdn.cribl.io/dl/latest-x64)
tar -xzf /tmp/cribl.tgz -C /opt/
cp -R /opt/cribl /opt/cribl_edge
mv /opt/cribl /opt/cribl_stream
chown -R cribl:cribl /opt/cribl_edge
chown -R cribl:cribl /opt/cribl_stream

#Create target files and separate them
/opt/cribl_edge/bin/cribl boot-start enable -m systemd -u cribl
mv /etc/systemd/system/cribl.service /etc/systemd/system/cribl_edge.service
/opt/cribl_stream/bin/cribl boot-start enable -m systemd -u cribl
mv /etc/systemd/system/cribl.service /etc/systemd/system/cribl_stream.service

# Create appropriate symlinks for new files
systemctl disable cribl.service
systemctl enable cribl_edge.service
systemctl enable cribl_stream.service

# Generate local directories for config
systemctl start cribl_edge.service
systemctl stop cribl_edge.service

# Change edge leader node to put it in master, and change API to port 9001 to deconflict with cribl_stream
cp /opt/cribl_edge/default/cribl/cribl.yml /opt/cribl_edge/local/cribl/cribl.yml
sed -i 's/port: 9000/port: 9001/g' /opt/cribl_edge/local/cribl/cribl.yml

# Set Cribl Edge to master mode
/opt/cribl_edge/bin/cribl mode-master -n Cribl

# Set all cribl folder perms back
chown -R cribl:cribl /opt/cribl_edge

# Start both services
systemctl start cribl_edge.service
systemctl start cribl_stream.service