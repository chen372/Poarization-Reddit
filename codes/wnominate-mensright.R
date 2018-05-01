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
data.txt <- read.delim("C:/Users/Owner/Google Drive/Reddit/MensRights_top_users_posts_matrix.txt")
colnames(data.txt)	
head(data.txt)						# Note the first column is vote
rc.txt <- rollcall(data.txt[,-1], yea=1, nay=0,		# Format data as rollcall object
                   legis.names=data.txt[,1],
                   desc="MensRights top users post",
                   vote.names=colnames(data.txt)[-1]) 
#
#
#  Call W-NOMINATE
#
result <- wnominate(rc.txt, dims=1, polarity=7)	 #Run wnominate on rollcall object
summary(result)						#summarize results