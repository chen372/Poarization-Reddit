#
#  testwnom.r
#
#  Program to Run R Version of W-NOMINATE on Data with tab delimiter
#
#
#  Remove all objects just to be safe
#
rm(list=ls(all=TRUE))
#
library(pscl)
library(wnominate)
library(foreign)
library(gdata)
#
#
data.txt <- read.delim("C:/Users/Owner/Google Drive/Reddit/un3133.txt")
colnames(data.txt)						# Note the first three columns aren't votes
rc.txt <- rollcall(data.txt[,-(1:3)], yea=1, nay=6,		# Format data as rollcall object
        missing=9,
        notInLegis=0,
	legis.names=data.txt[,3],
        desc="UN 31 to 33",
	vote.names=colnames(data.txt)[-(1:3)]) 
#
#
#  Call W-NOMINATE
#
result <- wnominate(rc.txt, dims=2, polarity=c(1,2))	#Run wnominate on rollcall object
summary(result)						#summarize results
windows()
plot(result)
#
# length(result)
# class(result)
#     [1] "nomObject"
# names(result)
#     [1] "legislators" "rollcalls"   "dimensions"  "eigenvalues" "beta"       
#     [6] "weights"     "fits"       
# 
# result$legislators
# result$rollcalls
# result$dimensions
# result$eigenvalues
# result$beta
# result$weights
# result$fits
#
write.fwf(x=format(as.data.frame(result$legislators),digits=5,width=10,
   scientific=FALSE),"C:/Users/Owner/Google Drive/Reddit/UN3133_x.txt")
write.fwf(x=format(as.data.frame(result$rollcalls),digits=5,width=10,
   scientific=FALSE),"C:/Users/Owner/Google Drive/Reddit/UN3133_z.txt")
#
WEIGHT=(result$weights[2])/(result$weights[1])
#
X1 <- result$legislators[,7]
X2 <- (result$legislators[,8])*WEIGHT
#
windows()
#
plot(X1,X2,type="n",asp=1,main="",
       xlab="",
       ylab="",
       xlim=c(-1.0,1.0),ylim=c(-1.0,1.0),font=2,cex=1.2)
# Main title
mtext("United Nations: 31 - 33",side=3,line=1.50,cex=1.2,font=2)
# x-axis title
#mtext("D=Northern Democrat, S=Southern Democrat\nR=Republican",side=1,line=3.25,cex=1.2)
# y-axis title
#mtext("Region/Social Issues",side=2,line=2.5,cex=1.2)
#
points(X1,X2,pch=16,col="blue",font=2)