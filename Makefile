# Public speed and strength repo
## Target
current: target
-include target.mk

######################################################################

alldirs += code
Ignore += $(alldirs)

## -include makestuff/perl.def

####################################################################

products: speedstrength.pdf supp.pdf head.txt

Sources += $(wildcard *.tex *.bib)

## speedstrength.pdf: speedstrength.tex
## supp.pdf: supp.tex

## Hacked for now; build rule later
## prsb.pdf: prsb.tex

Ignore += DushoffPark_Supp_compartmental_text.pdf
DushoffPark_Supp_compartmental_text.pdf: supp.pdf
	pdfjam -o $@ $< 1-2

DushoffPark_Supp_HIVintervals_fig.pdf: supp.pdf
	pdfjam -o $@ $< 3

######################################################################

## Clean up heading text for submission

Sources += abstract.pl
Ignore += head.txt
head.txt: speedstrength.tex abstract.pl
	$(PUSH)

######################################################################

## October revision
october: speedstrength.tex.1d9ad422e25.oldfile supp.tex.1d9ad422e25.oldfile
dushoff: speedstrength.tex.cb8e114.oldfile

testsetup: 
	cd code && $(MAKE) Makefile
speedstrength_olddiff.pdf: speedstrength.tex
oldreset:
	git rm *_olddiff.tex

######################################################################

## Automake
hotdirs += code

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

-include makestuff/texi.mk
-include makestuff/utils.mk
-include makestuff/pandoc.mk
-include makestuff/hotcold.mk

-include makestuff/git.mk
-include makestuff/visual.mk
