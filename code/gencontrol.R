library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("makestuff/makeRfuns.R")
sourceFiles()
makeGraphics(width=8, height=3)

gbar <- 16.2
gshape <- 1/0.58^2

tvec <- seq(0, 50, by=0.01)

g1 <- data.frame(
  time=tvec,
  density=1.5*dgamma(tvec, shape=gshape, rate=gshape/gbar)
)

g2 <- data.frame(
  time=tvec,
  density=dgamma(tvec, shape=gshape, rate=gshape/gbar)
)

p1 <- ggplot(data=g1) +
  geom_line(aes(time, density, col="Baseline")) +
  geom_line(data=g2, aes(time, density, col="Controlled")) +
  geom_segment(aes(x=10.75, xend=10.75, y=0.07, yend=0.053),
               arrow = arrow(length = unit(0.3, "cm"))) +
  ggtitle("A. Constant strength intervention") +
  scale_x_continuous("Time (days)") +
  scale_y_continuous("Density") +
  scale_color_manual(values=c(1, 2)) +
  theme(
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line=element_line(),
    legend.position = c(0.85, 0.9),
    legend.title = element_blank()
  )

b0 <- b0fun(g2, R2r(g2, 1.5))

p2 <- ggplot(data=g1) +
  geom_line(aes(time, density, col="Baseline")) +
  geom_line(data=b0, aes(time, density, col="Controlled")) +
  geom_segment(aes(x=10.75, xend=9.39, y=0.07, yend=0.06),
               arrow = arrow(length = unit(0.3, "cm"))) +
  ggtitle("B. Constant speed intervention") +
  scale_x_continuous("Time (days)") +
  scale_y_continuous("Density") +
  scale_color_manual(values=c(1, 2)) +
  theme(
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line=element_line(),
    legend.position = c(0.85, 0.9),
    legend.title = element_blank()
  )

grid.arrange(p1, p2, nrow=1)

