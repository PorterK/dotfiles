#!bash

alias docko=docker-compose
alias docko-run='docko run --rm server'
alias docko-debug='docko-run --rm --service-ports server'

function ___docko-psql {
  docko exec db psql postgres -U postgres
}

alias docko-psql='___docko-psql'

function ___docko-restart-tail {
  docko restart && docko logs -f --tail=100
}

alias docko-restart-tail='___docko-restart-tail'

alias docker-clean='docker rm -v $(docker ps -a -q -f status=exited) && docker volume rm $(docker volume ls -qf dangling=true)'

alias docker-destroy='\
  sudo docker kill $(docker ps -q); \
  sudo docker rm $(docker ps -a -q); \
  sudo docker rmi $(docker images -q -f dangling=true); \
  sudo docker rmi $(docker images -q -f) -f; \
  sudo docker volume rm $(docker volume ls -q)'

alias ddv='docko down --volumes'
