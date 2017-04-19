library(tm)
library(quanteda) #needs devtools & Matrix package
library(stringr)
posDict <- dictionary(list(articles = c("the", "a", "and"), conjunctions = c("and", "but", "or", "nor", "for", "yet", "so")))
posDfm <- dfm(data_corpus_inaugural, dictionary=posDict)
posDfm[1:5,]

wdir <- getwd()

temp <- tempfile(fileext = ".zip") 
download.file(paste0("http://www.tcd.ie/Political_Science/wordscores/files/WordscoresAPSR2_manifestos.zip"),temp)

unzip(zipfile= temp, exdir = wdir) 
unlink(temp)
myTmCorpus <- VCorpus(DirSource(wdir, pattern = "\\.txt" , recursive = T))
mycorpusTM <- corpus(myTmCorpus)

manifestoDfm <- dfm(mycorpusTM, tolower=T, removePunct=T, removeNumbers=T, removeSeparators = T,
                    remove = c(stopwords("english"), stopwords("german"))) 
manifestoDfm@Dimnames$docs <- names(myTmCorpus)

refs <- c(4.19,NA,NA,13.53, NA, 15.68,5.21, NA, 6.53, rep(NA, 8),4.50, 13.13,15.00,6.88,17.63,NA, 17.21,NA, 5.35, 8.21, NA)

ws <- textmodel(manifestoDfm, y = refs, model = "wordscores") 
pred <- predict(ws)