# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

VERSION=1.3.0
DATE=$(shell  date +%Y-%m-%d)
IP=$(shell ifconfig en0 | grep inet\  | cut -d " " -f2)
PWD=$(shell pwd)

.PHONY: default clean license docker-run docker-build

default:
	@echo Valid Makefile targets are 'clean', 'license', 'readthedocs' and 'version'

LICENSE.md: python/reuse2txt.py
	poetry run reuse spdx | python python/reuse2txt.py > ./LICENSE.md

license: LICENSE.md

readthedocs:
	curl -X POST -H "Authorization: Token $(RTD_TOKEN)" https://readthedocs.org/api/v3/projects/viable-north-sea/versions/latest/builds/

# This target updates all files that control the versioning
# of the software package
version:
	sed -i 's/^version = .*/version = "'$(VERSION)'"/g' pyproject.toml
	sed -i 's/^version: .*"/version: "'$(VERSION)'"/g' CITATION.cff
	sed -i 's/^date-released: .*"/date-released: "'$(DATE)'"/g' CITATION.cff
	sed -i 's/^  "version":.*/  "version": "'$(VERSION)'",'/g codemeta.json
	sed -i 's/^  "dateModified":.*/  "dateModified": "'$(DATE)'",'/g codemeta.json

clean:
	@rm -f LICENSE.md
