source("makestuff/makeRfuns.R") 

commandEnvironments()

lastyear <- 8
hiv_ts <- csvRead(comment="#")

lfit <- lm(log(prevalence)~year, data=hiv_ts[1:lastyear,])

p0 <- coef(lfit)[[1]]
rfityear <- coef(lfit)[[2]]
rfitmonth <- coef(lfit)[[2]]*month/year

saveVars(hiv_ts, p0, rfityear, rfitmonth)
