#Reddit project
#modeling membership

data <- read.csv(file="c:/Users/Bao/Google Drive/Reddit/timeSeries_zeroFiltered_unbiased_majoritySR_withQuantiles.csv", header=TRUE, sep=",")
head(data)

#construct the dependent variable
attach(data)
data$membership[feminism_mean_quantile <= 2  & mensrights_median_quantile <= 2] <- 1        #"Duffers"
data$membership[feminism_mean_quantile > 2 & mensrights_median_quantile <= 2] <- 2          #"Fem partisans"
data$membership[feminism_mean_quantile <= 2 & mensrights_median_quantile > 2] <- 3          #"MR partisans"
data$membership[feminism_mean_quantile > 2 & mensrights_median_quantile > 2] <- 4           #"Darlings"
detach(data)
data$fmembership <- factor(data$membership, labels=c("Duffer","Fem partisans","MR partisans","Darlings"))

k <- length(levels(data$fmembership))
I <- diag(k-1)
J <- matrix(rep(1, (k-1)^2), c(k-1, k-1))
data$fauthor <- factor(data$author)

# model
install.packages("MCMCglmm")
library(MCMCglmm)
mod1 <- MCMCglmm(fmembership ~ -1 + trait + month_num + lag_1_feminism_median + lag_1_mensrights_median +  
                   + lag_2_feminism_median + lag_2_mensrights_median,
                 random = ~ fauthor + month_num,
                 rcov = ~ us(trait):units,
                 prior = list(
                   R = list(fix=1, V=0.5 * (I + J), n = 4),
                   G = list(
                     G1 = list(V = diag(1), n = 4))), 
                 burnin = 15000,
                 nitt = 40000,
                 family = "categorical",
                 data = data)
              
summary(mod1$Sol)
              
              
              