library(tm)

# Collect data
tweets.AC<-read.csv('E:/xampp/htdocs/FYP/web/AC.csv',header=T)
tweets.AP<-read.csv('E:/xampp/htdocs/FYP/web/AP.csv',header=T)
tweets.FC<-read.csv('E:/xampp/htdocs/FYP/web/FC.csv',header=T)
tweets.FP<-read.csv('E:/xampp/htdocs/FYP/web/FP.csv',header=T)
tweets.FR<-read.csv('E:/xampp/htdocs/FYP/web/FR.csv',header=T)
tweets.MS<-read.csv('E:/xampp/htdocs/FYP/web/MS.csv',header=T)
tweets.TID<-read.csv('E:/xampp/htdocs/FYP/web/TID.csv',header=T)
tweets.other<-read.csv('E:/xampp/htdocs/FYP/web/others.csv',header=T)
tweets.test<-read.csv('E:/xampp/htdocs/FYP/web/testing.csv',header=T)

tweets.AC["class"]<-rep("AC",nrow(tweets.AC))
tweets.AP["class"]<-rep("AP",nrow(tweets.AP))
tweets.FC["class"]<-rep("FC",nrow(tweets.FC))
tweets.FP["class"]<-rep("FP",nrow(tweets.FP))
tweets.FR["class"]<-rep("FR",nrow(tweets.FR))
tweets.MS["class"]<-rep("MS",nrow(tweets.MS))
tweets.other["class"]<-rep("other",nrow(tweets.other))
tweets.TID["class"]<-rep("TID",nrow(tweets.TID))

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
tweets.AP$Tweet <- replacePunctuation(tweets.AP$Tweet)
tweets.FC$Tweet <- replacePunctuation(tweets.FC$Tweet)
tweets.FP$Tweet <- replacePunctuation(tweets.FP$Tweet)
tweets.FR$Tweet <- replacePunctuation(tweets.FR$Tweet)
tweets.MS$Tweet <- replacePunctuation(tweets.MS$Tweet)
tweets.TID$Tweet <- replacePunctuation(tweets.TID$Tweet)
tweets.other$Tweet <- replacePunctuation(tweets.other$Tweet)
tweets.test$Tweet <- replacePunctuation(tweets.test$Tweet)

# Create corpus
tweets.AC.corpus <- Corpus(VectorSource(as.vector(tweets.AC$Tweet)))
tweets.AP.corpus <- Corpus(VectorSource(as.vector(tweets.AP$Tweet)))
tweets.FC.corpus <- Corpus(VectorSource(as.vector(tweets.FC$Tweet)))
tweets.FP.corpus <- Corpus(VectorSource(as.vector(tweets.FP$Tweet)))
tweets.FR.corpus <- Corpus(VectorSource(as.vector(tweets.FR$Tweet)))
tweets.MS.corpus <- Corpus(VectorSource(as.vector(tweets.MS$Tweet)))
tweets.other.corpus <- Corpus(VectorSource(as.vector(tweets.other$Tweet)))
tweets.TID.corpus <- Corpus(VectorSource(as.vector(tweets.TID$Tweet)))
tweets.test.corpus <- Corpus(VectorSource(as.vector(tweets.test$Tweet)))

# Create term document matrix
tweets.AC.matrix <- t(TermDocumentMatrix(tweets.AC.corpus,control = list(wordLengths=c(3,Inf))));
tweets.AP.matrix <- t(TermDocumentMatrix(tweets.AP.corpus,control = list(wordLengths=c(3,Inf))));
tweets.FC.matrix <- t(TermDocumentMatrix(tweets.FC.corpus,control = list(wordLengths=c(3,Inf))));
tweets.FP.matrix <- t(TermDocumentMatrix(tweets.FP.corpus,control = list(wordLengths=c(3,Inf))));
tweets.FR.matrix <- t(TermDocumentMatrix(tweets.FR.corpus,control = list(wordLengths=c(3,Inf))));
tweets.other.matrix <- t(TermDocumentMatrix(tweets.other.corpus,control = list(wordLengths=c(3,Inf))));
tweets.MS.matrix <- t(TermDocumentMatrix(tweets.MS.corpus,control = list(wordLengths=c(3,Inf))));
tweets.TID.matrix <- t(TermDocumentMatrix(tweets.TID.corpus,control = list(wordLengths=c(3,Inf))));
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
tweets.AP.pMatrix<-probabilityMatrix(tweets.AP.matrix)
tweets.FP.pMatrix<-probabilityMatrix(tweets.FP.matrix)
tweets.FC.pMatrix<-probabilityMatrix(tweets.FC.matrix)
tweets.FR.pMatrix<-probabilityMatrix(tweets.FR.matrix)
tweets.MS.pMatrix<-probabilityMatrix(tweets.MS.matrix)
tweets.TID.pMatrix<-probabilityMatrix(tweets.TID.matrix)
tweets.other.pMatrix<-probabilityMatrix(tweets.other.matrix)
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
  APProbability <- getProbability(tweets.test.chars,tweets.AP.pMatrix)
  FPProbability <- getProbability(tweets.test.chars,tweets.FP.pMatrix)
  FCProbability <- getProbability(tweets.test.chars,tweets.FC.pMatrix)
  FRProbability <- getProbability(tweets.test.chars,tweets.FR.pMatrix)
  MSProbability <- getProbability(tweets.test.chars,tweets.MS.pMatrix)
  TIDProbability <- getProbability(tweets.test.chars,tweets.TID.pMatrix)
  otherProbability <- getProbability(tweets.test.chars,tweets.other.pMatrix)
  
  # Add it to the classification list
  classified<-c(classified,if(ACProbability>APProbability && ACProbability>MSProbability && ACProbability>FCProbability && ACProbability>FPProbability && ACProbability>FRProbability && ACProbability>TIDProbability && ACProbability>otherProbability){"This is Simple AdmitCard Query"}
                else if(APProbability>ACProbability && APProbability>MSProbability && APProbability>FCProbability && APProbability>FPProbability && APProbability>FRProbability && APProbability>TIDProbability && APProbability>otherProbability){"This is Admit photograph Query"}
                else if(FCProbability>ACProbability && FCProbability>APProbability && FCProbability>MSProbability && FCProbability>FPProbability && FCProbability>FRProbability && FCProbability>TIDProbability && FCProbability>otherProbability){"This is Simple Fees Query"}
                else if(FRProbability>ACProbability && FRProbability>APProbability && FRProbability>MSProbability  && FRProbability>FPProbability && FRProbability>FCProbability && FRProbability>TIDProbability && FRProbability>otherProbability){"This is Fees Refund Query"} 
                else if(FPProbability>ACProbability && FPProbability>APProbability && FPProbability>MSProbability && FPProbability>FRProbability && FPProbability>FCProbability && FPProbability>TIDProbability && FPProbability>otherProbability){"This is Fees Payment Query"}
                else if(TIDProbability>ACProbability && TIDProbability>APProbability && TIDProbability>FPProbability && TIDProbability>MSProbability && TIDProbability>FRProbability && TIDProbability>FCProbability && TIDProbability>otherProbability){"This is Transaction ID Query"}
                else if(MSProbability>ACProbability && MSProbability>APProbability && MSProbability>FPProbability && MSProbability>TIDProbability && MSProbability>FRProbability && MSProbability>FCProbability && MSProbability>otherProbability){"This is Admit card Query related to Marksheet"}
                else {"This is outlier"})  
}

View(cbind(classified,tweets.test$Tweet))
(accuracy <- sum(diag(tweets.test.matrix))/length(tweets.test.matrix) * 100)
write.csv(cbind(classified,tweets.test$Tweet), file = "E:/xampp/htdocs/FYP/web/datac.csv")

