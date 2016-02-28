#set working directory
#create a file
if(!file.exists("data")){dir.create("data")}
#download data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="data/UARUS.zip")
#unzip datasets
unzip("data/UARUS.zip", exdir="data")

#merge test data and train data
#import data
X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
#merge data
X_merge <- rbind(X_train, X_test)
y_merge <- rbind(y_train, y_test)
subject_merge <- rbind(subject_train, subject_test)
dataset <-list(X=X_merge, y=y_merge, subject=subject_merge)

#mean and standard deviation
datas_merged_mean <- sapply(features[,2], function(x) grepl("mean()",x, fixed=T))
datas_merged_std <- sapply(features[,2], function(x) grepl("std()",x, fixed=T))

#name activities
activities <- read.table("data/UCI HAR Dataset/activities_labels.txt")
names(activities) <- c('act_id', 'act_name')
y_merge[,1] = activities[y_merge[,1],2]
names(y_merge) <- "Activity"
names(subject_merge) <- "Subject"

tidydata <- cbind(subject_merge, y_merge, X_merge) 

#tidy data set w/ average of each variable for each activity and each subject
TD <- tidydata[,3:dim(tidydata)[2]]
tidydata_avg <- aggregate(TD, list(tidydata$Subject, tidydata$Activity), mean)

names(tidydata_avg)[1] <-"Subject"
names(tidydata_avg)[2] <-"Activity"

# export data
write.csv(tidydata, "UARUS_tidy.csv")