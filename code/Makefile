## This is the speedstrength code subdirectory (Public)

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

## Crib code deleted 2021 Feb 06 (Sat)

Sources += $(wildcard *.R)
autopipeR = defined

######################################################################

## Paper figures

## Make and glance at figures from first revision
Ignore += newfigs.pdf
newfigs.pdf: gencontrol.Rout.pdf HIVexample.Rout.pdf condom.Rout.pdf tt.Rout.pdf
	$(pdfcat)

export: gencontrol.Rout.pdf.tod HIVexample.Rout.pdf.tod condom.Rout.pdf.tod tt.Rout.pdf.tod coronaPlot.ggp.pdf.tod

## Make the two different GIs from the kernel (a "legacy", see below)
gencontrol.Rout: gencontrol.R kernel.rda

## Post-paper, a reformatted figure
gencolumn.Rout: gencolumn.R gencontrol.rda

######## HIV

## Fit to the data for use downstream
Sources += WHO_data.csv
HIVfit.Rout: HIVfit.R WHO_data.csv units.rda

HIVexample.Rout: HIVexample.R HIVfit.rda HIVfuns.rda kernel.rda units.rda

condom.Rout: condom.R HIVfuns.rda HIVfit.rda kernel.rda units.rda

tt.Rout: tt.R HIVfuns.rda HIVfit.rda kernel.rda units.rda

hivGens.Rout: hivGens.R HIVfuns.rda kernel.rda HIVfit.rda units.rda 

######## coronavirus

## Attempt to be more general about kernels (not active)
coronafuns.rda: coronafuns.R

## SWP code
## This is superseded now by the refactored code below
## coronaexample.ggp.pdf: coronaexample.R
Ignore += coronaexample.pdf
coronaexample.Rout: coronaexample.R coronafuns.rda
coronaexample.pdf: coronaexample.Rout ;

## Refactored code
## coronaPlot.ggp.pdf: coronaPlot.R
coronaCalc.Rout: coronaCalc.R
coronaPlot.Rout: coronaPlot.R coronaCalc.rda

## Deleting coronaphase (I think Daniel just moved things back to coronaexample)
## 2021 Feb 06 (Sat)

######################################################################

## R scripts that don't use makeR yet (let alone pipeR ☺)
legacy = coronafuns kernel data HIVfuns
legacytargets = $(legacy:%=%.Rout)
$(legacytargets): %.Rout: %.R
	$(wrapR)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
Makefile: makestuff/Makefile
makestuff/Makefile:
	ln -s ../makestuff .
	ls $@

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/pdfpages.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
