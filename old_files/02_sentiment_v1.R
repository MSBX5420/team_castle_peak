###########################################################
# Team Castle Peak
# Sentiment Analysis Code
# By: Paul Telesca 4/22
###########################################################

# Install ggplot
# install.packages("ggplot2")

library(stringr)
library(R.utils)
library(tm)
library(NLP)
library(ggplot2)

# Clean up existing environment
# rm(list = ls())

# Set to individual local working directory
# setwd("C:\\Users\\zhe zhao\\Desktop\\MSBX5420")
setwd("C:\\Users\\seeth\\OneDrive\\OD_Documents\\MBA\\SPRING_20\\MSBX5420 - Unstructured Data\\Project\\team_castle_peak")

# Read in data
news <- read.csv("news_cleaned.csv", stringsAsFactors = FALSE)

# Read in article text to content matrix
article_text <- vector()
article_text <- news$text

# Debug - check article_text
# article_text[1]

# Pre-process text for sentiment analysis
# Convert corpora to vcorpus format for preprocessing
vs <- VectorSource(article_text)
vc_covid <- VCorpus(vs)

# Preprocess the corpora
vc_covid_0 <- tm_map(vc_covid, content_transformer(tolower))
vc_covid_1 <- tm_map(vc_covid_0, removeNumbers)
vc_covid_3 <- tm_map(vc_covid_1, removePunctuation)
vc_covid_4 <- tm_map(vc_covid_3, stripWhitespace)
vc_covid_5 <- tm_map(vc_covid_4, removeWords, stopwords("english"))
vc_covid_6 <- tm_map(vc_covid_5, stemDocument)

# Convert to TDM format
tdm_covid_article_text = TermDocumentMatrix(vc_covid_6)

# Debug - inspect TDM
#inspect(tdm_covid_article_text)

# Remove sparse terms
tdm_covid_article_text <- removeSparseTerms(tdm_covid_article_text, .99)

# Require dictionaries for sentiment
require("tm.lexicon.GeneralInquirer")

# Calculate pos and neg scores for the GI dictionaries
score_ge_pos <- tm_term_score(tdm_covid_article_text, terms_in_General_Inquirer_categories("Positiv"))
score_ge_neg <- tm_term_score(tdm_covid_article_text, terms_in_General_Inquirer_categories("Negativ"))

# Sum the total number of words
allwords <- colSums(as.matrix(tdm_covid_article_text))

# Calculate the positive, negative, and overall sentiments for this corpora using GI
sentiment_pos_ge <- score_ge_pos/allwords
sentiment_neg_ge <- score_ge_neg/allwords
sentiment_net_ge <- (sentiment_pos_ge - sentiment_neg_ge)/allwords

# Debug - check sentiment matrices
sentiment_net_ge

# Get Dates
dates <- na.omit(news$data)

# Create matrix for sentiment scores and dates
sentiment_scores_matrix <- matrix(0, length(article_text), 2)

# Save sentiment and sate scores in matrix
sentiment_scores_matrix[,1] <- sentiment_net_ge
sentiment_scores_matrix[,2] <- dates

# Debug - see number of unique dates
summary(as.factor(sentiment_scores_matrix[,2]))

# Create matrix for unique dates and sentiment scores for those dates
date_scores_matrix <- matrix(0, length(unique(sentiment_scores_matrix[,2])), 2)
date_scores_matrix[,2] <- unique((sentiment_scores_matrix[,2]))

date_scores_matrix
dim(date_scores_matrix)[1]

count <- 0

for (i in 1:dim(date_scores_matrix)[1]){

  cat("date:", date_scores_matrix[i,2], "iteration:", i, "of", dim(date_scores_matrix)[1],"\n" )
  
  for (j in 1:dim(sentiment_scores_matrix)[1]){
    
    if(sentiment_scores_matrix[j,2]==date_scores_matrix[i,2]){
      
        cat("match", date_scores_matrix[i,2], "\n")
        count <- count + 1  
        date_scores_matrix[i,1] <- as.numeric(date_scores_matrix[i,1]) + as.numeric(sentiment_scores_matrix[j,1])
        cat("sum:", date_scores_matrix[i,1], "\n")
    }
  }  
}

#Debug - check matrix results
# head(date_scores_matrix)
# sort(as.numeric(date_scores_matrix[,1]), decreasing = FALSE)
# sort(date_scores_matrix[,1], decreasing = FALSE)

# Put scores and dates into data frame format
data_matrix <- as.data.frame(date_scores_matrix)

# Select only 2020 dates
data_matrix_2020 <- data_matrix[grep("2020-", data_matrix[,2]),]

# Format sentiment scores as numeric
data_matrix_2020[,1] <- as.numeric(as.character(data_matrix_2020[,1]))

# Plot the Data
p <- ggplot(data = data_matrix_2020, aes(x = as.Date(data_matrix_2020[,2]), y = data_matrix_2020[,1])) +
      geom_point() + 
      scale_x_date(name = "Date", date_breaks = "1 week", date_labels= "%b %d") +
      scale_y_continuous(name = "Net Sentiment Score")+
      ggtitle("Net Sentiment of COVID-19 Articles in 2020")

p
