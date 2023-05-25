# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-FileContributor: Carsten Lemmen
# SPDX-License-Identifier: CC0-1.0

DIRS=assets data .reuse LICENSES

.PHONY: clean zip all

all: zip

zip:
	@rsync -r ../../netlogo/{ReadMe.md,*nlogo,include,behavior} code/
	@for D in $(DIRS); do rsync -r --exclude="ble/Monatsbericht*" --exclude="ble/national_landings_*.csv" ../../$$D . ; done
	@rsync -r ../odd/paper.{md,bib} doc/
	@zip -r comses $(DIRS) code
clean:
	rm -rf $(DIRS) code comses.zip
