### Build the public CV into the website's static folder

OUT = ../static/cv.pdf
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo draft)

all: $(OUT)

$(OUT): cv.md svm-latex-cv.tex
	pandoc cv.md --template=svm-latex-cv.tex --pdf-engine=pdflatex \
	  -M commit=$(COMMIT) -o $(OUT)

clean:
	rm -f $(OUT)

.PHONY: all clean
