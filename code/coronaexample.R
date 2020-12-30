library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("makestuff/makeRfuns.R")
commandEnvironments()
## makeGraphics(width=8, height=3)
makeGraphics()

## Generation intervals
g_pre <- gen(sat=0*day)
g_post <- gen(sat=10*day)

print(intervalMoments(g_pre))
print(intervalMoments(g_post))

print(
	ggplot(g_pre) +
	geom_line(aes(time/day, density*day)) +
	scale_x_continuous("Generation time (days)") +
	scale_y_continuous("Density (per day)", expand=c(0, 0)) +
	theme(
		legend.position=c(0.9, 0.9),
		legend.title=element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	) +
	geom_line(aes(time/day, density*day), data=g_post) +
	NULL
)

## Interventions

base <- 0.1/day

flat <- controlFun(base/2)
trace <- controlFun(base, decay=1/4/day)
respond <- controlFun(base, sat=4*day)

print(ggplot()
	+ scale_x_continuous("Time since infection (days)")
	+ scale_y_continuous("Control hazard (per day)", expand=c(0, 0))
	+ geom_line(data=flat, aes(time/day, hazRate*day))
	+ geom_line(data=trace, aes(time/day, hazRate*day))
	+ geom_line(data=respond, aes(time/day, hazRate*day))
)

print(ggplot()
	+ scale_x_continuous("Time since infection (days)")
	+ scale_y_continuous("Control strength", expand=c(0, 0))
	+ geom_line(data=flat, aes(time/day, strength))
	+ geom_line(data=trace, aes(time/day, strength))
	+ geom_line(data=respond, aes(time/day, strength))
)

## Intervention speed

r0 <- 0.23/day

phiFun(b0fun(g_pre, r0), flat)*day
phiFun(b0fun(g_post, r0), flat)*day
phiFun(b0fun(g_pre, r0), trace)*day
phiFun(b0fun(g_post, r0), trace)*day
phiFun(b0fun(g_pre, r0), respond)*day
phiFun(b0fun(g_post, r0), respond)*day
