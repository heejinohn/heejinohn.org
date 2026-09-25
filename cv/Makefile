### Build the public CV into the website's static folder.
### Sources live in ../edit/: cv.md (the CV) and papers.yaml (its paper sections).

SRC = ../edit
OUT = ../static/cv.pdf
COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo draft)
PANDOC = pandoc $(SRC)/cv.md --template=svm-latex-cv.tex \
  --lua-filter=papers.lua -M papers=$(SRC)/papers.yaml

all: $(OUT)

# Paper sections are filled in from papers.yaml by the papers.lua filter.
$(OUT): $(SRC)/cv.md $(SRC)/papers.yaml papers.lua svm-latex-cv.tex
	$(PANDOC) --pdf-engine=pdflatex -M commit=$(COMMIT) -o $(OUT)

# The LaTeX pandoc produces, for checking the generated paper entries.
cv.tex: $(SRC)/cv.md $(SRC)/papers.yaml papers.lua svm-latex-cv.tex
	$(PANDOC) -o $@

clean:
	rm -f $(OUT) cv.tex

.PHONY: all clean
