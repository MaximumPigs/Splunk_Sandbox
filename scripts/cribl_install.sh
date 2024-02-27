#! /bin/bash

# Get Cribl and separate the bin files by leader and worker
curl -Lso /tmp/cribl.tgz $(curl https://cdn.cribl.io/dl/latest-x64)
tar -xzf /tmp/cribl.tgz -C /opt/
cp -R /opt/cribl /opt/cribl_leader
chown -R cribl:cribl /opt/cribl_leader

#Create target files and separate them
/opt/cribl_leader/bin/cribl boot-start enable -m systemd -u cribl
mv /etc/systemd/system/cribl.service /etc/systemd/system/cribl-leader.service

# Create appropriate symlinks for new files
systemctl disable cribl.service
systemctl enable cribl-leader.service

# Generate a random AUTH token
CRIBL_TOKEN=$(head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c32 | cut -c 1-)

# Generate a cert and key pair
mkdir /opt/cribl_cert
openssl req -x509 -newkey rsa:4096 -keyout /opt/cribl_cert/key.pem -out /opt/cribl_cert/cert.pem -days 3650 -nodes -subj "/C=AU/ST=Somewhere/L=CityName/O=CompanyName/OU=CompanySectionName/CN=Cribl"
chown -R cribl:cribl /opt/cribl_cert
chmod -R 700 /opt/cribl_cert

# Set cribl_leader to master mode and change to port 9001
/opt/cribl_leader/bin/cribl mode-master -u $CRIBL_TOKEN
cp /opt/cribl_leader/default/cribl/cribl.yml /opt/cribl_leader/local/cribl/cribl.yml
sed -i 's/port: 9000/port: 9001/g' /opt/cribl_leader/local/cribl/cribl.yml
chown -R cribl:cribl /opt/cribl_*

# Start cribl_services
systemctl start cribl_leader.service

# Bootstrap worker node from leader
curl "http://localhost:9001/init/install-worker.sh?group=default&token=$CRIBL_TOKEN&user=cribl&install_dir=%2Fopt%2Fcribl_worker" -k | bash -

# Bootstrap edge node from leader
curl "http://localhost:9001/init/install-edge.sh?group=default_fleet&token=$CRIBL_TOKEN&user=cribl&install_dir=%2Fopt%2Fcribl_edge" -k | bash -