library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(shellpipes)

loadEnvironments()
makeGraphics(width=4, height=7)

grid.arrange(p1, p2, nrow=2)

