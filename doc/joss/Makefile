# SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

MEXT = md
SRC=paper.$(MEXT)

PDF=$(SRC:.md=.pdf)
XREF=$(SRC:.md=.crossref)
HTML=$(SRC:.md=.html)

all: pdf cff
cff pdf: $(PDF)

%.pdf:	%.md %.bib Makefile
	docker run -it -v $(PWD):/data \
    -u $(id -u):$(id -g) \
    openjournals/inara \
    -o pdf,cff $(SRC)

clean:
	@rm -f $(PDF) $(XREF) $(HTML) CITATION.cff paper.preprint.*
