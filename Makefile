# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

IP=$(shell ifconfig en0 | grep inet\  | cut -d " " -f2)
PWD=$(shell pwd)

.PHONY: all clean license docker-run docker-build

all:

LICENSE.md: python/reuse2txt.py
	poetry run reuse spdx | python python/reuse2txt.py > ./LICENSE.md

license: LICENSE.md

docker-build:
	docker build -f ./.docker/Dockerfile-gui -t netlogo .

# Assumes you have already built a docker image
docker-run:
	docker run --rm  -e DISPLAY=$(IP):0 \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  --net host -t netlogo

docker-shell:
	docker image inspect  netlogo > /dev/null 2>&1 && \
	docker run --rm -i \
	  -e DISPLAY=$(IP):0 \
	  -v ${HOME}/.Xauthority:/home/model/.Xauthority \
	  -v $(PWD):/home/model/local \
	  -v /tmp/.X11-unix:/tmp/.X11-unix \
	  -w /home/model \
	  --net host -t netlogo /bin/bash

readthedocs:
	curl -X POST -H "Authorization: Token $(RTD_TOKEN)" https://readthedocs.org/api/v3/projects/viable-north-sea/versions/latest/builds/

clean:
	@rm -f LICENSE.md
