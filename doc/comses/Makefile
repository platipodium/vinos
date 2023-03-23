# SPDX-FileCopyright: Helmholtz-Zentrum hereon GmbH
# SPDX-FileContributor: Carsten Lemmen
# SPDX-License: CC0-1.0

.PHONY: clean zip all

all: zip

zip:
	rsync -r ../../netlogo/* code/ 
	rsync -r ../../data/* data/
	rsync -r ../odd/paper.{md,bib} docs/
	zip -r comses code data docs  
clean: 
	rm -rf code data docs comses.zip