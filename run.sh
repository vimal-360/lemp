# rmeove all docker container
docker rm -f $(docker ps -a -q)
# remove all docker images
docker rmi -f $(docker images -q)
#
docker compose up -d