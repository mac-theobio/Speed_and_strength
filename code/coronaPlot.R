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
	+ aes(p, col=type, lty=type, shape=type, size=type)
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
	+ aes(y=strength)
	+ scale_y_continuous("Strength")
	+ ggtitle("B")
	+ theme(
    legend.position = "bottom"
  )
)

speed <- (scen %+% speedall
	+ aes(y=speed)
	+ scale_y_continuous("Speed (1/day)")
	+ ggtitle("C")
	+ theme(
		legend.position = "none"
  )
)

gtot <- ggarrange(gen, strength, speed, nrow=1)
saveGG(gtot, width=12, height=4)
