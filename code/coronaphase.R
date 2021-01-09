library(ggplot2); theme_set(theme_bw())
library(dplyr)
library(gridExtra)

r <- log(2)/3

genfun <- function(x, p=0.3, duration=2.5) {
  p * (- pgamma(x, 4, rate=2/duration) + pgamma(x, 2, rate=2/duration))/duration +
    (1-p) * (- pgamma(x, 6, rate=2/duration) + pgamma(x, 4, rate=2/duration))/duration
}

pvec <- c(0.2, 0.4, 0.6, 0.8)
tvec <- seq(0, 20, by=0.1)

genexample <- lapply(pvec, function(p) {
  data.frame(
    time=tvec,
    genden=genfun(tvec, p),
    p=paste0("p=", p)
  )
}) %>%
  bind_rows

g1 <- ggplot(genexample) +
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

rRexample <- lapply(seq(0.01, 0.99, by=0.01), function(p) {
  R <- 1/integrate(function(x) {
    genfun(x, p) * exp(-r*x)
  }, 0, Inf)[[1]]
  
  data.frame(
    p=p, R=R
  )
}) %>%
  bind_rows

g2 <- ggplot(rRexample) +
  geom_line(aes(p, R)) +
  scale_x_continuous("Proportion of pre-symptomatic transmission, p") +
  scale_y_continuous("Reproduction number") +
  ggtitle("B") +
  theme(
    legend.title=element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line()
  )

gtot <- grid.arrange(g1, g2, nrow=1)

ggsave("coronaexample.pdf", gtot, width=8, height=4)
