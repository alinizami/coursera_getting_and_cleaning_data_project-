
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

