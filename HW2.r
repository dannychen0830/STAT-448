# Problem 4
control = rt(10000,df=31)
control = (control)*(0.24/sqrt(32)) + 1.013
hist(control,xlim=c(0.5,1.5),col=rgb(1,0,0,0.5),xlab="",
     main = "Posterior distributions for \nControl and Treatment Group")

treatment = rt(10000,df=35)
treatment = treatment*(0.20/sqrt(36)) + 1.173 
hist(treatment,xlim=c(0.5,1.5),col=rgb(0,0,1,0.5),add=T)

legend("topleft",legend=c("control","treatment"),col=c(rgb(1,0,0,0.5),col=rgb(0,0,1,0.5)),
       pt.cex=2, pch=15)

difference = treatment - control
hist(difference,xlim=c(-0.25,0.6),xlab="",
     main = "Posterior Distribution of the Difference \nbetweeen Control and Treatment Group")
print(quantile(difference,probs=c(0.025,0.975)))

# Problem 5
control = rbeta(1000,674.5,39.5)
hist(control,xlim=c(0.9,1),col=rgb(1,0,0,0.5),xlab="",
     main = "Posterior distributions for \nControl and Treatment Group")

treatment = rbeta(1000,680.5,22.5)
hist(treatment,xlim=c(0.9,1),col=rgb(0,0,1,0.5),add=T)

legend("topleft",legend=c("control","treatment"),col=c(rgb(1,0,0,0.5),col=rgb(0,0,1,0.5)),
       pt.cex=2, pch=15)

odds = (treatment/(1-treatment))/(control/(1-control))
hist(odds,xlim=c(0,5),xlab="",main="Distribution of Odds from Posterior Distributions")
print(mean(odds))
print(quantile(odds,probs=c(0.025,0.975)))

