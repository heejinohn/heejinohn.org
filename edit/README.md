# edit/: everything you update

Edit files here, push to `main`, and GitHub rebuilds the CV and the website.
(This README is not published.)

| File / folder | What it is | Where it shows up |
|---|---|---|
| `about.md` | Your bio | About page (all of it); home page (text above `<!--more-->`, plus `homeClosing`) |
| `papers.yaml` | Every paper, with abstracts | CV paper sections, home page list, Research page, one page per paper |
| `cv.md` | The rest of the CV | `heejinohn.org/cv.pdf` |
| `blog/` | Blog posts | Blog page; the menu item appears with the first published post |
| `files/` | PDFs, images, anything to link to | Site root: `files/papers/x.pdf` → `heejinohn.org/papers/x.pdf` |

## Common tasks

- **Add a paper / change order / paper accepted:** edit `papers.yaml`. Order is
  list order; to change status, move the entry to another list. Instructions
  are at the top of the file.
- **New blog post:** `hugo new content blog/my-title.md`, write, then set
  `draft: false`.
- **Preview locally:** `make preview` in the repository root, then open
  http://localhost:1313. Pages update as you save; so does the CV PDF
  (`/cv.pdf`, reload it after a few seconds). Stop with Ctrl-C.
