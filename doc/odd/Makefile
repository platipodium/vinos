# SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH (hereon)#
# SPDX-License-Identifier: CC0-1.0
# SPDX-FieContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
PANDOC=pandoc

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

# Markdown source format with extensions

MDFORMAT=--from=markdown+pipe_tables+simple_tables+multiline_tables+fenced_code_blocks+table_captions+yaml_metadata_block+definition_lists+superscript+subscript+tex_math_dollars+inline_notes+smart

BIBCMD=--citeproc #--biblatex --bibliography $(BIB)
#BIBCMD=

TOCCMD=--toc
TOCCMD=

LTX=
CMD=$(PANDOC) $(MDFORMAT) $(BIBCMD) $(TOCCMD)

## All markdown files in the working directory
#SRC = $(wildcard *.$(MEXT))
SRC = paper.$(MEXT)

## Location of Pandoc support files.
PREFIX = $(HOME)/.pandoc

PDF=$(SRC:.md=.pdf)
PPTX=$(SRC:.md=.pptx)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)
DOCX=$(SRC:.md=.docx)
ODT=$(SRC:.md=.odt)
EPUB=$(SRC:.md=.epub)
TXT=$(SRC:.md=.txt)
BIB=$(SRC:.md=.bib)

all:  txt odt pdf
pdf:	$(PDF) $(SRC) Makefile
html:	$(HTML) $(SRC) Makefile
docx: $(DOCX) $(SRC) Makefile
odt:  $(ODT) $(SRC) Makefile
epub: $(EPUB) $(SRC) Makefile
tex:  $(TEX) $(SRC) Makefile
txt:  $(TXT) $(SRC) Makefile

%.txt:	%.md %.bib Makefile
	$(CMD) --to=plain -o $@ $<

%.html:	%.md Makefile
	$(CMD) --to=html -o $@ $<

%.epub:	%.md  %.bib Makefile
	$(CMD) --to=epub -s -o $@ $<  # --epub-cover-image=cover-image.gif

%.tex:	%.md  %.bib Makefile
	$(CMD) -s  --template=./comses-template.tex  -o $@ $<

%.pdf:	%.md  %.bib Makefile
	$(CMD) -s  --template=./comses-template.tex  -o $@ $<

# %.pdf:	%.md Makefile ../templates/comses-template.tex  tex
#	$(CMD) -s  --template=../templates/comses-template.tex  -o $@ $<
#	latexmk -pvc -pdf -e '$$pdflatex=q/xelatex %O -interaction=nonstopmode %S/' -f paper
#	pdflatex paper

%.docx:	%.md  %.bib Makefile
	$(CMD)--to=docx -s -o $@ $<
# --reference-doc= --filter pandoc-citeproc --bibliography

%.odt:	%.md  %.bib Makefile
	$(CMD) --to=odt -s  -o $@ $<
# --reference-doc= --filter pandoc-citeproc --bibliography

clean:
	@rm -f $(PDF) $(SRC:.md=.html) $(SRC:.md=.odt) $(SRC:.md=.docx)
	@rm -f $(PDF:.pdf=.nav) $(PDF:.pdf=.out) $(PDF:.pdf=.tex) $(PDF:.pdf=.snm) $(PDF:.pdf=.toc)
	@rm -f $(PDF:.pdf=.log) $(PDF:.pdf=.synctex.gz) $(PDF:.pdf=.blg)  $(PDF:.pdf=.bbl)
	@rm -f missfont.log $(SRC:.md=.run.xml)
	@rm -f $(EPUB) $(TXT)
	@rm -f allbib.html
	


bib: 
	pandoc allbib.tex -o allbib.html --citeproc --bibliography paper.bib
	pandoc allbib.tex -o allbib.pdf --citeproc --bibliography paper.bib 