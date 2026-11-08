# Codebook for Getting and Cleaning Data Week4 Project

This project is a Coursera Course project for course "Getting and Cleaning Data".

## Original data

Original datasource [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


## Transformation

### Preparing and reading data from TXT files 

There are two folder in `data` folder, `train` and `test`. Furthermore, there are some other TXT files, that contains features. 
The `data` folder contains original files from the data source linked above. 

Train and test data (i.e., `data/train/X_train.txt` and `data/test/X_test.txt`, respectively) have the same structure. Both of them contains 563 columns.
Variable names for these columns are listed in `data/features.txt`. The same process has been applied for train and test data, 
here only for the training data is detailed.
Subjects are listed in `data/train/subject_train.txt` file. The activity codes (1,..,6) are listed in `data/train/y_train.txt`. 
In both of the three files (i.e., `X_train.txt`, `y_train.txt`, and `subject_train.txt`) are the same number of records, corresponding to each other.

  1. Reading the train data into an R data frame (`df_train`). Reading the features names from `data/features.txt` and set them as the names for `df_train`.
  2. Reading the activity codes from `data/train/y_train.txt` file into `df_train_y` and set the name for the column as `activityCode`.
  3. Reading the subjects from `data/train/subject_train.txt` file into `df_train_subject` and set the name for the column as `subject`.
  4. Concatenate all the columns from the three (i.e., `df_train`, `df_train_y`, `df_train_subject`) dataframe into one `df_train` data frame.
  
The four steps above are applied also for the test data set. The test data set is stored in `df_test` data frame. 

### Step 1. Merging the training and the test sets to create one data set.

Since `df_train` and `df_test` data frames have the same number and pairwise corresponding columns, we can merge them concatenating the rows `df_test` after the last row of `df_train`.
The result data frame is called `df_train_test`.

## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

From `df_train_test` data frame, those columns where the column name contains "mean" or  "std", furthermore the columns of "subject" and "activityCode" are
extracted into `df_train_test_mean_std_activity` data frame. 

## Step 3. Uses descriptive activity names to name the activities in the data set.

In file `data/activity_labels.txt` are listed six activity labels according to the six activity codes. 
  
  | Code | Label               | 
  |:-----|:--------------------|
  | 1    | WALKING             |
  | 2    | WALKING_UPSTAIRS    |
  | 3    | WALKING_DOWNSTAIRS  |
  | 4    | SITTING             |
  | 5    | STANDING            |
  | 6    | LAYING              |
  
  The file content from `data/activity_labels.txt` are read into `activity_labels` data frame. 
  Then, the `df_train_test_mean_std_activity` and `activity_labels` are (left) joined by the `activityCode` columns.
  
## Step 4. Appropriately labels the data set with descriptive variable names. 

Most of the variable names are descriptive thank to the previous steps. In this step the parentheses are removed from the column names, and dash '-' character are replaced to underscore '_'.

## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Here we use the `plyr` package. 

In the `df_train_test_mean_std_activity` data frame the averages of the measurements are computed for each measurement grouped by `activityCode`, `activityLabel` and `subject`. 
Unfortunately, I have not found an elegant way to summarize them, hence all the new aggregated features are listed into a new data frame. 

  | Variable                        | Description                                            |
  |:------------------------------- |:-------------------------------------------------------|
  | avg_tBodyAcc_mean_X             | Mean of the values of tBodyAcc_mean_X feature          |
  | avg_tBodyAcc_mean_Y             | Mean of the values of tBodyAcc_mean_Y feature          |
  | avg_tBodyAcc_mean_Z             | Mean of the values of tBodyAcc_mean_Z feature          |
  | avg_tBodyAcc_std_X              | Mean of the values of tBodyAcc_std_X feature          |
  | avg_tBodyAcc_std_Y              | Mean of the values of tBodyAcc_std_Y feature          |
  | avg_tBodyAcc_std_Z              | Mean of the values of tBodyAcc_std_Z feature          |
  | avg_tGravityAcc_mean_X          | Mean of the values of tGravityAcc_mean_X feature          |
  | avg_tGravityAcc_mean_Y          | Mean of the values of ttGravityAcc_mean_Y feature          |
  | avg_tGravityAcc_mean_Z          | Mean of the values of tGravityAcc_mean_Z feature          |
  | avg_tGravityAcc_std_X           | Mean of the values of tGravityAcc_std_X feature          |
  | avg_tGravityAcc_std_Y           | Mean of the values of tGravityAcc_std_Y feature          |
  | avg_tGravityAcc_std_Z           | Mean of the values of tGravityAcc_std_Z feature          |
  | avg_tBodyAccJerk_mean_X         | Mean of the values of tBodyAccJerk_mean_X feature          |
  | avg_tBodyAccJerk_mean_Y         | Mean of the values of tBodyAccJerk_mean_Y feature          |
  | avg_tBodyAccJerk_mean_Z         | Mean of the values of tBodyAccJerk_mean_Z feature          |
  | avg_tBodyAccJerk_std_X          | Mean of the values of tBodyAccJerk_std_X feature          |
  | avg_tBodyAccJerk_std_Y          | Mean of the values of tBodyAccJerk_std_Y feature          |
  | avg_tBodyAccJerk_std_Z          | Mean of the values of tBodyAccJerk_std_Z feature          |
  | avg_tBodyGyro_mean_X            | Mean of the values of tBodyGyro_mean_X feature          |
  | avg_tBodyGyro_mean_Y            | Mean of the values of tBodyGyro_mean_Y feature          |
  | avg_tBodyGyro_mean_Z            | Mean of the values of tBodyGyro_mean_Z feature          |
  | avg_tBodyGyro_std_X             | Mean of the values of tBodyGyro_std_X feature          |
  | avg_tBodyGyro_std_Y             | Mean of the values of tBodyGyro_std_Y feature          |
  | avg_tBodyGyro_std_Z             | Mean of the values of tBodyGyro_std_Z feature          |
  | avg_tBodyGyroJerk_mean_X        | Mean of the values of tBodyGyroJerk_mean_X feature          |
  | avg_tBodyGyroJerk_mean_Y        | Mean of the values of tBodyGyroJerk_mean_Y feature          |
  | avg_tBodyGyroJerk_mean_Z        | Mean of the values of tBodyGyroJerk_mean_Z feature          |
  | avg_tBodyGyroJerk_std_X         | Mean of the values of tBodyGyroJerk_std_X feature          |
  | avg_tBodyGyroJerk_std_Y         | Mean of the values of tBodyGyroJerk_std_Y feature          |
  | avg_tBodyGyroJerk_std_Z         | Mean of the values of tBodyGyroJerk_std_Z feature          |
  | avg_tBodyAccMag_mean            | Mean of the values of tBodyAccMag_mean feature          |
  | avg_tBodyAccMag_std             | Mean of the values of tBodyAccMag_std feature          |
  | avg_tGravityAccMag_mean         | Mean of the values of tGravityAccMag_mean feature          |
  | avg_tGravityAccMag_std          | Mean of the values of tGravityAccMag_std feature          | 
  | avg_tBodyAccJerkMag_mean        | Mean of the values of tBodyAccJerkMag_mean feature          |
  | avg_tBodyAccJerkMag_std         | Mean of the values of tBodyAccJerkMag_std feature          |
  | avg_tBodyGyroMag_mean           | Mean of the values of tBodyGyroMag_mean feature          |
  | avg_tBodyGyroMag_std            | Mean of the values of tBodyGyroMag_std feature          |
  | avg_tBodyGyroJerkMag_mean       | Mean of the values of tBodyGyroJerkMag_mean feature          |
  | avg_tBodyGyroJerkMag_std        | Mean of the values of tBodyGyroJerkMag_std feature          |
  | avg_fBodyAcc_mean_X             | Mean of the values of fBodyAcc_mean_X feature          |
  | avg_fBodyAcc_mean_Y             | Mean of the values of fBodyAcc_mean_Y feature          |
  | avg_fBodyAcc_mean_Z             | Mean of the values of fBodyAcc_mean_Z feature          |
  | avg_fBodyAcc_std_X              | Mean of the values of fBodyAcc_std_X feature          |
  | avg_fBodyAcc_std_Y              | Mean of the values of fBodyAcc_std_Y feature          |
  | avg_fBodyAcc_std_Z              | Mean of the values of fBodyAcc_std_Z feature          |
  | avg_fBodyAcc_meanFreq_X         | Mean of the values of fBodyAcc_meanFreq_X feature          |
  | avg_fBodyAcc_meanFreq_Y         | Mean of the values of fBodyAcc_meanFreq_Y feature          |
  | avg_fBodyAcc_meanFreq_Z         | Mean of the values of fBodyAcc_meanFreq_Z feature          |
  | avg_fBodyAccJerk_mean_X         | Mean of the values of fBodyAccJerk_mean_X feature          |
  | avg_fBodyAccJerk_mean_Y         | Mean of the values of fBodyAccJerk_mean_Y feature          |
  | avg_fBodyAccJerk_mean_Z         | Mean of the values of fBodyAccJerk_mean_Z feature          |
  | avg_fBodyAccJerk_std_X          | Mean of the values of fBodyAccJerk_std_X feature          |
  | avg_fBodyAccJerk_std_Y          | Mean of the values of fBodyAccJerk_std_Y feature          |  
  | avg_fBodyAccJerk_std_Z          | Mean of the values of fBodyAccJerk_std_Z feature          |-
  | avg_fBodyAccJerk_meanFreq_X     | Mean of the values of fBodyAccJerk_meanFreq_X feature          |
  | avg_fBodyAccJerk_meanFreq_Y     | Mean of the values of fBodyAccJerk_meanFreq_Y feature          |
  | avg_fBodyAccJerk_meanFreq_Z     | Mean of the values of fBodyAccJerk_meanFreq_Z feature          |
  | avg_fBodyGyro_mean_X            | Mean of the values of fBodyGyro_mean_X feature          |
  | avg_fBodyGyro_mean_Y            | Mean of the values of fBodyGyro_mean_Y feature          |
  | avg_fBodyGyro_mean_Z            | Mean of the values of fBodyGyro_mean_Z feature          |
  | avg_fBodyGyro_std_X             | Mean of the values of fBodyGyro_std_X feature          |
  | avg_fBodyGyro_std_Y             | Mean of the values of fBodyGyro_std_Y feature          |
  | avg_fBodyGyro_std_Z             | Mean of the values of fBodyGyro_std_Z feature          |
  | avg_fBodyGyro_meanFreq_X        | Mean of the values of fBodyGyro_meanFreq_X feature          |
  | avg_fBodyGyro_meanFreq_Y        | Mean of the values of fBodyGyro_meanFreq_Y feature          |
  | avg_fBodyGyro_meanFreq_Z        | Mean of the values of fBodyGyro_meanFreq_Z feature          |
  | avg_fBodyAccMag_mean            | Mean of the values of fBodyAccMag_mean feature          |
  | avg_fBodyAccMag_std             | Mean of the values of fBodyAccMag_std feature          |
  | avg_fBodyAccMag_meanFreq        | Mean of the values of fBodyAccMag_meanFreq feature          |
  | avg_fBodyBodyAccJerkMag_mean    | Mean of the values of fBodyBodyAccJerkMag_mean feature          |
  | avg_fBodyBodyAccJerkMag_std     | Mean of the values of fBodyBodyAccJerkMag_std feature          |
  | avg_fBodyBodyAccJerkMag_meanFreq | Mean of the values of fBodyBodyAccJerkMag_meanFreq feature          | 
  | avg_fBodyBodyGyroMag_mean       | Mean of the values of fBodyBodyGyroMag_mean feature          |
  | avg_fBodyBodyGyroMag_std        | Mean of the values of fBodyBodyGyroMag_std feature          |
  | avg_fBodyBodyGyroMag_meanFreq   | Mean of the values of fBodyBodyGyroMag_meanFreq feature          |
  | avg_fBodyBodyGyroJerkMag_mean   | Mean of the values of fBodyBodyGyroJerkMag_mean feature          |
  | avg_fBodyBodyGyroJerkMag_std    | Mean of the values of fBodyBodyGyroJerkMag_std feature          |
  | avg_fBodyBodyGyroJerkMag_meanFreq | Mean of the values of fBodyBodyGyroJerkMag_meanFreq feature          |

The resulting data frame has $6\times 30 = 180$ rows (regarding the 6 kind of activity and 30 subjects) and $82$ columns. 


   

