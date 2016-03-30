##Create data folder
if(!file.exists("./data")){dir.create("./data")}

#download zip file under data folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Data.zip")


#Unzip the files under "UCI HAR Dataset" folder
unzip(zipfile="./data/Data.zip",exdir="./data")


#Get the list of the files that UCI HAR Dataset contains

files <- list.files(file.path("./data", "UCI HAR Dataset"), recursive = TRUE)


#Read test, train and features files.
activityTest  <- read.table("./data/UCI HAR Dataset/test/Y_test.txt", header = FALSE)
activityTrain  <- read.table("./data/UCI HAR Dataset/train/Y_train.txt", header = FALSE)
subjectTest  <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",header = FALSE)
featuresTest  <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)


#Look at the data table
str(activityTest)
str(activityTrain)
head(subjectTest,2)
head(subjectTrain,2)
head(featuresTest,2)
head(featuresTrain,2)


#Merging the training and the test sets to create one data set
activityData<- rbind(activityTrain, activityTest)
subjectData <- rbind(subjectTrain, subjectTest)
featuresData<- rbind(featuresTrain, featuresTest)


#Setting names to variables
names(subjectData)<-c("subject")
names(activityData)<- c("activity")
featuresDataNames <- read.table("./data/UCI HAR Dataset/features.txt", header=FALSE)
names(featuresData)<- featuresDataNames$V2

#Merging columns to get data frame
combinedData <- cbind(dataSubject, dataActivity)
Data <- cbind(featuresData, combinedData)

#Extract only the measurements on the mean and standard deviation for each measurement
subfeaturesDataNames<-featuresDataNames$V2[grep("mean\\(\\)|std\\(\\)", featuresDataNames$V2)]
selectedNames<-c(as.character(subfeaturesDataNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Using descriptive activity names to name the activities in the data set
#Mercing data set adding labels
activityLabel <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)


#Turning activities and subject into factors
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)


#Appropriately labeling the data set with descriptive variable names
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))


#Creating a second independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
finalData<-aggregate(. ~subject + activity, Data, mean)
finalData<-finalData[order(finalData$subject,finalData$activity),]
write.table(finalData, file = "tidydata.txt",row.name=FALSE)


