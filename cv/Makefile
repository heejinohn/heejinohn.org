### Build the public CV into the website's static folder.
### Sources live in ../edit/: cv.md (the CV) and papers.yaml (its paper sections).

SRC = ../edit
OUT = ../static/cv.pdf
COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo draft)
PANDOC = pandoc $(SRC)/cv.md --template=svm-latex-cv.tex \
  --lua-filter=papers.lua -M papers=$(SRC)/papers.yaml

all: $(OUT)

# The pandoc version this Mac builds with. GitHub Actions installs the version
# named here, so an upgraded local pandoc carries over once this file is
# committed. The file is rewritten only when the version changes, and then
# the PDF rebuilds, so an upgrade is tested locally first.
pandoc-version: FORCE
	@v=$$(pandoc --version | sed -n '1s/^pandoc //p'); \
	  [ "$$v" = "$$(cat $@ 2>/dev/null)" ] || { echo "$$v" > $@; echo "pandoc version recorded: $$v"; }

# Paper sections are filled in from papers.yaml by the papers.lua filter.
$(OUT): $(SRC)/cv.md $(SRC)/papers.yaml papers.lua svm-latex-cv.tex pandoc-version
	$(PANDOC) --pdf-engine=pdflatex -M commit=$(COMMIT) -o $(OUT)

# The LaTeX pandoc produces, for checking the generated paper entries.
cv.tex: $(SRC)/cv.md $(SRC)/papers.yaml papers.lua svm-latex-cv.tex
	$(PANDOC) -o $@

clean:
	rm -f $(OUT) cv.tex

FORCE:
.PHONY: all clean FORCE
