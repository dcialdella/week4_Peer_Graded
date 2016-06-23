
#
# Getting and Cleaning data
# 
# Run analysis.R
# dac 2016-07-01
#

library(reshape2)
library(plyr)
library(htmltools)
library(httpuv)
library(httr)
library(lubridate)

# FIX Proxy access to internet
set_config(use_proxy(url='http://192.168.10.145',8080))


# 1. Download the dataset if it does not already exist in the working directory
# check local file, if I deleted it, download it again.
#
start_file <- "downloaded_data.zip"
if (   !file.exists( start_file ))
  {

    # Download using HTTP 
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




