# Public speed and strength repo
## Target
current: target
-include target.mk

######################################################################

alldirs += code
Ignore += $(alldirs)

-include makestuff/perl.def

######################################################################

## Crib

%.bib: speedstrength/dotdir/%.bib
	$(MV) $< $@

%.tex: speedstrength/dotdir/%.tex
	$(MV) $< $@

%.pl: speedstrength/dotdir/%.pl
	$(MV) $< $@

######################################################################

products: speedstrength.pdf supp.pdf head.txt

Sources += $(wildcard *.tex *.bib)

## speedstrength.pdf: speedstrength.tex
## supp.pdf: supp.tex

######################################################################

## Clean up heading text for submission

Sources += abstract.pl
Ignore += head.txt
head.txt: speedstrength.tex abstract.pl
	$(PUSH)

######################################################################

## Automake

colddirs += code

######################################################################

### Makestuff

## Makestuff setup
Sources += Makefile README.md
msrepo = https://github.com/dushoff
ms = makestuff

Ignore += makestuff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/texdeps.mk
-include makestuff/utils.mk
-include makestuff/pandoc.mk
-include makestuff/hotcold.mk

-include makestuff/git.mk
-include makestuff/visual.mk
