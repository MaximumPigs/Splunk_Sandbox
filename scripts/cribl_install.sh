#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -o githubRepoOwner -r githubRepo -b githubProdBranch -d githubDevBranch -t criblAuthToken"
   echo -e "\t-o The Owner of the remote repository"
   echo -e "\t-r The remote GitHub repository name"
   echo -e "\t-b The Prod branch of the remote GitHub repository to fetch (defaults to master)"
   echo -e "\t-b The Dev branch of the remote GitHub repository to fetch (defaults to master)"
   echo -e "\t-t The cribl Auth Token set on the Leader - for bootstrapping workers"
   exit 1 # Exit script after printing help
}

while getopts "o:r:b:d:t:" opt
do
   case "$opt" in
      o ) GHowner="$OPTARG" ;;
      r ) GHrepo="$OPTARG" ;;
      b ) GHbranch_prod="$OPTARG" ;;
      d ) GHbranch_dev="$OPTARG" ;;
      t ) CriblToken="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$GHowner" ] || [ -z "$GHrepo" ] || [ -z "$CriblToken" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Set Git prod branch to master if null
if [ -z "$GHbranch_prod" ]
then
    GHbranch_prod="master"
fi

# Set Git dev branch to dev if null
if [ -z "$GHbranch_dev" ]
then
    GHbranch_dev="dev"
fi

# Construct GitHub URL
GHurl="git@github.com:$GHowner/$GHrepo.git"

# Get Cribl and separate the bin files by leader and worker
curl -Lso /tmp/cribl.tgz $(curl https://cdn.cribl.io/dl/latest-x64)
tar -xzf /tmp/cribl.tgz -C /opt/
cp -R /opt/cribl /opt/cribl_leader

# Fetch the remote git repo
ssh-keyscan -H github.com >> /home/cribl/.ssh/known_hosts
chown cribl:cribl /home/cribl/.ssh/known_hosts
ssh-keyscan -H github.com >> /root/.ssh/known_hosts
cd /opt/cribl_leader
git init
git config --system core.sshCommand "ssh -i /home/cribl/.ssh/priv_key"
git config --system --add safe.directory /opt/cribl_leader
git remote add origin $GHurl
git checkout -b $GHbranch_prod
git fetch origin $GHbranch_prod
git reset --hard origin/$GHbranch_prod
git checkout -b $GHbranch_dev

# Clean up
chown -R cribl:cribl /opt/cribl_leader

#Create target files and separate them
/opt/cribl_leader/bin/cribl boot-start enable -m systemd -u cribl
mv /etc/systemd/system/cribl.service /etc/systemd/system/cribl-leader.service

# Create appropriate symlinks for new files
systemctl disable cribl.service
systemctl enable cribl-leader.service

# Start cribl_services
systemctl start cribl-leader.service

# Bootstrap worker node from leader
curl "https://localhost:9001/init/install-worker.sh?group=default&token=$CriblToken&user=cribl&install_dir=%2Fopt%2Fcribl_worker" -k | bash -

# Bootstrap edge node from leader
curl "https://localhost:9001/init/install-edge.sh?group=default_fleet&token=$CriblToken&user=cribl&install_dir=%2Fopt%2Fcribl_edge" -k | bash -