library(ggplot2); theme_set(theme_bw())
library(dplyr)
library(egg)
library(deSolve)

r <- log(2)/3
pbase <- 0.25
dbase <- 2.5
gamma2 <- 2/dbase

model <- function(t, y, par) {
  with(as.list(c(y, par)), {
    infection <- (betap * (Ip1+Ip2) + betas * (Is1 + Is2)) * S
    
    dS <- - infection
    dE1 <- infection - 2 * sigma * E1
    dE2 <- 2 * sigma * E1 - 2 * sigma * E2
    dIp1 <- 2 * sigma * E2 - 2 * gamma_p * Ip1
    dIp2 <- 2 * gamma_p * Ip1 - 2 * gamma_p * Ip2
    dIs1 <- 2 * gamma_p * Ip2 - 2 * gamma_s * Is1 - hazard * Is1
    dIs2 <- 2 * gamma_s * Is1 - 2 * gamma_s * Is2 - hazard * Is2
    dR <- 2 * gamma_s * Is2 + hazard * (Is1 + Is2)
    
    
    list(c(dS, dE1, dE2, dIp1, dIp2, dIs1, dIs2, dR),
         infection=infection)
  })
}

genfun <- function(x, p=0.3, duration=dbase) {
  p * (- pgamma(x, 4, rate=2/duration) + pgamma(x, 2, rate=2/duration))/duration +
    (1-p) * (- pgamma(x, 6, rate=2/duration) + pgamma(x, 4, rate=2/duration))/duration
}

pvec <- c(0.25, 0.5, 0.75)
tvec <- seq(0, 20, by=0.1)

genexample <- lapply(pvec, function(p) {
  data.frame(
    time=tvec,
    genden=genfun(tvec, p),
    p=paste0("p=", p)
  )
}) %>%
  bind_rows

rRexample <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  R <- 1/integrate(function(x) {
    genfun(x, p) * exp(-r*x)
  }, 0, Inf)[[1]]
  
  data.frame(
    p=p, strength=R, type="Epidemic"
  )
}) %>%
  bind_rows

Rbase <- rRexample$strength[rRexample$p==pbase]
betapbase <- Rbase * pbase/dbase
betasbase <- Rbase * (1-pbase)/dbase

shazard <- optim(1, function(x) {
  (betasbase * (1/(x + gamma2) + gamma2/(x + gamma2)^2) - (1 - Rbase * pbase))^2
}, method="Brent", lower=0.1, upper=10)$par

symptom_strength <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  Rtmp <- rRexample$strength[rRexample$p==p]
  betaptmp <- Rtmp * p/dbase
  betastmp <- Rtmp * (1-p)/dbase
  
  Rpost <- betastmp * (1/(shazard + gamma2) + gamma2/(shazard + gamma2)^2) + betaptmp * dbase
  
  data.frame(
    p=p,
    strength=Rtmp/Rpost,
    type="Symptom-based"
  )
}) %>%
  bind_rows

y0 <- c(S=1-1e-8, E1=1e-8, E2=0, Ip1=0, Ip2=0, Is1=0, Is2=0, R=0)

tvec <- seq(0, 100, by=0.01)

symptom_speed <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  Rtmp <- rRexample$strength[rRexample$p==p]
  betaptmp <- Rtmp * p/dbase
  betastmp <- Rtmp * (1-p)/dbase
  
  par <- c(betap=betaptmp, betas=betastmp,
           sigma=1/dbase,
           gamma_p=1/dbase,
           gamma_s=1/dbase,
           hazard=shazard)
  
  out <- as.data.frame(ode(y0, tvec, model, par))
  
  lfit <- lm(log(out$infection[tvec >= 20 & tvec <= 40]) ~ tvec[tvec >= 20 & tvec <= 40])
  
  data.frame(
    p=p,
    speed=r - coef(lfit)[[2]],
    type="Symptom-based"
  )
}) %>%
  bind_rows

## infection based intervention
infint <- function(tau, hmax=2, k=1) {
  sapply(tau, function(y) exp(-integrate(function(x) {
    hmax * (1- exp(-k*dgamma(x, 2, 2/2)))
  }, lower=0, upper=y)[[1]]))
}

hmax <- optim(1, function(hh) {
  (integrate(f=function(z) Rbase * genfun(z, p=0.25) * infint(z, hmax=hh),
            lower=0, upper=Inf)[[1]]-1)^2
}, method="Brent", lower=0.1, upper=10)$par

infection_strength <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  Rtmp <- rRexample$strength[rRexample$p==p]
  betaptmp <- Rtmp * p/dbase
  betastmp <- Rtmp * (1-p)/dbase
  
  Rpost <- integrate(f=function(z) Rtmp * genfun(z, p=p) * infint(z, hmax=hmax),
                     lower=0, upper=Inf)[[1]]
  
  data.frame(
    p=p,
    strength=Rtmp/Rpost,
    type="Infection-based"
  )
}) %>%
  bind_rows

infection_speed <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  Rtmp <- rRexample$strength[rRexample$p==p]
  betaptmp <- Rtmp * p/dbase
  betastmp <- Rtmp * (1-p)/dbase
  
  rpost <- optim(1, function(rr) (integrate(f=function(z) Rtmp * genfun(z, p=p) * infint(z, hmax=hmax) * exp(-rr * z),
                                        lower=0, upper=Inf)[[1]] - 1)^2,
                 lower=-0.2,
                 upper=0.2,
                 method="Brent")$par 
  
  data.frame(
    p=p,
    speed=r-rpost,
    type="Infection-based"
  )
}) %>%
  bind_rows

lockdown_speed <- lapply(seq(0.2, 0.8, by=0.01), function(p) {
  Rtmp <- rRexample$strength[rRexample$p==p]
  betaptmp <- Rtmp * p/dbase
  betastmp <- Rtmp * (1-p)/dbase
  
  rpost <- optim(1, function(rr) (integrate(f=function(z) Rtmp * genfun(z, p=p)/Rbase * exp(-rr * z),
                                            lower=0, upper=Inf)[[1]] - 1)^2,
                 lower=-0.2,
                 upper=0.2,
                 method="Brent")$par 
  
  data.frame(
    p=p,
    speed=r-rpost,
    type="Lockdown"
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

strengthall <- bind_rows(
  rRexample,
  data.frame(
    p=seq(0.2, 0.8, by=0.01), strength=Rbase, type="Lockdown"
  ),
  symptom_strength,
  infection_strength
)

g2 <- ggplot(strengthall) +
  geom_line(aes(p, strength, col=type, lty=type)) +
  geom_point(x=0.25, y=Rbase, size=2) +
  scale_x_continuous("Proportion of pre-symptomatic transmission, p") +
  scale_y_continuous("Strength of epidemic/intervention") +
  scale_color_manual(values=c("black", "orange", "red", "blue")) +
  scale_linetype_manual(values=1:4) +
  ggtitle("B") +
  theme(
    legend.title=element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(),
    legend.position = "bottom"
  )

speedall <- bind_rows(
  data.frame(p=seq(0.2, 0.8, by=0.01), speed=r, type="Epidemic"),
  lockdown_speed,
  symptom_speed,
  infection_speed
)

g3 <- ggplot(speedall) +
  geom_line(aes(p, speed, col=type, lty=type)) +
  geom_point(x=0.25, y=r, size=2) +
  scale_x_continuous("Proportion of pre-symptomatic transmission, p") +
  scale_y_continuous("Speed of epidemic/intervention (1/day)") +
  scale_color_manual(values=c("black", "orange", "red", "blue")) +
  scale_linetype_manual(values=1:4) +
  ggtitle("C") +
  theme(
    legend.title=element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(),
    legend.position = "none"
  )

gtot <- ggarrange(g1, g2, g3, nrow=1)

ggsave("coronaexample.pdf", gtot, width=12, height=4)
