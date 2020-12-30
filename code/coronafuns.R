# Units are days

## A phenomenological generation interval
## A gamma function multiplied by a saturation step
## Slow saturation corresponds to less pre-symptomatic transmission
gen <- function(sat, sMean=5*day, sShape=3
	, step = 0.05*day, window=20*day
){
	time <- seq(step, window, by=step)
	d0 <- (
		dgamma(time, shape=sShape, scale=sMean/sShape)
		* (time/(time+sat))
	)
	return(data.frame(
		time, density=d0/sum(step*d0)
	))
}

## How quickly is COVID-19 found and isolated?
## • decay rate (units 1/time) to represent contract tracing
## • Saturation to correspond to symptom-based isolation
## 	Not directly analogous to the saturation above!
## 	We are assuming isolation is not changing across our range of 
## 	pre-symptomatic scenarios

controlFun <- function(baseRate
	, sat = 0*day, decay=0/day
	, step = 0.05*day, window=20*day
){
	time <- seq(step, window, by=step)
	hazRate <- baseRate*exp(-decay*time)*time/(time+sat)
	Haz <- step*cumsum(hazRate)
	return(data.frame(time
		, hazRate
		, strength = exp(Haz)
	))
}

