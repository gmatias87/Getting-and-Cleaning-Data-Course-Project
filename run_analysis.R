library(data.table)

## download data for analysis
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
          download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
          unzip("UCI HAR Dataset.zip", exdir = getwd())
}

features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
ytrain <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
trainsubject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

data.train <-  data.frame(trainsubject, ytrain, xtrain)
names(data.train) <- c(c('subject', 'activity'), features)

xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
ytest <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
testsubject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(testsubject, ytest, xtest)
names(data.test) <- c(c('subject', 'activity'), features)

data.complete <- rbind(data.train, data.test)

meanstd <- grep('mean|std', features)
data1 <- data.complete[,c(1,2,meanstd + 2)]

activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activitylabels <- as.character(activitylabels[,2])
data1$activity <- activitylabels[data1$activity]

col.name <- names(data1)
col.name <- gsub("[(][)]", "", col.name)
col.name <- gsub("^t", "TimeDomain_", col.name)
col.name <- gsub("^f", "FrequencyDomain_", col.name)
col.name <- gsub("Acc", "Accelerometer", col.name)
col.name <- gsub("Gyro", "Gyroscope", col.name)
col.name <- gsub("Mag", "Magnitude", col.name)
col.name <- gsub("-mean-", "_Mean_", col.name)
col.name <- gsub("-std-", "_StandardDeviation_", col.name)
col.name <- gsub("-", "_", col.name)
names(data1) <- col.name

data.ready <- aggregate(data1[,3:81], by = list(activity = data1$activity, subject = data1$subject),FUN = mean)
write.table(x = data.ready, file = "data.ready.txt", row.names = FALSE)