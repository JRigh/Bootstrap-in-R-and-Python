#---------------
# Bootstrap in R
#---------------

library(bootstrap)

# example 1
sample1 = c(8.26, 6.33, 10.4, 5.27, 5.35, 5.61, 6.12, 6.19, 5.2, 7.01, 8.74, 7.78, 
    7.02, 6, 6.5, 5.8, 5.12, 7.41, 6.52, 6.21, 12.28, 5.6, 5.38, 6.6, 8.74)

mean(sample1) # [1] 6.8576
sd(sample1) # [1] 1.731346

# coefficient of variation [1] 0.2524712
cv <- sd(sample1)/mean(sample1) 

# save a copy dataset 'sample1' in .csv
write.csv(sample1, 
          "C:/Users/julia/OneDrive/Desktop/github/13. Bootstrap/sample1.csv",
          row.names = FALSE)

# Perform bootstrap to estimate the cv
# method 1
theta_hat = function(x) {
  sd(x) / mean(x) # coefficient of variation
} 
theta_hat(sample1)

# the bootstrap
# arg: x: initial sample
# theta: function of the estimator

set.seed(2023)
B = 10000                            # B: set the number of bootstrap replicates                       
boot = bootstrap(x = sample1,        # x: initial sample
                 n = B,              # n: number of bootstrap replicates
                 theta_hat)          # the function

# the bootstrap replicates are saved in 'thetastat'
# which is an object returned by the function 'bootstrap'

# estimate of the bias
bias <- mean(boot$thetastar) - theta_hat(sample1)  # the bias estimate
bias # [1] -0.01236049

# estimate of the standard error
sdthetastar <- sd(boot$thetastar)
sdthetastar # [1] 0.04466796

# histogram of the bootstrap replicates of 'cv'
ggplot(data.frame('cv' = boot$thetastar)) +
  geom_histogram(aes(x = cv, y = stat(density)), color = 'black', fill = "darkred", binwidth = 0.01) +
  geom_density(aes(x = cv, colour = cv), lwd = 1.2) +
  scale_x_continuous(breaks = round(seq(min(boot$thetastar) - 0.02, max(boot$thetastar) + 0.02, length.out = 10), 2)) +
  annotate(geom="text", x=0.32, y=7.6, label=paste('bias cv: ', round(bias, 4))) +
  annotate(geom="text", x=0.32, y=7.1, label=paste('se cv: ', round(sdthetastar, 4))) +
  labs(title = 'Histogram with overlying density of the bootstrap replicates of cv',
       subtitle = 'sample1 - method 1',
       y="count", x="coefficient of variation (cv)") +
  theme(axis.text=element_text(size=8),
        axis.title=element_text(size=8),
        plot.subtitle=element_text(size=10, face="italic", color="darkred"),
        panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.grid.major = element_line(colour = "grey90"))

#---------
# method 2
#---------

set.seed(2023)
B = 10000                                             # B: set the number of bootstrap replicates 
bootstrap_object <- matrix(rep(0, B*length(sample1)), 
                           nrow = B)
cv <- numeric(B)

# perform the bootstrap using the function sample() with replacement
for(i in 1:B) {
  
  bootstrap_object[i,] <- sample(sample1, size = length(sample1), replace = TRUE)
  
  cv[i] <- sd(bootstrap_object[i, ]) / mean(bootstrap_object[i, ]) 
}

# estimate of the bias
bias <- mean(cv) - (sd(sample1)/mean(sample1))
bias # [1] -0.01255868

# estimate of the standard error
se <- sd(cv)
se # [1] 0.0452905

# histogram of the bootstrap replicates of 'cv'
ggplot(data.frame('cv' = cv)) +
  geom_histogram(aes(x = cv, y = stat(density)), color = 'black', fill = "darkred", binwidth = 0.01) +
  geom_density(aes(x = cv, colour = cv), lwd = 1.2) +
  scale_x_continuous(breaks = round(seq(min(cv) - 0.02, max(cv) + 0.02, length.out = 10), 2)) +
  annotate(geom="text", x=0.32, y=7.6, label=paste('bias cv: ', round(bias, 4))) +
  annotate(geom="text", x=0.32, y=7.1, label=paste('se cv: ', round(se, 4))) +
  labs(title = 'Histogram with overlying density of the bootstrap replicates of cv',
       subtitle = 'sample1 - method 2 (function sample() with replacement)',
       y="count", x="coefficient of variation (cv)") +
  theme(axis.text=element_text(size=8),
        axis.title=element_text(size=8),
        plot.subtitle=element_text(size=10, face="italic", color="darkred"),
        panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.grid.major = element_line(colour = "grey90"))

#----
# end
#----


