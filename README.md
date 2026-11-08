# Getting and Cleaning Data Week4 Project

Author: Gábor NÉMETH

Date: 2026-11-08

Last update: 2026-11-08

## Description

This is a project for Coursera course "Getting and Cleaning Data". The aim is to 
gather and clean a data computing the averages of some selected features for each subject and for each kind of activity.


## Project structure

```
.
├── CodeBook.md
├── data
│   ├── activity_labels.txt
│   ├── features_info.txt
│   ├── features.txt
│   ├── README.txt
│   ├── test
│   │   ├── Inertial Signals
│   │   │   ├── body_acc_x_test.txt
│   │   │   ├── body_acc_y_test.txt
│   │   │   ├── body_acc_z_test.txt
│   │   │   ├── body_gyro_x_test.txt
│   │   │   ├── body_gyro_y_test.txt
│   │   │   ├── body_gyro_z_test.txt
│   │   │   ├── total_acc_x_test.txt
│   │   │   ├── total_acc_y_test.txt
│   │   │   └── total_acc_z_test.txt
│   │   ├── subject_test.txt
│   │   ├── X_test.txt
│   │   └── y_test.txt
│   └── train
│       ├── Inertial Signals
│       │   ├── body_acc_x_train.txt
│       │   ├── body_acc_y_train.txt
│       │   ├── body_acc_z_train.txt
│       │   ├── body_gyro_x_train.txt
│       │   ├── body_gyro_y_train.txt
│       │   ├── body_gyro_z_train.txt
│       │   ├── total_acc_x_train.txt
│       │   ├── total_acc_y_train.txt
│       │   └── total_acc_z_train.txt
│       ├── subject_train.txt
│       ├── X_train.txt
│       └── y_train.txt
├── README.md
└── run_analysis.R
```
Folder `data` contains the original data file.

`README.md` this file. 
`run_analysis.R` is the source code that clean data and creates the clean data set into `tidy_dataset.txt`. 
Note that `tidy_dataset.txt` is not contained in the project, it is a result file.

The whole process of the cleaning data are detailed in `CodeBook.md` file.


## Executing the script

Use R and RStudio to execute the program. 

Type the following command to execute the script. 

``` R
source('run_analysis.R')
```