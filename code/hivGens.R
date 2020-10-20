library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("makestuff/makeRfuns.R")
commandEnvironments()
makeGraphics(width=8, height=3)

legend_order <- c("base", "slow", "fast")
months = 120

base = HIVgen(earlyProp = earlyBase, window=months)
fast = HIVgen(earlyProp = earlyFast, window=months)
slow = HIVgen(earlyProp = earlySlow, window=months)

g <- (
	list(
		base = base
		, fast = fast
		, slow = slow
	)
	%>% bind_rows(.id = "type")
	%>% mutate(type = factor(type, levels=legend_order))
)

g <- (
	list(
		base = base
		, fast = fast
		, slow = slow
	)
	%>% bind_rows(.id = "type")
	%>% mutate(type = factor(type, levels=legend_order))
)

b <- (
	list(
		base = b0fun(base, rfitmonth)
		, fast = b0fun(fast, rfitmonth)
		, slow = b0fun(slow, rfitmonth)
	)
	%>% bind_rows(.id = "type")
	%>% mutate(type = factor(type, levels=legend_order))
)

gplot <- (ggplot(g)
	+ geom_line(aes(time*month/year, density*year/month, color=type))
	+ scale_x_continuous("Generation time (years)")
	+ scale_y_continuous("Density (per year)", expand=c(0, 0))
	+ ggtitle("Intrinsic generation interval")
	+ theme(
		legend.position=c(0.9, 0.9),
		legend.title=element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)
)

bplot <- (ggplot(b)
	+ geom_line(aes(time*month/year, density*year/month, color=type))
	+ scale_x_continuous("Generation time (years)")
	+ scale_y_continuous("Density (per year)", expand=c(0, 0))
	+ ggtitle("Backward generation interval")
	+ theme(
		legend.position=c(0.9, 0.9),
		legend.title=element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)
)

grid.arrange(gplot, bplot, nrow=1)
