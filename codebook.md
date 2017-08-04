---
title: "CodeBook"
output: github_document
---

```{}
This codebook describes the transformations performed in the run_analysis.R file to get the tidy data set requested in the course project. 
```

## Transformation Steps
```{}
loading X test and train sets into R
loading features from the file features.txt and subsetting the data sets for mean and std
loading y sets from the file y_train.txt and y_test.txt
loading activity look up and merging with y data set from the file activity_labels.txt
merging activities with the main data set
setting column names  for merged data set
loading subjects and merging with our final data set using cbind
subsetting for task 4, getting averages on activity and subjects and taking the mean of the measurements. this was done using the ddply function
writing result to a csv file called tidy.csv
```

## Variables
```{}
Activity 
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

Subject
identifies the subject who performed the activity . Its range is from 1 to 30
```


## Measurements
```{}
tBodyAccMeanX
tBodyAccMeanY 
tBodyAccMeanZ 
tBodyAccStdX
tBodyAccStdY
tBodyAccStdZ
tGravityAccMeanX
tGravityAccMeanY
tGravityAccMeanZ
tGravityAccStdX
tGravityAccStdY
tGravityAccStdZ
tBodyAccJerkMeanX
tBodyAccJerkMeanY
tBodyAccJerkMeanZ
tBodyAccJerkStdX
tBodyAccJerkStdY
tBodyAccJerkStdZ
tBodyGyroMeanX
tBodyGyroMeanY
tBodyGyroMeanZ
tBodyGyroStdX
tBodyGyroStdY
tBodyGyroStdZ
tBodyGyroJerkMeanX
tBodyGyroJerkMeanY
tBodyGyroJerkMeanZ
tBodyGyroJerkStdX
tBodyGyroJerkStdY
tBodyGyroJerkStdZ
tBodyAccMagMean
tBodyAccMagStd
tGravityAccMagMean
tGravityAccMagStd
tBodyAccJerkMagMean
tBodyAccJerkMagStd
tBodyGyroMagMean
tBodyGyroMagStd
tBodyGyroJerkMagMean
tBodyGyroJerkMagStd
fBodyAccMeanX
fBodyAccMeanY
fBodyAccMeanZ
fBodyAccStdX
fBodyAccStdY
fBodyAccStdZ
fBodyAccMeanFreqX
fBodyAccMeanFreqY
fBodyAccMeanFreqZ
fBodyAccJerkMeanX
fBodyAccJerkMeanY
fBodyAccJerkMeanZ
fBodyAccJerkStdX
fBodyAccJerkStdY
fBodyAccJerkStdZ
fBodyAccJerkMeanFreqX
fBodyAccJerkMeanFreqY
fBodyAccJerkMeanFreqZ
fBodyGyroMeanX
fBodyGyroMeanY
fBodyGyroMeanZ
fBodyGyroStdX
fBodyGyroStdY
fBodyGyroStdZ
fBodyGyroMeanFreqX
fBodyGyroMeanFreqY
fBodyGyroMeanFreqZ
fBodyAccMagMean
fBodyAccMagStd
fBodyAccMagMeanFreq
fBodyBodyAccJerkMagMean
fBodyBodyAccJerkMagStd
fBodyBodyAccJerkMagMeanFreq
fBodyBodyGyroMagMean
fBodyBodyGyroMagStd
fBodyBodyGyroMagMeanFreq
fBodyBodyGyroJerkMagMean
fBodyBodyGyroJerkMagStd
fBodyBodyGyroJerkMagMeanFreq
```

## Including Code

```{}

## train data
library(reshape2)
library(plyr)

## loading test and train sets

x_train<-read.table("./data/UCI_HAR_Dataset/train/X_train.txt")
x_test<-read.table("./data/UCI_HAR_Dataset/test/X_test.txt")

merge_set<-rbind(x_train,x_test)

## loading features and subsetting the data sets for mean and std

x_features<-read.table("./data/UCI_HAR_Dataset/features.txt")
features<-x_features[,2]
merge_set_2<-merge_set[,grepl("mean|std",tolower( features))]


## loading y sets 
y_train<-read.table("./data/UCI_HAR_Dataset/train/y_train.txt")
y_test<-read.table("./data/UCI_HAR_Dataset/test/y_test.txt")
colnames(y_train)<-"activity"
colnames(y_test)<-"activity"

Y_set<- rbind(y_train,y_test)

## loading activity look up and merging with y data set
activity_labels<-read.table("./data/UCI_HAR_Dataset/activity_labels.txt")


activity_lookup<-merge(Y_set,activity_labels ,by.x = "activity", by.y = "V1", all = FALSE)


## merging activities with data set
merge_set_final<- cbind(merge_set_2,activity_lookup$V2)


## setting column names  for merged data set
colnames(merge_set_final)<- features[ grepl("mean|std",tolower( features))]

colnames(merge_set_final)[87]<-"activity"

## loading subjects
train_subject<-read.table("./data/UCI_HAR_Dataset/train/subject_train.txt")
test_subject<-read.table("./data/UCI_HAR_Dataset/test/subject_test.txt")


subject<-rbind(train_subject,test_subject)

## merging subjects with data set
merge_set_final2<-cbind(merge_set_final,subject)
colnames(merge_set_final2)[88]<-"subject"


## subsetting for task 4, getting averages on activity and subjects
average_data_set <- ddply(merge_set_final2, .(subject, activity), function(x) colMeans(x[, 1:86]))

write.table(average_data_set,"./data/tidy.csv", sep = ",")

```


