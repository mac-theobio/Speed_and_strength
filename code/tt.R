library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("makestuff/makeRfuns.R")
commandEnvironments()
makeGraphics(width=8, height=6)

maxRate <- 1/6
h_base <- HIVgen(earlyProp = earlyBase, step=0.1)

b_base <- b0fun(h_base, rfitmonth)

tt <- testingFun(maxRate)

g1 <- ggplot(tt) +
	geom_line(aes(time*month/year, strength), col=2) +
	geom_hline(yintercept=theFun(h_base, tt), lty=2, col=2) +
	scale_x_continuous("Time (years)", expand=c(0,0), limits=c(0, 16.5)) +
	scale_y_log10(expression(L[test])) +
	ggtitle("A") +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

early <- seq(from=earlySlow, to=earlyFast, by=0.01)

R0 <- sapply(early, function(x) {
	hh <- HIVgen(earlyProp = x, step=0.1)
	r2R(hh, rfitmonth)
})

earlydata <- data.frame(
	early=early,
	R0=R0
)

interstrength <- sapply(early, function(x) {
	hh <- HIVgen(earlyProp = x, step=0.1)
	theFun(hh, tt)
})

strengthdata <- data.frame(
	early=early,
	strength=interstrength
)

g2 <- ggplot(earlydata) +
	geom_line(aes(early, R0, col="Epidemic")) +
	geom_line(data=strengthdata, aes(early, strength, col="Intervention")) +
	scale_color_manual(values=c("black", "red")) +
  geom_point(data=earlydata[earlydata$early==earlyBase,], aes(early, R0), size=5) +
  geom_point(data=strengthdata[strengthdata$early==earlyBase,], aes(early, strength), size=5, col="red") +
	scale_x_continuous("Proportion of early transmission", limits=c(0.1, 0.42), expand=c(0, 0)) +
	scale_y_log10("Strength", limits=c(1, 16), expand=c(0, 0), breaks=c(1, 2, 4, 8, 16)) +
	ggtitle("B") +
	theme(
		legend.position=c(0.85, 0.9),
		legend.title = element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

g3 <- ggplot(tt) +
	geom_line(aes(time*month/year, hazRate*year/month), col=2) +
	geom_hline(aes(yintercept=phiFun(b_base, tt)*year/month), lty=2, col=2) +
	scale_x_continuous("Time (years)", limits=c(0, 16.5), expand=c(0, 0)) +
	scale_y_continuous(expression(h[test]~(year^{-1}))) +
	ggtitle("C") +
	theme(
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

interspeed <- sapply(early, function(x) {
	hh <- HIVgen(earlyProp = x, step=0.1)
	bb <- b0fun(hh, rfitmonth)
	
	phiFun(bb, tt)
})

speeddata <- data.frame(
	early=early,
	speed=interspeed*year/month
)

g4 <- ggplot(speeddata) +
	geom_line(aes(early, speed, col="Intervention")) +
	geom_hline(aes(yintercept=rfityear, col="Epidemic" )) +
  geom_point(data=speeddata[speeddata$early==earlyBase,], aes(early, speed), size=5, col="red") +
  geom_point(x=earlyBase, y=rfityear, size=5) +
	scale_x_continuous("Proportion of early transmission", limits=c(0.1, 0.42), expand=c(0, 0)) +
	scale_y_continuous(expression(Speed~(year^{-1})), limits=c(0, 0.8), expand=c(0, 0)) +
	scale_color_manual(values=c("black", "red")) +
	ggtitle("D") +
	theme(
		legend.position = "none",
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line()
	)

grid.arrange(g1, g2, g3, g4, nrow=2)

