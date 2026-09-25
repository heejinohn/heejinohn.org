#!/bin/sh
# Rebuild the CV PDF whenever one of its sources changes.
# Started by `make preview` alongside `hugo server`; stops when the preview stops.

cd "$(dirname "$0")" || exit 1
SOURCES="../edit/cv.md ../edit/papers.yaml papers.lua svm-latex-cv.tex"

# Modification times of all sources, as one string (macOS stat, then Linux stat).
stamp() { stat -f %m $SOURCES 2>/dev/null || stat -c %Y $SOURCES 2>/dev/null; }

last=$(stamp)
echo "Watching edit/cv.md and edit/papers.yaml; the CV PDF rebuilds on save."
while sleep 1; do
  now=$(stamp) || continue
  [ "$now" = "$last" ] && continue
  last=$now
  # -B: rebuild even if file times look current (edits within the same second)
  if make -s -B >/dev/null 2>&1; then
    echo "CV rebuilt: static/cv.pdf ($(date +%H:%M:%S))"
  else
    echo "CV build failed. Run 'make -C cv' to see the error."
  fi
done
