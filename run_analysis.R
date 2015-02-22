setwd("UCI HAR Dataset")
library(gdata)
library(plyr)
#step1: Merges the training and the test sets to create one data set.
train.x <- read.table("train/x_train.txt") #dim: 7352 561
train.y <- read.table("train/y_train.txt") #dim: 7352 1
train.subject <- read.table("train/subject_train.txt") #dim: 7352 1
test.x <- read.table("test/x_test.txt") #dim: 2947 561
test.y <- read.table("test/y_test.txt") #dim: 2947 1
test.subject <- read.table("test/subject_test.txt") #dim: 2947 1
features <- read.table("features.txt") #dim: 561 2

join.x <- rbind(train.x, test.x) #dim: 10299 561
colnames(join.x) <- features[, 2] #add feature names
join.y <- rbind(train.y, test.y)
colnames(join.y) <- "Activity"
join.subject <- rbind(train.subject, test.subject)
colnames(join.subject) <- "subject"

#step2: Extracts only the measurements on the mean and standard deviation 
#for each measurement. 
mean_cols <- matchcols(join.x, with=c("mean"), without=c("meanFreq"))
std_cols  <- matchcols(join.x, with=c("std"))
newcol_vector <- c(mean_cols, std_cols)
newjoin.x <- join.x[, newcol_vector] #dim; 10299 66

#step3: Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt")
colnames(activityLabels)[1] <- "activityID"
act <- merge(join.y, activityLabels, by.x="Activity", by.y="activityID", all=TRUE)
activity<-act[,2]

#step4: Appropriately labels the data set with descriptive variable names.
names(newjoin.x) <- gsub("\\(\\)", "", names(newjoin.x)) # remove "()"
names(newjoin.x) <- gsub("mean", "Mean", names(newjoin.x)) # capitalize M
names(newjoin.x) <- gsub("std", "Std", names(newjoin.x)) # capitalize S
names(newjoin.x) <- gsub("-", "", names(newjoin.x)) # remove "-" in column names

#step5: From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject
allData <- cbind(newjoin.x, join.subject, Activity)

molten <- melt(allData,id.vars= c("subject","Activity"))  #create a long shaped dataset from a wide shaped dataset
cast <- dcast(molten, subject+Activity ~ variable, fun.aggregate=mean) #transform the long shaped dataset back into a wide shaped dataset, 
                                                                       #aggregating on subject and activity using the mean function

write.table(cast,file="tidy.txt", row.name=FALSE)
