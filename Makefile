### Local shortcuts. GitHub Actions does the same build on every push to main.
#   make          build the CV PDF and the site (into public/)
#   make preview  build the CV PDF, then preview at http://localhost:1313

all: cv
	hugo --gc --minify

cv:
	$(MAKE) -C cv

preview: cv
	hugo server

.PHONY: all cv preview
