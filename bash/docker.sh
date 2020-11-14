dkrm() { docker rm $(docker ps -q -a); }

alias dr="docker run --rm -t -i "
alias dkrd="docker run -d -P"
alias dkri="docker run -t -i -P"
alias dkrt="docker run --rm -t -i -P"
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dclean="docker rm \$(docker ps -a | awk \'$2~/^[^/]+$/ {print $1}\' | tail -n+2)"
alias diclean="docker rmi \$(docker images | grep '^<none>\' | awk \'{ print $2}\')"
