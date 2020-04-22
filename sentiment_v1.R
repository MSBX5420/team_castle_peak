###########################################################
# Team Castle Peak
# Sentiment Analysis Code
# By: Paul Telesca 4/22
###########################################################

library(stringr)
library(R.utils)
library(tm)
library(NLP)

# Clean up existing environment
rm(list = ls())

# Set to individual local working directory
# setwd("C:\\Users\\zhe zhao\\Desktop\\MSBX5420")
setwd("C:\\Users\\seeth\\OneDrive\\OD_Documents\\MBA\\SPRING_20\\MSBX5420 - Unstructured Data\\Project\\team_castle_peak")

# Read in article text to content matrix
article_text <- vector()
article_text <- news$text

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

# Require dictionaries for sentiment
require("tm.lexicon.GeneralInquirer")

# Record analysis time
time1 <- Sys.time()

# Calculate pos and neg scores for the GI dictionaries
score_ge_pos <- tm_term_score(tdm_covid_article_text, terms_in_General_Inquirer_categories("Positiv"))
score_ge_neg <- tm_term_score(tdm_covid_article_text, terms_in_General_Inquirer_categories("Negativ"))

# Check duration of analysis
time2 <- Sys.time()
time2-time1

# Sum the total number of words
allwords <- colSums(as.matrix(tdm_covid_article_text))

# Calculate the positive, negative, and overall sentiments for this corpora using GI
sentiment_pos_ge <- score_ge_pos/allwords
sentiment_neg_ge <- score_ge_neg/allwords
sentiment_net_ge <- (sentiment_pos_ge - sentiment_neg_ge)/allwords

# Debug - check sentiment matrices
sentiment_net_ge

# Calculate the average sentiment for the industry
avg_sentiment_ge <- sum(sentiment_net_ge)/length(files_save)

# Check results
avg_sentiment_ge