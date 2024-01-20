# SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

VERSION=1.2.4
DATE=$(shell  date +%Y-%m-%d)
IP=$(shell ifconfig en0 | grep inet\  | cut -d " " -f2)
PWD=$(shell pwd)
# For uploading to docker hub, you may have to adjust the
# following namespace

.PHONY: default jdk netlogo vinos run shell

default:
	@echo Valid Makefile targets are  jdk, netlogo, vinos, run, and shell

jdk:
	@docker image inspect platipodium/jdk  > /dev/null 2>&1 || \
	  docker build -f ./Dockerfile-jdk -t platipodium/jdk ..

netlogo: jdk
#	@for V in "6.2.2" "6.3.0" "6.4.0-beta1" ; do
	@for V in "6.2.2" "6.3.0"  ; do \
	  docker image inspect platipodium/netlogo:$$V  > /dev/null 2>&1 || \
	    docker build -f ./Dockerfile-netlogo -t platipodium/netlogo:$$V \
	    --build-arg NETLOGO_VERSION=$$V .. ;\
	done

vinos: netlogo
#	@for V in "6.2.2" "6.3.0" "6.4.0-beta1" ; do
	@for V in "6.2.2" "6.3.0" ; do  \
	  docker image inspect platipodium/vinos:$$V  > /dev/null 2>&1 ||  \
		docker build -f ./Dockerfile-vinos -t platipodium/vinos:$$V  \
		--build-arg NETLOGO_VERSION=$$V .. ;\
	done
#	  docker image inspect platipodium/vinos:$$V  > /dev/null 2>&1 || \
#		#docker build -f ./Dockerfile-vinos -t platipodium/vinos:$$V \
#	    #--build-arg NETLOGO_VERSION=$$V .. ;\
#	echo hallo ; \

# Assumes you have already built a docker image
run:
	docker run --rm  -e DISPLAY=$(IP):0 \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  --net host -t platipodium/vinos:6.3.0

shell:
	docker image inspect platipodium/vinos:6.3.0 > /dev/null 2>&1 && \
	docker run --rm -i \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v $(PWD):/home/model/local \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  -w /home/model \
	  --net host -t platipodium/vinos:6.3.0 /bin/bash
