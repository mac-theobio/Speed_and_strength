# g, b are data frames with time and density
# L is a data frame with time, strength and something about hazard

## Calculate the initial backward distribution
b0fun <- function(g, r){
	step <- with(g, time[[2]]-time[[1]])
	d0 <- with(g, density*exp(-r*time))
	return(with(g, data.frame(time
							  , density=d0/sum(step*d0)
	)))
}

# How much does a given discount (r) _reduce_ R for distribution g?
r2R <- function(g, r){
	step <- with(g, time[[2]]-time[[1]])
	return(with(g, 1/(step*sum(density*exp(-r*time)))))
}

R2r <- function(g, R){
	step <- with(g, time[[2]]-time[[1]])
	return(uniroot(
		function(r, g){r2R(g, r)-R}
		, interval=c(0, 1/step)
		, g=g
	)$root)
}

### Speed of intervention

# Calculate the arithmetic mean inside the implicit equation for phi
phiBar <- function(b, L, phi){
	step <- with(b, time[[2]]-time[[1]])
	return(with(cbind(b,L), {
		step*sum(density*exp(phi*time)/strength)
	}))
}

### Find the phi that satisfies the equation
phiFun <- function(b, L){
	step <- with(b, time[[2]]-time[[1]])
	return(uniroot(
		function(phi, b, L){phiBar(b, L, phi)-1}
		, interval=c(0, 1/step)
		, b=b, L=L
	)$root)
}

theFun <- function(g, L){
	step <- with(g, time[[2]]-time[[1]])
	return(with(cbind(g, L), {
		1/(step*sum(density/strength))
	}))
}

densPlot <- function(time, k, scen, color="black", ymax=NULL, title=NULL){
	if(is.null(ymax)) ymax <- max(k)
	with(c(scen), {
		if(is.null(title)) title <- disease
		if(is.numeric(title)) title <-
				paste("Reproductive number", sprintf("%5.2f", title))
		# if(is.numeric(title)) title <- expression(R=title)
		plot(time, k
			 , main = title
			 , xlab = paste0("time (", unit, ")")
			 , ylab = paste0("Density (1/", unit, ")")
			 , type = "l", col=color
			 , ylim = c(0, ymax)
		)
	})
}

Rrplot <- function(g, R, scen){
	r <- R2r(g, R)
	b0 <- b0fun(g, r)
	print(b0)
	with(g, {
		densPlot(time, R*density, scen)
		
		densPlot(time, R*density, scen)
		lines(time, density, col="blue")
		lines(time, b0$density, col="red")
		
		densPlot(time, R*density, scen)
		lines(time, density, col="blue")
		
		densPlot(time, R*density, scen)
		lines(time, b0$density, col="red")
	})
}

dualPlot <- function(time, interv, intname, gen, stat, dtype){
	op <- par(mfrow=c(2, 1)
			  , oma = c(0,0,0,0) + 0.1
			  , mar = c(0,4,1,1) + 0.1
	)
	par(cex=1.3)
	plot(time, interv, type="l"
		 , axes=FALSE, xlab="", ylab=intname
	)
	axis(2)
	abline(h=stat, col="blue")
	par(mar = c(5,4,1,1) + 0.1)
	with(gen, plot(time, density
				   , type="l", main=dtype, xlab="time (months)"
	))
	par(op)
}

intPlot <- function(time, density, strength, R){
	op <- par(mfrow=c(2, 1)
			  , oma = c(0,0,0,0) + 0.1
			  , mar = c(0,4,1,1) + 0.1
	)
	par(cex=1.3)
	plot(time, strength, type="l"
		 , axes=FALSE, xlab="", main="Intervention"
	)
	axis(2)
	
	par(mar = c(5,4,1,1) + 0.1)
	plot(time, R*density, ylab="kernel", type="l", main="Before and after")
	lines(time, R*density/strength, type="l")
	par(op)
}

intervalMoments <- function(g){
	attach(g)
	s0 <- sum(density)
	s1 <- sum(time*density)
	s2 <- sum(time*time*density)
	detach(g)

	return(c(weight=s0
		, mean = s1/s0
		, CV2 = s2*s0/s1^2-1
	))
}
