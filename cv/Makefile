### Build the public CV into the website's static folder

OUT = ../static/cv.pdf
COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo draft)

all: $(OUT)

# Paper sections are filled in from papers.yaml by the papers.lua filter.
$(OUT): cv.md papers.yaml papers.lua svm-latex-cv.tex
	pandoc cv.md --template=svm-latex-cv.tex --pdf-engine=pdflatex \
	  --lua-filter=papers.lua -M commit=$(COMMIT) -o $(OUT)

# The LaTeX pandoc produces, for checking the generated paper entries.
cv.tex: cv.md papers.yaml papers.lua svm-latex-cv.tex
	pandoc cv.md --template=svm-latex-cv.tex --lua-filter=papers.lua -o $@

clean:
	rm -f $(OUT) cv.tex

.PHONY: all clean
