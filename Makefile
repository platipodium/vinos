# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

IP=$(shell ifconfig en0 | grep inet\  | cut -d " " -f2)

.PHONY: all clean license docker-run docker-build

all:

LICENSE.md:
	poetry run reuse spdx > LICENSE.md

license: LICENSE.md

docker-build:
	docker build -f ./.docker/Dockerfile-gui -t netlogo .

# Assumes you have already built a docker image
docker-run:
	docker run --rm  -e DISPLAY=$(IP):0 -v ${HOME}/.Xauthority:/home/model/.Xauthority -t netlogo

clean:
	@rm -f LICENSE.md
