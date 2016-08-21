#!/bin/bash
if [ -z "$DAB_SRCPATH" ]; then
  echo "DAB_SRCPATH must be set to use this script to set the rest of env"
  exit 
fi

# add my ssh keys to the session (avoiding config to more easily share across machines)
chmod 600 $DAB_SRCPATH/security/keys/personal/id_rsa
ssh-add $DAB_SRCPATH/security/keys/personal/id_rsa

# general stuff useful to me
alias cd-src='cd '$DAB_SRCPATH
alias cd-env='cd-src;cd environment'
alias dangling='docker rmi $(docker images -f "dangling=true" -q)'

# message-secure-send environment
CONT_MSS_PATH=/go/src/github.com/dsblox/mss
HOST_MSS_PATH=$DAB_SRCPATH/go/src/github.com/dsblox/mss
alias cd-mss='cd '$HOST_MSS_PATH
alias init-mss='docker pull dsblox/mss'
alias dev-mss='docker run --rm -it -p 4000:4000 -w '$CONT_MSS_PATH' -v '$HOST_MSS_PATH':'$CONT_MSS_PATH' --name mss-dev dsblox/mss /bin/bash'
alias build-mss='cd-mss;docker build -t dsblox/mss .;docker push dbslox/mss'
alias ssh-mss='ssh ec2-user@secure.blockshots.com'

# pim environment
CONT_PIM_PATH=/go/src/github.com/dsblox/pim
HOST_PIM_PATH=$DAB_SRCPATH/go/src/github.com/dsblox/pim
alias cd-pim='cd '$HOST_PIM_PATH
alias init-pim='docker pull dsblox/pim'
alias dev-pim='docker run --rm -it -w '$CONT_PIM_PATH' -v '$HOST_PIM_PATH':'$CONT_PIM_PATH' --link db --name pim-dev dsblox/pim /bin/bash'
alias build-pim='cd-pim;docker build -t dsblox/pim .;docker push dsblox/pim'
# TBD: docker swarm so these next two are linked in some way???
# TBD: better alias or script that makes sure db is running when bringing up dev-pim???
alias dev-pg-clean='docker run --name db -e POSTGRES_PASSWORD=postgres -d postgres'
alias dev-pg-start='docker start db'
alias dev-pg-stop='docker stop db'
alias dev-psql='docker run --rm -it --name psql --link db:postgres -e PGPASSWORD=postgres postgres psql -h postgres -U postgres'


