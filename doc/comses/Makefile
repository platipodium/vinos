# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-FileContributor: Carsten Lemmen
# SPDX-License-Identifier: CC0-1.0

.PHONY: clean zip all

all: zip

zip:
	rsync -r ../../netlogo/* code/ 
	rsync -r ../../data/* data/
	rsync -r ../odd/paper.{md,bib} docs/
	zip -r comses code data docs  
clean: 
	rm -rf code data docs comses.zip