## Download data in the current working directory
dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataFile, "UCI-HAR-dataset.zip", method="curl")
unzip("assignment/UCI-HAR-dataset.zip")

## read all relevant data in R
##4.Appropriately labels the data set with descriptive variable names
features<-read.table("./UCI HAR Dataset/features.txt")
activ.lables<-read.table("./UCI HAR Dataset/activity_labels.txt")
test.data<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names=features[,2])
test.lable<-read.table("./UCI HAR Dataset/test/Y_test.txt",col.names="lable")
test.subjects<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names="subjects")
train.data<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names=features[,2])
train.lables<-read.table("./UCI HAR Dataset/train/Y_train.txt",col.names="lable")
train.subjects<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names="subjects")

## 1.Merge the training and the test sets to create one data set.
test<-cbind(test.data, test.lable, test.subjects)
train<-cbind(train.data,train.lables, train.subjects)
dataset<-rbind(test, train)

##2.Extract only the measurements on the mean and standard deviation for each measurement. 
mean_std <- features[grep("mean|std", features[,2]),]
mean_std_dataset<-dataset[,mean_std$V1]

##3.Use descriptive activity names to name the activities in the data set
tolower(activ.lables$V2)
dataset$activity <- as.factor(dataset$lable)
levels(dataset$activity) <- activ.lables$V2

##4.(At the beginning)
##5.Creates a second, independent tidy data set with the average of each variable 
##  for each activity and each subject.
library(dplyr)
tidy_dataset<-summarise_each(group_by(dataset, subjects, activity), "mean")
write.table(tidy_dataset, file = "./UCI HAR Dataset/tidy_data.txt", row.name=False)
