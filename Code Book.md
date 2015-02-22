##Code book

#step1: Merges the training and the test sets to create one data set.
train.x <- "train/x_train.txt"
train.y <- "train/y_train.txt" 
train.subject <- ("train/subject_train.txt" 
test.x <- "test/x_test.txt"
test.y <- "test/y_test.txt"
test.subject <- "test/subject_test.txt" 
features <- "features.txt" 

join.x <- rbind(train.x, test.x) 
join.y <- rbind(train.y, test.y)
join.subject <- rbind(train.subject, test.subject)

#step2: Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_cols <- matchcols(join.x, with=c("mean"), without=c("meanFreq"))
std_cols  <- matchcols(join.x, with=c("std"))
newcol_vector <- c(mean_cols, std_cols)
newjoin.x <- join.x[, newcol_vector]

#step3: Uses descriptive activity names to name the activities in the data set
activityLabels <- "activity_labels.txt"
act <- merge(join.y, activityLabels, by.x="Activity", by.y="activityID", all=TRUE)
activity<-act[,2]

#step4: Appropriately labels the data set with descriptive variable names.
names(newjoin.x) <- gsub("\\(\\)", "", names(newjoin.x)) # remove "()"
names(newjoin.x) <- gsub("mean", "Mean", names(newjoin.x)) # capitalize M
names(newjoin.x) <- gsub("std", "Std", names(newjoin.x)) # capitalize S
names(newjoin.x) <- gsub("-", "", names(newjoin.x)) # remove "-" in column names

#step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
allData <- cbind(newjoin.x, join.subject, Activity)

molten <- melt(allData,id.vars= c("subject","Activity"))  
cast <- dcast(molten, subject+Activity ~ variable, fun.aggregate=mean) 

write.table(cast,file="tidy.txt", row.name=FALSE)