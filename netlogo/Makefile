# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH (hereon)#
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

.PHONY: all clean profile

all:

profile: results/profiler_data.csv
	@cat results/profiler_data.csv | sed 's/,/ /g' | sort -r -n -k 4

results/profiler_data.csv:
	@echo "Please run 'profile' from within NetLogo"

clean:
	@rm -f results/*
