### Local shortcuts. GitHub Actions does the same build on every push to main.
#   make          build the CV PDF and the site (into public/)
#   make preview  build the CV PDF, then preview at http://localhost:1313;
#                 while it runs, saving edit/cv.md or edit/papers.yaml
#                 rebuilds the PDF too (cv/watch.sh)

all: cv
	hugo --gc --minify

cv:
	$(MAKE) -C cv

# One shell line: start the watcher in the background, make sure it is
# stopped when this shell exits (Ctrl-C included), then run the server.
preview: cv
	@cv/watch.sh & trap 'kill $$! 2>/dev/null' EXIT INT TERM; hugo server

.PHONY: all cv preview
