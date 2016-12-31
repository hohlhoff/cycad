# Script to load and manipulate wearable computing data
# NOTE: The following data files that were supplied 
#       should be in the working directory
#    X-train.txt
#    y-train.txt
#    subject_train.txt
#    X-test.txt
#    y-test.txt
#    subject_train.txt
#    feautures.txt
#    activity_labels.txt

# Part 1 - get the training data in the required format

# read train data:
     traindata <- read.table("X_train.txt")
     trainactivity <- read.table("y_train.txt")
     trainsubject <- read.table("subject_train.txt")

#  fix column names:
    colnames(trainactivity)[1]<-"activity"
    colnames(trainsubject)[1]<-"subject"
    cn <- read.table("features.txt")
    colnames(traindata) <- cn$V2

#  select only columns with mean() and std() in the name
    subtr1 <- traindata[ , grep("mean()", colnames(traindata),fixed=TRUE)]
    subtr2 <- traindata[ , grep("std()", colnames(traindata),fixed=TRUE)]
    subtr <- cbind(subtr1,subtr2)

#  Make combined tibble df for training data and clean up

    traindf <- cbind(trainsubject,trainactivity,subtr)
    library(dplyr)
    traindf <- tbl_df(traindf)
    rm(trainsubject)
    rm(trainactivity)
    rm(subtr)
    rm(subtr1)
    rm(subtr2)

# Part 2: Get the test data in the required format

# read test data: 
     testdata <- read.table("X_test.txt")
     testactivity <- read.table("y_test.txt")
     testsubject <- read.table("subject_test.txt")

# fix column names: 
    colnames(testactivity)[1]<-"activity"
    colnames(testsubject)[1]<-"subject"
    cn <- read.table("features.txt")
    colnames(testdata) <- cn$V2

#  select only columns with mean() and std() in the name
    subtest1 <- testdata[ , grep("mean()", colnames(testdata),fixed=TRUE)]
    subtest2 <- testdata[ , grep("std()", colnames(testdata),fixed=TRUE)]
    subtest <- cbind(subtest1,subtest2)

# Make combined tibble df for test and clean up
    testdf <- cbind(testsubject,testactivity,subtest)
    testdf <- tbl_df(testdf)
    rm(testsubject)
    rm(testactivity)
    rm(testdata)
    rm(cn)
    rm(subtest)
    rm(subtest1)
    rm(subtest2)

# Step 3: combine the test and training data in one df and group as required

# Merge the test and training df's
    totaldata <- rbind(traindf,testdf)

# group the data by subject and activity
    finaldata <- group_by(totaldata,subject,activity)

# Step 4: Get the average for each variable and show final result

# get the average for each variable
    summary <- summarise_each(finaldata,funs(mean))

# Fix activity names - show names, not numbers
    activities <- read.table("activity_labels.txt")
    for (i in 1:6) {summary$activity[summary$activity==i] <- as.character(activities[i,2])}

# Fix column names 2 - 68 in "summary" to show that the values are the average per group. 
    library(stringr)
    for (i in 3:68) { colnames(summary)[i]<-paste("average",colnames(summary)[i]) }

# display final result
    summary

