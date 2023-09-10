# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>

PANDOC=pandoc

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

METADEPS = Makefile beamerthemehereon.sty beamerthemelankton-keynote.sty
# Markdown source format with extensions

MDFORMAT=--from=markdown+pipe_tables+simple_tables+multiline_tables+fenced_code_blocks+table_captions+yaml_metadata_block+definition_lists+superscript+subscript+tex_math_dollars+inline_notes+smart

#BIBCMD=--filter pandoc-citeproc --biblatex --bibliography $(BIB)
BIBCMD=

TOCCMD=--toc
TOCCMD=

CMD=$(PANDOC) $(MDFORMAT) $(BIBCMD) $(TOCCMD)

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Location of Pandoc support files.
PREFIX = $(HOME)/.pandoc

PDF=$(SRC:.md=.pdf) $(SRC:.md=-slides.pdf)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)
DOCX=$(SRC:.md=.docx)
ODT=$(SRC:.md=.odt)
EPUB=$(SRC:.md=.epub)
TXT=$(SRC:.md=.txt)
BIB=$(SRC:.md=.bib)

all:  $(SRC:.md=-slides.pdf) #txt odt pdf
pdf:	$(PDF) $(SRC) $(METADEPS)
html:	$(HTML) $(SRC) $(METADEPS)
docx: $(DOCX) $(SRC) $(METADEPS)
odt:  $(ODT) $(SRC) $(METADEPS)
epub: $(EPUB) $(SRC) $(METADEPS)
tex:  $(TEX) $(SRC) $(METADEPS)
txt:  $(TXT) $(SRC) $(METADEPS)

%.txt:	%.md Makefile
	$(CMD) --to=plain -o $@ $<

%.html:	%.md Makefile
	$(CMD) --to=html --template=html.template --css=$(PREFIX)/marked/kultiad-serif.css -o $@ $<

%-slides.pdf:	%.md  Makefile
	$(CMD) --to=beamer --template=./pandoc_beamer_hereon_template.tex -i -s --pdf-engine=pdflatex  --slide-level=2  -o $@ $<
#	$(CMD) --to=beamer  -i -s --pdf-engine=pdflatex  --slide-level=2  -o $@ $<

#	$(PANDOC) --to=latex --no-tex-ligatures#--template=./default-de-1.12.latex

%.epub:	%.md Makefile
	$(CMD) --to=epub -s -o $@ $<  # --epub-cover-image=cover-image.gif

%.tex:	%.md Makefile
	$(CMD) --to=latex -i -s --pdf-engine=pdflatex   -o $@ $<

%.pdf:	%.md Makefile
	$(CMD) -s  --pdf-engine=pdflatex -o $@ $<

%.docx:	%.md Makefile
	$(CMD)--to=docx -s -o $@ $<
# --reference-docx= --filter pandoc-citeproc --bibliography

%.odt:	%.md Makefile
	$(CMD) --to=odt -s  -o $@ $<
# --reference-odt= --filter pandoc-citeproc --bibliography

clean:
	@rm -f $(PDF) $(SRC:.md=.html) $(SRC:.md=.odt) $(SRC:.md=.docx)
	@rm -f $(PDF:.pdf=.nav) $(PDF:.pdf=.out) $(PDF:.pdf=.tex) $(PDF:.pdf=.snm) $(PDF:.pdf=.toc)
	@rm -f $(PDF:.pdf=.log) $(PDF:.pdf=.synctexLemmen2019_armodata.bib .gz) $(PDF:.pdf=.blg)  $(PDF:.pdf=.bbl)
	@rm -f missfont.log $(SRC:.md=.run.xml)
	@rm -f $(EPUB) $(TXT)
