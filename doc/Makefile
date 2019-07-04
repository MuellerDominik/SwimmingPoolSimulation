name = SwimmingPoolSimulation_Fankhauser_Canzani_Mueller

all:
	

build:
	pdflatex -interaction=batchmode $(name).tex
	biber --onlylog $(name)
	pdflatex -interaction=batchmode $(name).tex
	pdflatex -interaction=batchmode $(name).tex

clean:
	rm -f *.aux *.glo *.ist *.log *.out *.toc *.lof *.lot *.fls *.fmt *.fot *.cb *.cb2 .*.lb
	rm -f *.synctex *.synctex\(busy\) *.synctex.gz *.synctex.gz\(busy\) *.pdfsync
	rm -f *.bbl *.bcf *.blg *-blx.aux *-blx.bib *.run.xml
	rm -f ./literature/*.bib.bak ./literature/*.bib.sav ./literature/*.log
	rm -f ./sections/*.aux ./sections/*.log
	rm -f *.glg *.gls

purge: clean
	rm -f *.pdf
