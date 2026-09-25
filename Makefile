### Local shortcuts. GitHub Actions does the same build on every push to main.
#   make          build the CV PDF and the site (into public/)
#   make preview  build the CV PDF, then preview at http://localhost:1313;
#                 while it runs, saving edit/cv.md or edit/papers.yaml
#                 rebuilds the PDF too (cv/watch.sh)

# Plain `make` runs `all` (otherwise make would pick the first target below).
.DEFAULT_GOAL := all

# Hugo is pinned in Homebrew; GitHub uses HUGO_VERSION in the workflow.
# Warn (without stopping) when the two differ.
HUGO_CI    := $(shell sed -n 's/^ *HUGO_VERSION: *\([0-9.]*\).*/\1/p' .github/workflows/hugo.yml)
HUGO_LOCAL := $(shell hugo version 2>/dev/null | sed -n 's/^hugo v\([0-9.]*\).*/\1/p')

check-hugo:
	@[ "$(HUGO_LOCAL)" = "$(HUGO_CI)" ] || echo "Note: local Hugo $(HUGO_LOCAL) differs from GitHub's $(HUGO_CI) (HUGO_VERSION in .github/workflows/hugo.yml)."

all: cv check-hugo
	hugo --gc --minify

cv:
	$(MAKE) -C cv

# One shell line: start the watcher in the background, make sure it is
# stopped when this shell exits (Ctrl-C included), then run the server.
preview: cv check-hugo
	@cv/watch.sh & trap 'kill $$! 2>/dev/null' EXIT INT TERM; hugo server

.PHONY: all cv preview check-hugo
