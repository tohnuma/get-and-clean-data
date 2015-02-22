##Getting and Cleaning Data Course Project

First, use the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 and name the folder with "data".
Second, use a file about("run_analysis.R") command in R. You can see the following flow of this program.

step1: Merges the training and the test sets to create one data set.
Read X_train.txt, y_train.txt and subject_train.txt, X_test.txt, y_test.txt and subject_test.txt from the data folder using read.table function. 
Conbine train and test data for x, y, and subject, respectively using rind function

#step2: Extracts only the measurements on the mean and standard deviation (SD) for each measurement. 
extract mean and SD from the join.x data frame

#step3: Uses descriptive activity names to name the activities in the data set
merge between activity file and activitiyLables in order to obtain the list of activities.

#step4: Appropriately labels the data set with descriptive variable names.
change the names using gsub function.

#step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
use melt and cast functions to calculate each varible for each activity and each subject
