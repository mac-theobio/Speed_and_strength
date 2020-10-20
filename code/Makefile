
## This is the speedstrength code subdirectory

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

%.csv: ../speedstrength/dotdir/code/%.csv
	$(MV) $< $@

%.R: ../speedstrength/dotdir/code/%.R
	$(MV) $< $@

Sources += $(wildcard *.R)
automatic_makeR = defined

######################################################################

## Paper figures

## Make and glance at all current figures
Ignore += newfigs.pdf
newfigs.pdf: gencontrol.Rout.pdf HIVexample.Rout.pdf condom.Rout.pdf tt.Rout.pdf
	$(pdfcat)

export: gencontrol.Rout.pdf.tod HIVexample.Rout.pdf.tod condom.Rout.pdf.tod tt.Rout.pdf.tod

## Make the two different GIs from the kernel
gencontrol.Rout: gencontrol.R kernel.R

######## HIV

## Fit to the data for use downstream
Sources += WHO_data.csv
HIVfit.Rout: HIVfit.R WHO_data.csv units.rda

HIVexample.Rout: HIVexample.R HIVfit.rda HIVfuns.rda kernel.rda units.rda

condom.Rout: condom.R HIVfuns.rda HIVfit.rda kernel.rda units.rda

tt.Rout: tt.R HIVfuns.rda HIVfit.rda kernel.rda units.rda

hivGens.Rout: hivGens.R HIVfuns.rda kernel.rda HIVfit.rda units.rda 

######## coronavirus

coronaexample.Rout: coronaexample.R coronafuns.rda kernel.rda units.rda

######################################################################

## R scripts that don't use makeR yet.
legacy = coronafuns kernel data HIVfuns
legacytargets = $(legacy:%=%.Rout)
$(legacytargets): %.Rout: %.R
	$(run-R)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
Makefile: makestuff/Makefile
makestuff/Makefile:
	ln -s ../makestuff .
	ls $@

-include makestuff/os.mk

-include makestuff/makeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
