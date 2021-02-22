# Problem 4 
curve(dnorm(x,(40^2*150/(40^2+40)) + 40*180/(40^2 + 40),1/(1/40^2 + 1/40)), from = 0, to = 350, col = "blue", ylab = "",xlab = "", ylim=c(0,0.012))
curve(dnorm(x, (20^2*150/(20^2+40)) + 40*180/(20^2 + 40),1/(1/20^2 + 1/40)), col = "red", add = TRUE)
curve(dnorm(x, (20^2*150/(20^2+40)) + 40*120/(20^2 + 40),1/(1/20^2 + 1/40)), col = "green", add = TRUE)
curve(dnorm(x, (40^2*150/(40^2+40)) + 40*120/(40^2 + 40),1/(1/40^2 + 1/40)), col = "orange", add = TRUE)
legend("topright", legend=c("mu = 180, tau = 40", "mu = 180, tau = 20", "mu = 120, tau = 40", "mu = 120, tau = 20"),
       col=c("red", "blue", "orange", "green"), pch=15,)

# Problem 5 (a)
curve(dbeta(x,1,2/3),ylab = "", xlab = "", main = "Prior Distribution ~ Beta(1,2/3)")

# Problem 5 (b)
curve(dbeta(x,1 + 650, 2/3 + 350), ylab = "", xlab = "", main = "Posterior Distribution ~ Beta(651,350.66)")

curve(dbeta(x,300+650, 200+350), ylab = "", xlab = "", col = "blue")
curve(dbeta(x,1+650, 1 + 350), col = "red", add = TRUE)
curve(dbeta(x,1+650, 2/3 + 350), col = "black", add = TRUE)
curve(dbeta(x,30+650, 20 + 350), col = "green", add = TRUE)
curve(dbeta(x,20+650, 20 + 350), col = "orange", add = TRUE)
curve(dbeta(x,100+650, 100+ 350), col = "purple", add = TRUE)
legend("topleft", legend=c("alpha = 1, beta = 1","alpha = 1, beta = 2/3","alpha = 30, beta = 20","alpha = 300, beta = 200","alpha = 20, beta = 20","alpha = 100, beta = 100"),
        col = c("red","black","green","blue","orange","purple"),pch=15)

# Problem 5 Extra 
print(1 - pbeta(.67, 651,350.66666))

# Problem 7 (a)  
curve(dbeta(x,10,2),from = 0, to = 1, main = "Density Function of Beta(10,2)", xlab = "", ylab = "")
print(qbeta(0.025,10,2))
print(qbeta(0.975,10,2))

# Problem 7 (b)
samples = rbeta(500,10,2)
hist(samples, main = "Histogram of beta(10,2) with 500 samples", xlab = "")
print(quantile(samples))

omega = numeric(500)
for (i in 1:500)
  omega[i] = samples[i]*(1-samples[i])
hist(omega, main = "Histrogram for the Odds with 500 samples")

samples = rbeta(50000,10,2)
hist(samples, main = "Histogram of beta(10,2) with 50000 samples", xlab = "")
print(quantile(samples))

omega = numeric(50000)
for (i in 1:50000)
  omega[i] = samples[i]*(1-samples[i])
hist(omega, main = "Histogram of the Odds with 50000 samples")
