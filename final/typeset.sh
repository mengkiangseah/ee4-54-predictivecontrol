#!/bin/bash

alias ts='./typeset.sh'

pdflatex --file-line-error --synctex=1 --shell-escape "final.tex"

bibtex final

pdflatex --file-line-error --synctex=1 --shell-escape "final.tex"

pdflatex --file-line-error --synctex=1 --shell-escape "final.tex"

rm final.aux
rm final.log
rm final.bbl
rm final.blg
rm final.synctex.gz
