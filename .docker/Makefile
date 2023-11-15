# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

VERSION=1.2.4
DATE=$(shell  date +%Y-%m-%d)
IP=$(shell ifconfig en0 | grep inet\  | cut -d " " -f2)
PWD=$(shell pwd)
# For uploading to docker hub, you may have to adjust the
# following namespace
DOCKERHUB_NAMESPACE=platipodium

.PHONY: default jdk netlogo vinos run shell

default:
	@echo Valid Makefile targets are  jdk, netlogo, vinos, run, and shell

jdk:
	docker build -f ./Dockerfile-jdk -t $(DOCKERHUB_NAMESPACE)/jdk ..

netlogo: jdk
	@for V in "6.2.2" "6.3.0" "6.4.0-beta1" ; do \
	  docker build -f ./Dockerfile-netlogo -t $(DOCKERHUB_NAMESPACE)/netlogo:$$V \
	  --build-arg NETLOGO_VERSION=$$V .. ;\
	done

vinos: netlogo
	@for V in "6.2.2" "6.3.0" "6.4.0-beta1" ; do \
	  docker build -f ./Dockerfile-vinos -t $(DOCKERHUB_NAMESPACE)/vinos:$$V \
	  --build-arg NETLOGO_VERSION=$$V .. ;\
	done

# Assumes you have already built a docker image
run:
	docker run --rm  -e DISPLAY=$(IP):0 \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  --net host -t $(DOCKERHUB_NAMESPACE)/vinos:6.3.0

shell:
	docker image inspect $(DOCKERHUB_NAMESPACE)/vinos:6.3.0 > /dev/null 2>&1 && \
	docker run --rm -i \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v $(PWD):/home/model/local \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  -w /home/model \
	  --net host -t $(DOCKERHUB_NAMESPACE)/vinos:6.3.0 /bin/bash
