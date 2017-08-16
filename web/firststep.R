library(tm)

# Collect data
tweets.AC<-read.csv('ad.csv',header=T)
tweets.ACBW<-read.csv('fe.csv',header=T)
tweets.ACSF<-read.csv('others.csv',header=T)
tweets.test<-read.csv('testing.csv',header=T)

tweets.AC["class"]<-rep("AC",nrow(tweets.AC))
tweets.ACBW["class"]<-rep("ACBW",nrow(tweets.ACBW))
tweets.ACSF["class"]<-rep("ACSF",nrow(tweets.ACSF))

# Helper Function
replacePunctuation <- function(x)
{
  x <- tolower(x)
  x <- gsub("[.]+[ ]"," ",x)
  x <- gsub("[:]+[ ]"," ",x)
  x <- gsub("[?]"," ",x)
  x <- gsub("[!]"," ",x)
  x <- gsub("[;]"," ",x)
  x <- gsub("[,]"," ",x)
  x
}

# Do our punctuation stuff
tweets.AC$Tweet <- replacePunctuation(tweets.AC$Tweet)
tweets.ACBW$Tweet <- replacePunctuation(tweets.ACBW$Tweet)
tweets.ACSF$Tweet <- replacePunctuation(tweets.ACSF$Tweet)
tweets.test$Tweet <- replacePunctuation(tweets.test$Tweet)

# Create corpus
tweets.AC.corpus <- Corpus(VectorSource(as.vector(tweets.AC$Tweet)))
tweets.ACBW.corpus <- Corpus(VectorSource(as.vector(tweets.ACBW$Tweet)))
tweets.ACSF.corpus <- Corpus(VectorSource(as.vector(tweets.ACSF$Tweet)))
tweets.test.corpus <- Corpus(VectorSource(as.vector(tweets.test$Tweet)))

# Create term document matrix
tweets.AC.matrix <- t(TermDocumentMatrix(tweets.AC.corpus,control = list(wordLengths=c(3,Inf))));
tweets.ACBW.matrix <- t(TermDocumentMatrix(tweets.ACBW.corpus,control = list(wordLengths=c(3,Inf))));
tweets.ACSF.matrix <- t(TermDocumentMatrix(tweets.ACSF.corpus,control = list(wordLengths=c(3,Inf))));
tweets.test.matrix <- t(TermDocumentMatrix(tweets.test.corpus,control = list(wordLengths=c(3,Inf))));

# Probability Matrix
probabilityMatrix <-function(docMatrix)
{
  # Sum up the term frequencies
  termSums<-cbind(colnames(as.matrix(docMatrix)),as.numeric(colSums(as.matrix(docMatrix))))
  # Add one
  termSums<-cbind(termSums,as.numeric(termSums[,2])+1)
  # Calculate the probabilties
  termSums<-cbind(termSums,(as.numeric(termSums[,3])/sum(as.numeric(termSums[,3]))))
  # Calculate the natural log of the probabilities
  termSums<-cbind(termSums,log(as.numeric(termSums[,4])))
  # Add pretty names to the columns
  colnames(termSums)<-c("term","count","additive","probability","lnProbability")
  termSums
}

tweets.AC.pMatrix<-probabilityMatrix(tweets.AC.matrix)
tweets.ACBW.pMatrix<-probabilityMatrix(tweets.ACBW.matrix)
tweets.ACSF.pMatrix<-probabilityMatrix(tweets.ACSF.matrix)
#Predict

# Get the test matrix
# Get words in the first document

getProbability <- function(testChars,probabilityMatrix)
{
  charactersFound<-probabilityMatrix[probabilityMatrix[,1] %in% testChars,"term"]
  # Count how many words were not found in the mandrill matrix
  charactersNotFound<-length(testChars)-length(charactersFound)
  # Add the normalized probabilities for the words founds together
  charactersFoundSum<-sum(as.numeric(probabilityMatrix[probabilityMatrix[,1] %in% testChars,"lnProbability"]))
  # We use ln(1/total smoothed words) for words not found
  charactersNotFoundSum<-charactersNotFound*log(1/sum(as.numeric(probabilityMatrix[,"additive"])))
  #This is our probability
  prob<-charactersFoundSum+charactersNotFoundSum 
  prob
}

# Get the matrix
tweets.test.matrix<-as.matrix(tweets.test.matrix)

# A holder for classification 
classified<-NULL

for(documentNumber in 1:nrow(tweets.test.matrix))
{
  # Extract the test words
  tweets.test.chars<-names(tweets.test.matrix[documentNumber,tweets.test.matrix[documentNumber,] %in% 1])
  # Get the probabilities
  ACProbability <- getProbability(tweets.test.chars,tweets.AC.pMatrix)
  ACBWProbability <- getProbability(tweets.test.chars,tweets.ACBW.pMatrix)
  ACSFProbability <- getProbability(tweets.test.chars,tweets.ACSF.pMatrix)
  # Add it to the classification list
  classified<-c(classified,if(ACProbability>ACBWProbability && ACProbability>ACSFProbability){"AdmitCard"} else if(ACBWProbability>ACProbability && ACBWProbability>ACSFProbability) {"Fees"} else {"Ack"} )
}
i<-1
for(documentNumber in 1:nrow(tweets.test.matrix))
{ 
 if(classified[i]== "AdmitCard")
 {
   write.table(tweets.test$Tweet[i], file="abc.csv", append=T, row.names=F, col.names=F,  sep=",")
 }
  else if(classified[i]== "Fees")
  {
    write.table(tweets.test$Tweet[i], file="def.csv", append=T, row.names=F, col.names=F,  sep=",")
  }
else {
  write.table(tweets.test$Tweet[i], file="ghi.csv", append=T, row.names=F, col.names=F,  sep=",")
}
  i<-i+1
}
View(cbind(classified,tweets.test$Tweet))
#(accuracy <- sum(diag(tweets.test.matrix))/length(tweets.test.matrix) * 100)
#write.csv(cbind(classified,tweets.test$Tweet), file = "datac.csv")
