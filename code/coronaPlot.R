library(ggplot2); theme_set(theme_bw())
library(egg)

library(shellpipes)

commandEnvironments()
startGraphics(width=12, height=4)

gen <- ggplot(genexample) +
  geom_line(aes(time, genden, lty=p)) +
  scale_x_continuous("Generation time (days)") +
  scale_y_continuous("Density (per days)", expand=c(0, 0)) +
  ggtitle("A") +
  theme(
    legend.position=c(0.9, 0.9),
    legend.title=element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line()
  )


scen <- (ggplot()
	+ aes(p, strength, col=type, lty=type, shape=type, size=type)
	+ geom_line()
	+ geom_point()
	+ scale_x_continuous("Proportion of pre-symptomatic transmission, p")
	+ scale_color_manual(values=c("black", "orange", "blue", "red"))
	+ scale_linetype_manual(values= c(1, 2, 2, 2))
	+ scale_size_manual(values=c(0, 0.5, 0.5, 0.5))
	+ theme(
		legend.title=element_blank(),
		panel.grid = element_blank(),
		panel.border = element_blank(),
		axis.line = element_line(),
		NULL
  )
)

strength <- (scen %+% strengthall
  ## + geom_point(x=0.25, y=Rbase, size=2, color="black")
  + scale_y_continuous("Strength")
  + ggtitle("B")
  + theme(
    legend.position = "bottom"
  )
)

g3 <- ggplot(speedall) +
  geom_line(aes(p, speed, col=type, lty=type)) +
  geom_point(x=0.25, y=r, size=2) +
  scale_x_continuous("Proportion of pre-symptomatic transmission, p") +
  scale_y_continuous("Speed (1/day)") +
  ggtitle("C") +
  theme(
    legend.title=element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(),
    legend.position = "none"
  )

gtot <- ggarrange(gen, strength, g3, nrow=1)
saveGG(gtot, width=12, height=4)
