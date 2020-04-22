###########################################################
# Team Castle Peak
# Data Cleaning Code
# By: Zhe Zhao 4/13
###########################################################

# Install chrom package if not already
# install.packages("chron")
library(chron)
library(stringr)
library(R.utils)

# Clean up existing environment
rm(list = ls())

# Set to local working directory
#setwd("C:\\Users\\zhe zhao\\Desktop\\MSBX5420")
setwd("C:\\Users\\seeth\\OneDrive\\OD_Documents\\MBA\\SPRING_20\\MSBX5420 - Unstructured Data\\Project\\team_castle_peak")

news<-read.csv('news.csv',stringsAsFactors = FALSE, na.strings = c("NA", ""))

head(news)

#############################################
# data cleansing
#############################################
#drop columns
news[,1]<- NULL

# convert all empty strings to NA
news[news==""] <-NA
colSums(is.na(news)) #no empty strings

#author names
news$authors[news$authors] == '[]' <- NA

# convert colunm names
colnames(news)[3] <-"publish_timestamp"

#check duplicate and drop
news<-news[!duplicated(news), ] #2817 unqiue

#add new columns
news$title_length<-nchar((news$title))

news$description_length <- nchar((news$description))

news$text_length<-nchar((news$text))

news$data<-as.Date(news$publish_timestamp)

mytime<-substr(news$publish_timestamp,12,19)

library(chron)
news$time<-chron(times=mytime)

# Debug - check out cleaned data
# head(news)

# Write cleaned data to new csv
write.csv(news, "news_cleaned.csv")
