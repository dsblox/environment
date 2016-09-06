#!/bin/bash
if [ -z "$DAB_SRCPATH" ]; then
  echo "DAB_SRCPATH must be set to use this script to set the rest of env"
  exit 
fi

# add my ssh keys to the session (avoiding config to more easily share across machines)
chmod 600 $DAB_SRCPATH/security/keys/personal/id_rsa
ssh-add $DAB_SRCPATH/security/keys/personal/id_rsa

# clear any AWS mess that would interfere with the aws cli - we may use these later ourselves
unset EC2_KEYS_HOME
unset EC2_PRIVATE_KEY
unset EC2_CERT
unset AMAZON_ACCOUNT_ID
unset AMAZON_ACCESS_KEY_ID
unset AMAZON_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY

# general stuff useful to me
alias cd-src='cd '$DAB_SRCPATH
alias cd-env='cd-src;cd environment'
alias dangling='docker rmi $(docker images -f "dangling=true" -q)'

# message-secure-send environment
export CONT_MSS_PATH=/go/src/github.com/dsblox/mss
export HOST_MSS_PATH=$DAB_SRCPATH/go/src/github.com/dsblox/mss
alias cd-mss='cd '$HOST_MSS_PATH
alias init-mss='docker pull dsblox/mss'
alias dev-mss='docker run --rm -it -p 4000:4000 -w '$CONT_MSS_PATH' -v '$HOST_MSS_PATH':'$CONT_MSS_PATH' --name mss-dev dsblox/mss /bin/bash'
alias build-mss='cd-mss;docker build -t dsblox/mss .;docker push dbslox/mss'
alias ssh-mss='ssh ec2-user@secure.blockshots.com'
# alias provision-mss="aws ec2 run-instances --image-id ami-82e98f95 --security-group-ids sg-1a40e460 --user-data '#!/bin/bash /home/ec2-user/.dab-provision/bootstrap.sh mss' --key-name dblock-master --instance-type t2.nano --subnet subnet-5916d872"
alias provision-mss="aws ec2 run-instances --image-id ami-78f2946f --security-group-ids sg-1a40e460 --user-data mss --key-name dblock-master --instance-type t2.nano --subnet subnet-5916d872"

# pim environment - some of these exported paths are used by docker-compose
export CONT_PIM_PATH=/go/src/github.com/dsblox/pim
export HOST_PIM_PATH=$DAB_SRCPATH/go/src/github.com/dsblox/pim
alias cd-pim='cd '$HOST_PIM_PATH
alias init-pim='docker pull dsblox/pim'
alias build-pim='cd-pim;docker build -t dsblox/pim .;docker push dsblox/pim'
# PIM's DB dependency is "hidden" in docker-compose so DB auto-started
alias dev-pim='cd-pim;docker-compose run --rm app'
alias dev-psql='cd-pim;docker-compose run --rm psql'
# useful to stop db when not using, or completely reset the db (losing all data!)
alias dev-pimdb-stop='docker-compose stop db'
alias dev-pimdb-reset='docker-compose stop db;docker-compose rm db'

# work in progress - easy way to create AWS instances using docker-machine
# note that this command can take 30-90 seconds to complete
# in progress because i don't love that the subnet and vpc ids are hard-coded
# and that the AWS credentials must be set up somewhere else in my environment
# which i'm not even sure where that is right now (probably in CLI env)
aws-create-instance() {
   docker-machine create --driver amazonec2 --amazonec2-subnet-id subnet-5916d872 --amazonec2-vpc-id vpc-dc294fb9 $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
}


