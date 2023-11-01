#!/bin/bash

docker stop external-monitor-linker
docker rm external-monitor-linker

image=`docker images | grep external-monitor-linker | cut -c 67-79`
docker rmi $image

docker build -t external-monitor-linker .
docker run -p 7998:7998 --net=ibsen-network --restart unless-stopped --name external-monitor-linker -d -it external-monitor-linker /bin/bash