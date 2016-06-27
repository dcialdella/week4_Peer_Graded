
#
# Getting and Cleaning data
# 
# Run analysis.R
# dac 2016-07-01
#
# V 7.0
#
#


# ########################################################
#
# Settings
#
# ########################################################

library(reshape2)
library(plyr)
library(htmltools)
library(httpuv)
library(httr)
library(lubridate)


# FIX Proxy access to internet
set_config(use_proxy(url='http://192.168.10.145',8080))



# ########################################################
#
# 1. Download the dataset if it does not already exist in the working directory
# check local file, if I deleted it, download it again.
#
# ########################################################

#
# file 59.7 megas download
#
start_file <- "downloaded_data.zip"
if (   !file.exists( start_file ))
{
  
  # Download using HTTP - issues with the proxy. recheck it !!!!
  download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                start_file, method = "curl" )
  # % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
  # Dload  Upload   Total   Spent    Left  Speed
  # 0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (5) Could not resolve proxy: 192.168.10.1.45
  
  # Downloaded Manually and stored locally by hand.
  
  

  # Unzip file in a local folder
  # Linux Shell - unzip downloaded_data.zip
  
  #  Archive:  downloaded_data.zip
  #  replace UCI HAR Dataset/activity_labels.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: A
  #  inflating: UCI HAR Dataset/activity_labels.txt  
  #  inflating: UCI HAR Dataset/features.txt  
  #  inflating: UCI HAR Dataset/features_info.txt  
  #  inflating: UCI HAR Dataset/README.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt  
  #  inflating: UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt  
  #  inflating: UCI HAR Dataset/test/subject_test.txt  
  #  inflating: UCI HAR Dataset/test/X_test.txt  
  #  inflating: UCI HAR Dataset/test/y_test.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt  
  #  inflating: UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt  
  #  inflating: UCI HAR Dataset/train/subject_train.txt  
  #  inflating: UCI HAR Dataset/train/X_train.txt  
  #  inflating: UCI HAR Dataset/train/y_train.txt 
  
}




# ########################################################
#
# 2. Load the activity and feature info, estimate number of records to validate results later.
#
# ########################################################

actividades <- read.table("UCI HAR Dataset/activity_labels.txt")
act_nro     <- nrow(actividades)

caracter    <- read.table("UCI HAR Dataset/features.txt")
feat_nro    <- nrow(caracter)


# V1                V2
# 1  1 tBodyAcc-mean()-X
# 2  2 tBodyAcc-mean()-Y
# 3  3 tBodyAcc-mean()-Z
# 4  4  tBodyAcc-std()-X
# 5  5  tBodyAcc-std()-Y
# 6  6  tBodyAcc-std()-Z


# VUDU magic here, identify chars and use the 2 column
mean_and_std_carac <- grep("-(mean|std)\\(\\)", caracter[, 2])
# Obtain list of V1 identifying MEAN or STD text of field
# [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85  86 121 122 123 124 125 126 161 162 163 164 165 166 201
# [32] 202 214 215 227 228 240 241 253 254 266 267 268 269 270 271 345 346 347 348 349 350 424 425 426 427 428 429 503 504 516 517
# [63] 529 530 542 543



titulo_train     <- read.table("UCI HAR Dataset/train/subject_train.txt")
titulo_train_nro <- nrow( titulo_train )
# will use V1 as joining field
# 7352

titulo_test      <- read.table("UCI HAR Dataset/test/subject_test.txt")
titulo_test_nro  <- nrow( titulo_test )
# will use V1 as joining field
# 2947

titulo_data     <- rbind(titulo_train, titulo_test)
# 10299 records



# ########################################################
#
# Data to load (training and testing files)
#
# 4. Loads the activity and subject data for each dataset, and merges those columns with the dataset
# 5. Merges the two datasets
# 6. Converts the activity and subject columns into factors
#
# ########################################################

# Training
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")   # name "X"
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")   # Review "y" instead of "Y" ?
# 7352

# Testing
x_test  <- read.table("UCI HAR Dataset/test/X_test.txt")     # name "X"
y_test  <- read.table("UCI HAR Dataset/test/y_test.txt")     # Review "y" instead of "Y" ? 
# 2947


# ########################################################
#
# Transforming data, joining, name columns and others tasks
# pretty sure it could be done in a better way, this is not simple and small
#
# ########################################################

# merge or "BIND", data from training with data from test, x with x
# y with y
x_data <- rbind(x_train, x_test)    # 10299 records OK 
y_data <- rbind(y_train, y_test)    # 10299 records OK
# data merge validates


# reduce data using the Number of column needed with MEAN or STD
x_data <- x_data[, mean_and_std_carac]


# migrate VXXX to a detailed column name
# really cryptic to understand it.....
names(x_data) <- caracter[mean_and_std_carac, 2]

# update COLUMN with correct activity names
y_data[, 1] <- actividades[y_data[, 1], 2]

# correct COLUMN_NAME in Y_DATA
names(y_data)      <- "activity"
# correct COLUMN_Name to Subject
names(titulo_data) <- "subject"


# All in the same place, x_data, y_data and subjects.
toda_la_data <- cbind(x_data, y_data, titulo_data)
# this object could be used for other tasks in the future, it's the BIG all in one.


# ########################################################
#
# Building a new file with results, tidy.txt ? not the best name... but the petition
#
# ########################################################
# 7. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.


# calculating Means, (subject and activity)
promedio_data <- ddply(toda_la_data, .(subject, activity), 
                       function(zzz) {
                           colMeans(zzz[, 1:66])
                         }
                       )

# the FINAL listing, imposible to understand
write.table(promedio_data, "tidy.txt", row.name=FALSE)

#
# Ejemplo de salida
#
# 30 "WALKING_UPSTAIRS" 0.271415642261538 -0.0253311698786154 -0.124697493775385 -0.350504475230769 
# -0.127311157607692 0.0249468034966154 0.93182983 -0.226647292153846 -0.0221401100714154 -0.954033624307692 
# -0.914933936 -0.862402791230769 0.0579840372876923 -0.00358719228769231 0.0161506198923077 -0.535420203384615 
# -0.587214542923077 -0.761942025384615 -0.00355974576923077 -0.0779606464676923 0.0814699303289231 -0.493837520761538 
# -0.0840481513184615 -0.211573579892308 -0.108414261326154 -0.0141113353615385 -0.0364157841384615 -0.742749529538462 
# -0.743336958461538 -0.665150619230769 -0.137627857227385 -0.327410815861538 -0.137627857227385 -0.327410815861538 
# -0.596600099538461 -0.561837706461538 -0.113608367276923 -0.169293534323077 -0.718780256769231 -0.774439096769231 
# -0.420402828153846 -0.297813768569231 -0.36751984 -0.326260358153846 -0.104299180318462 0.121447414920923 
# -0.55067842 -0.592919440769231 -0.737803881230769 -0.561565206615385 -0.610826602 -0.78475388 -0.488039003123077 
# -0.366058433230769 -0.318937001538462 -0.503484236964615 0.0449545535584615 -0.253427074984615 -0.400588353846154 
# -0.394508080769231 -0.549784890615385 -0.580878133230769 -0.449150735076923 -0.151472278383077 -0.773974451846154 
# -0.791349425076923


#
# EOF
#
