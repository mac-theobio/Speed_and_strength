library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("makestuff/makeRfuns.R")
commandEnvironments()
makeGraphics(width=8, height=3)

h_base <- HIVgen(earlyProp = earlyBase, step=0.1)

g1 <- ggplot(h_base) +
	geom_line(aes(time*month/year, density*year/month)) +
	scale_x_continuous("Generation time (years)") +
	scale_y_continuous("Density (per year)", expand=c(0, 0)) +
	ggtitle("A") +
	theme(
		legend.position=c(0.9, 0.9),
		legend.title=element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

## Prevalence time plot
g2 <- ggplot(hiv_ts) +
	geom_point(aes(year, prevalence)) +
	stat_function(fun=function(x) exp(p0 + rfityear*x)) +
	scale_x_continuous("Year") +
	scale_y_continuous("HIV prevalence", limits=c(0, 0.328), expand=c(0, 0)) +
	ggtitle("B") +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

r2R(h_base, rfitmonth)

early <- seq(from=0.1, to=0.4, by=0.01)

R0 <-  sapply(early, function(x) {
	hh <- HIVgen(earlyProp = x, step=0.1)
	r2R(hh, rfitmonth)
})

earlydata <- data.frame(
	early=early,
	R0=R0
)

## R vs. early transmission
g3 <- ggplot(earlydata) +
	geom_line(aes(early, R0)) +
	geom_point(aes(earlyBase, 3.17), size=5) +
	geom_segment(aes(x=earlyBase, y=0, xend=earlyBase, yend=3.17), lty=2) +
	geom_segment(aes(x=0, y=3.17, xend=earlyBase, yend=3.17), lty=2) +
	scale_x_continuous("Proportion of early transmission", expand=c(0, 0)) +
	scale_y_continuous("Reproduction number", limits=c(0, 5), expand=c(0, 0)) +
	ggtitle("C") +
	theme(
		legend.position="none",
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

grid.arrange(g1, g2, g3, nrow=1)
