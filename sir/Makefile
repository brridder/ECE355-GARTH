LATEX = pdflatex
BIBTEX = bibtex
ECHO = echo
FILES = sir.tex
BIBFILES = sir.aux
MPOST = mpost
FLOW = flow

all : 
	$(ECHO) Making sdd.pdf
	$(LATEX) $(FILES)
	$(ECHO) Making sdd.pdf again for references
	$(LATEX) $(FILES)
	wc $(FILES)
