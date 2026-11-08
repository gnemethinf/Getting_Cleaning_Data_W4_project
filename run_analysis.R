#
# Project work for Coursera Course "Getting and Cleaning Data". 
# 
# Author: Gábor NÉMETH
# 
# Data available from: 
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# Tasks: 
#    1. Merges the training and the test sets to create one data set.
#
#    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#
#    3. Uses descriptive activity names to name the activities in the data set
#
#    4. Appropriately labels the data set with descriptive variable names. 
#
#    5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## install libraries
#install.packages('plyr')
#install.packages('stringr')
library(plyr)

#######################################################################
## Preparing data frame for training data
#######################################################################
train_dataset_X_file <- "data/train/X_train.txt"
train_dataset_y_file <- "data/train/y_train.txt"
train_subject_file <- "data/train/subject_train.txt"
feature_file <- "data/features.txt"
df_train <- read.table(train_dataset_X_file)
df_train_y <- read.table(train_dataset_y_file)
df_train_subject <- read.table(train_subject_file)
features <- read.table(feature_file)


train_column_names_X <- features$V2 ## getting feature names
train_column_names_y <- c("activityCode")
train_column_names_subject <- c("subject")

names(df_train) <- train_column_names_X   ## set names in data frame df_train
names(df_train_y) <- train_column_names_y ## set names in data frame df_train_y
names(df_train_subject) <- train_column_names_subject ## set names in data frame df_train_subject

# ## match the activity label to the activity code
# df_train_y_label <- ifelse(df_train_y$activityCode == 1, "WALKING", 
#                       ifelse(df_train_y$activityCode == 2, "WALKING_UPSTAIRS",
#                         ifelse(df_train_y$activityCode == 3, "WALKING_DOWNSTAIRS",
#                           ifelse(df_train_y$activityCode == 4, "SITTING",
#                             ifelse(df_train_y$activityCode == 5, "STANDING", "LAYING"))))) 
# #names(df_train_y_label) <- c("activityLabel")
# 
# df_train_activity <- cbind(df_train_y, df_train_y_label)
# names(df_train_activity) <- c("activityCode","activityLabel")


## put all the train data together into df_train data frame
df_train <- cbind(df_train_subject, df_train, df_train_y)

###################################################################
## Preparing data frame for test data
###################################################################

test_dataset_X_file <- "data/test/X_test.txt"
test_dataset_y_file <- "data/test/y_test.txt"
test_subject_file <- "data/test/subject_test.txt"
df_test <- read.table(test_dataset_X_file)
df_test_y <- read.table(test_dataset_y_file)
df_test_subject <- read.table(test_subject_file)

test_column_names_X <- features$V2 ## getting feature names
test_column_names_y <- c("activityCode")
test_column_names_subject <- c("subject")

names(df_test) <- test_column_names_X   ## set names in data frame df_test
names(df_test_y) <- test_column_names_y ## set names in data frame df_test_y
names(df_test_subject) <- test_column_names_subject ## set names in data frame df_test_subject

# ## match the activity label to the activity code
# df_test_y_label <- ifelse(df_test_y$activityCode == 1, "WALKING", 
#                       ifelse(df_test_y$activityCode == 2, "WALKING_UPSTAIRS",
#                         ifelse(df_test_y$activityCode == 3, "WALKING_DOWNSTAIRS",
#                           ifelse(df_test_y$activityCode == 4, "SITTING",
#                             ifelse(df_test_y$activityCode == 5, "STANDING", "LAYING"))))) 
# 
# df_test_activity <- cbind(df_test_y, df_test_y_label)
# names(df_test_activity) <- c("activityCode","activityLabel")

## put all the test data together into df_train data frame
df_test <- cbind(df_test_subject, df_test, df_test_y)

#################################################################################
## 1. Merge training and test sets to create one data set
#################################################################################

df_train_test <- rbind(df_train, df_test)

##################################################################################
## 2. Extract only the measurement on the mean and standard deviation measurement
##################################################################################

mean_col_names <- grep("*mean*", names(df_train_test))
std_col_names <- grep("*std*", names(df_train_test))

mean_std_col_names <- names(df_train_test)[sort(c(mean_col_names, std_col_names))]

df_train_test_mean_std <- df_train_test[c("subject", mean_std_col_names, "activityCode")]

################################################################################
## 3. Uses descriptive activity names to name the activities in the data set
################################################################################

activity_label_file <- "data/activity_labels.txt"
activity_labels <- read.table(activity_label_file)
names(activity_labels) <- c("activityCode", "activityLabel")

df_train_test_mean_std_activity <- join(df_train_test_mean_std, activity_labels, by="activityCode")

################################################################################
## 4. Appropriately labels the data set with descriptive variable names. 
################################################################################
## Note: it has been prepared with descriptive variable names in preparing section

## change '-' to underscore '_' in names
names2 <- gsub('-','_',names(df_train_test_mean_std_activity))
names(df_train_test_mean_std_activity) <- names2
names3 <- gsub("[()]","",names(df_train_test_mean_std_activity))
#names3 <- gsub(')','',names3)
names(df_train_test_mean_std_activity) <- names3


################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
################################################################################
library(plyr)
#df_train_test_mean_std_activity_group_by <- group_by(df_train_test_mean_std_activity, 
#                                                     "subject", "activity")

by_activity_subject <- df_train_test_mean_std_activity |> group_by(activityCode, activityLabel, subject) # |> summarize(.by=c(activityCode, activityLabel, subject))

avg_by_activity_subject <- df_train_test_mean_std_activity |> 
  summarize(.by=c(activityCode, activityLabel, subject), 
            avg_tBodyAcc_mean_X = mean(tBodyAcc_mean_X, na.rm = TRUE),
            avg_tBodyAcc_mean_Y = mean(tBodyAcc_mean_Y, na.rm = TRUE),
            avg_tBodyAcc_mean_Z = mean(tBodyAcc_mean_Z, na.rm = TRUE),
            avg_tBodyAcc_std_X = mean(tBodyAcc_std_X, na.rm = TRUE),
            avg_tBodyAcc_std_Y = mean(tBodyAcc_std_Y, na.rm = TRUE),
            avg_tBodyAcc_std_Z = mean(tBodyAcc_std_Z, na.rm = TRUE),
            avg_tGravityAcc_mean_X = mean(tGravityAcc_mean_X, na.rm = TRUE),
            avg_tGravityAcc_mean_Y = mean(tGravityAcc_mean_Y, na.rm = TRUE),
            avg_tGravityAcc_mean_Z = mean(tGravityAcc_mean_Z, na.rm = TRUE),
            avg_tGravityAcc_std_X = mean(tGravityAcc_std_X, na.rm = TRUE),
            avg_tGravityAcc_std_Y = mean(tGravityAcc_std_Y, na.rm = TRUE),
            avg_tGravityAcc_std_Z = mean(tGravityAcc_std_Z, na.rm = TRUE),
            avg_tBodyAccJerk_mean_X = mean(tBodyAccJerk_mean_X, na.rm = TRUE),
            avg_tBodyAccJerk_mean_Y = mean(tBodyAccJerk_mean_Y, na.rm = TRUE),
            avg_tBodyAccJerk_mean_Z = mean(tBodyAccJerk_mean_Z, na.rm = TRUE),
            avg_tBodyAccJerk_std_X = mean(tBodyAccJerk_std_X, na.rm = TRUE),
            avg_tBodyAccJerk_std_Y = mean(tBodyAccJerk_std_Y, na.rm = TRUE),
            avg_tBodyAccJerk_std_Z = mean(tBodyAccJerk_std_Z, na.rm = TRUE),
            avg_tBodyGyro_mean_X = mean(tBodyGyro_mean_X, na.rm = TRUE),
            avg_tBodyGyro_mean_Y = mean(tBodyGyro_mean_Y, na.rm = TRUE),
            avg_tBodyGyro_mean_Z = mean(tBodyGyro_mean_Z, na.rm = TRUE),
            avg_tBodyGyro_std_X = mean(tBodyGyro_std_X, na.rm = TRUE),
            avg_tBodyGyro_std_Y = mean(tBodyGyro_std_Y, na.rm = TRUE),
            avg_tBodyGyro_std_Z = mean(tBodyGyro_std_Z, na.rm = TRUE),
            avg_tBodyGyroJerk_mean_X = mean(tBodyGyroJerk_mean_X, na.rm = TRUE),
            avg_tBodyGyroJerk_mean_Y = mean(tBodyGyroJerk_mean_Y, na.rm = TRUE),
            avg_tBodyGyroJerk_mean_Z = mean(tBodyGyroJerk_mean_Z, na.rm = TRUE),
            avg_tBodyGyroJerk_std_X = mean(tBodyGyroJerk_std_X, na.rm = TRUE),
            avg_tBodyGyroJerk_std_Y = mean(tBodyGyroJerk_std_Y, na.rm = TRUE),
            avg_tBodyGyroJerk_std_Z = mean(tBodyGyroJerk_std_Z, na.rm = TRUE),
            avg_tBodyAccMag_mean = mean(tBodyAccMag_mean, na.rm = TRUE),
            avg_tBodyAccMag_std = mean(tBodyAccMag_std, na.rm = TRUE),
            avg_tGravityAccMag_mean = mean(tGravityAccMag_mean, na.rm = TRUE),
            avg_tGravityAccMag_std = mean(tGravityAccMag_std, na.rm = TRUE),
            avg_tBodyAccJerkMag_mean = mean(tBodyAccJerkMag_mean, na.rm = TRUE),
            avg_tBodyAccJerkMag_std = mean(tBodyAccJerkMag_std, na.rm = TRUE),
            avg_tBodyGyroMag_mean = mean(tBodyGyroMag_mean, na.rm = TRUE),
            avg_tBodyGyroMag_std = mean(tBodyGyroMag_std, na.rm = TRUE),
            avg_tBodyGyroJerkMag_mean = mean(tBodyGyroJerkMag_mean, na.rm = TRUE),
            avg_tBodyGyroJerkMag_std = mean(tBodyGyroJerkMag_std, na.rm = TRUE),
            avg_fBodyAcc_mean_X = mean(fBodyAcc_mean_X, na.rm = TRUE),
            avg_fBodyAcc_mean_Y = mean(fBodyAcc_mean_Y, na.rm = TRUE),
            avg_fBodyAcc_mean_Z = mean(fBodyAcc_mean_Z, na.rm = TRUE),
            avg_fBodyAcc_std_X = mean(fBodyAcc_std_X, na.rm = TRUE),
            avg_fBodyAcc_std_Y = mean(fBodyAcc_std_Y, na.rm = TRUE),
            avg_fBodyAcc_std_Z = mean(fBodyAcc_std_Z, na.rm = TRUE),
            avg_fBodyAcc_meanFreq_X = mean(fBodyAcc_meanFreq_X, na.rm = TRUE),
            avg_fBodyAcc_meanFreq_Y = mean(fBodyAcc_meanFreq_Y, na.rm = TRUE),
            avg_fBodyAcc_meanFreq_Z = mean(fBodyAcc_meanFreq_Z, na.rm = TRUE),
            avg_fBodyAccJerk_mean_X = mean(fBodyAccJerk_mean_X, na.rm = TRUE),
            avg_fBodyAccJerk_mean_Y = mean(fBodyAccJerk_mean_Y, na.rm = TRUE),
            avg_fBodyAccJerk_mean_Z = mean(fBodyAccJerk_mean_Z, na.rm = TRUE),
            avg_fBodyAccJerk_std_X = mean(fBodyAccJerk_std_X, na.rm = TRUE),
            avg_fBodyAccJerk_std_Y = mean(fBodyAccJerk_std_Y, na.rm = TRUE),
            avg_fBodyAccJerk_std_Z = mean(fBodyAccJerk_std_Z, na.rm = TRUE),
            avg_fBodyAccJerk_meanFreq_X = mean(fBodyAccJerk_meanFreq_X, na.rm = TRUE),
            avg_fBodyAccJerk_meanFreq_Y = mean(fBodyAccJerk_meanFreq_Y, na.rm = TRUE),
            avg_fBodyAccJerk_meanFreq_Z = mean(fBodyAccJerk_meanFreq_Z, na.rm = TRUE),
            avg_fBodyGyro_mean_X = mean(fBodyGyro_mean_X, na.rm = TRUE),
            avg_fBodyGyro_mean_Y = mean(fBodyGyro_mean_Y, na.rm = TRUE),
            avg_fBodyGyro_mean_Z = mean(fBodyGyro_mean_Z, na.rm = TRUE),
            avg_fBodyGyro_std_X = mean(fBodyGyro_std_X, na.rm = TRUE),
            avg_fBodyGyro_std_Y = mean(fBodyGyro_std_Y, na.rm = TRUE),
            avg_fBodyGyro_std_Z = mean(fBodyGyro_std_Z, na.rm = TRUE),
            avg_fBodyGyro_meanFreq_X = mean(fBodyGyro_meanFreq_X, na.rm = TRUE),
            avg_fBodyGyro_meanFreq_Y = mean(fBodyGyro_meanFreq_Y, na.rm = TRUE),
            avg_fBodyGyro_meanFreq_Z = mean(fBodyGyro_meanFreq_Z, na.rm = TRUE),
            avg_fBodyAccMag_mean = mean(fBodyAccMag_mean, na.rm = TRUE),
            avg_fBodyAccMag_std = mean(fBodyAccMag_std, na.rm = TRUE),
            avg_fBodyAccMag_meanFreq = mean(fBodyAccMag_meanFreq, na.rm = TRUE),
            avg_fBodyBodyAccJerkMag_mean = mean(fBodyBodyAccJerkMag_mean, na.rm = TRUE),
            avg_fBodyBodyAccJerkMag_std = mean(fBodyBodyAccJerkMag_std, na.rm = TRUE),
            avg_fBodyBodyAccJerkMag_meanFreq = mean(fBodyBodyAccJerkMag_meanFreq, na.rm = TRUE),
            avg_fBodyBodyGyroMag_mean = mean(fBodyBodyGyroMag_mean, na.rm = TRUE),
            avg_fBodyBodyGyroMag_std = mean(fBodyBodyGyroMag_std, na.rm = TRUE),
            avg_fBodyBodyGyroMag_meanFreq = mean(fBodyBodyGyroMag_meanFreq, na.rm = TRUE),
            avg_fBodyBodyGyroJerkMag_mean = mean(fBodyBodyGyroJerkMag_mean, na.rm = TRUE),
            avg_fBodyBodyGyroJerkMag_std = mean(fBodyBodyGyroJerkMag_std, na.rm = TRUE),
            avg_fBodyBodyGyroJerkMag_meanFreq = mean(fBodyBodyGyroJerkMag_meanFreq, na.rm = TRUE))


write.table(avg_by_activity_subject, "tidy_dataset.txt", row.names=FALSE)

