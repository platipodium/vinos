# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

.PHONY: all clean license docker-run docker-build

all:

LICENSE.md:
	poetry run reuse spdx > LICENSE.md

license: LICENSE.md

docker-build:
	docker build -f ./.docker/Dockerfile-gui -t NetLogo .

# Assumes you have already built a docker image
docker-run:
	docker run --rm  -e DISPLAY=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'):0 -v ${HOME}/.Xauthority:/home/model/.Xauthority -t NetLogo

clean:
	@rm -f LICENSE.md
