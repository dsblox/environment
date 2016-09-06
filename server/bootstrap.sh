#!/bin/bash

# Provision myself with David's project if not already done
# This is basically a master script that knows how to provision
# any project - so pass it the project as a parameter and it
# does the right thing.  provision.sh assumes only that Docker
# is installed and runable as NOT sudo.
if [ ! -f /home/ec2-user/.dab-provision/project ]; then
   curl http://169.254.169.254/latest/user-data > /home/ec2-user/.dab-provision/project
   curl https://raw.githubusercontent.com/dsblox/environment/master/provision.sh > /home/ec2-user/.dab-provision/provision.sh
   chmod +x /home/ec2-user/.dab-provision/provision.sh
   source /home/ec2-user/.dab-provision/provision.sh `cat /home/ec2-user/.dab-provision/project`
fi
