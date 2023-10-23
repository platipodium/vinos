# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

.PHONY: all clean profile cloc

all:

# Count lines of code
cloc.pl:
	curl -o cloc/cloc.pl https://raw.githubusercontent.com/AlDanial/cloc/master/cloc

cloc: cloc.pl vinos.nlogo include/*nls cloc/netlogo.def
	perl cloc/cloc.pl --force-lang-def=cloc/netlogo.def --force-lang=NETLOGO *nlogo include/*nls

profile: results/profiler_data.csv
	@echo "Top 10 time-intensive subroutines:"
	@cat results/profiler_data.csv | sed 's/,/ /g' | sort -r -n -k 4 | head -n 10

results/profiler_data.csv:
	@echo "Please run 'profile' from within NetLogo"

clean:
	@-rm -f *.json
	@-rm -f cloc/cloc.pl
	@-make -s -C results clean
