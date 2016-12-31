1. Downloaded the zip-file and extracted to a tempory folder

2. Noticed that the data was supplied in text files. 
   After reading the documentation supplied, I concluded that:
     30 people participated in the experiment; these people are referred to as subjects
        and are simply identified by the numbers 1 to 30
      6 activities were performed by each subject, numbered from 1 to 6 in this order: 
        WALKING; WALKING_UPSTAIRS; WALKING_DOWNSTAIRS; SITTING; STANDING and LAYING
    561 Measurements were recorded in each observation and the obtained dataset was 
        randomly partitioned into two sets, where 70% of the subjects were selected for 
        generating the training data and 30% the test data.
        The names of these measurements is given in feautures.txt and are not repeated here 

3. I copied the following data files to my working directory:
    X-train.txt - containing the main training data in 561 columns per observation      
    y-train.txt - containing the list of training activities per observation
    subject_train.txt - containing the list of training subjects per observation
    X-test.txt - containing the main test data in 561 columns per observation      
    y-test.txt - containing the list of test activities per observation
    subject_train.txt  - containing the list of test subjects per observation
    feautures.txt - containing the names of the 561 measurements per observation
    activity_labels.txt - containing the names of the 6 activities

4. The next step was to read all the training data and to combine it in a single dataframe:
   The scripts used for this is as follows
     traindata <- read.table("X_train.txt")
     trainactivity <- read.table("y_train.txt")
     trainsubject <- read.table("subject_train.txt")

5. At this stage, these dataframes do not have sensible column names, so these were added.
   The scripts used to fix column names is as follows:
    colnames(trainactivity)[1]<-"activity"
    colnames(trainsubject)[1]<-"subject"
    cn <- read.table("features.txt")
    colnames(traindata) <- cn$V2

6. Instructions for the final result were to only extract the measurements on the mean 
   and standard deviation for each measurement. This was achieved by selecting only 
   columns with mean() and std() in the name, as follows:
    subtr1 <- traindata[ , grep("mean()", colnames(traindata),fixed=TRUE)]
    subtr2 <- traindata[ , grep("std()", colnames(traindata),fixed=TRUE)]
    subtr <- cbind(subtr1,subtr2)

7. To conclude the data for training, I made a combined tibble df as follows:
    traindf <- cbind(trainsubject,trainactivity,subtr)
    library(dplyr)
    traindf <- tbl_df(traindf)

8. To free up memory, I cleaned up by removing df's no longer required:
    rm(trainsubject)
    rm(trainactivity)
    rm(subtr)
    rm(subtr1)
    rm(subtr2)

9. The next step was to read all the test data and to combine it in a single dataframe:
   The scripts used for this is as follows: 
     testdata <- read.table("X_test.txt")
     testactivity <- read.table("y_test.txt")
     testsubject <- read.table("subject_test.txt")

10. At this stage, these dataframes do not have sensible column names, so these were added.
    The scripts used to fix column names is as follows:
     colnames(testactivity)[1]<-"activity"
     colnames(testsubject)[1]<-"subject"
     cn <- read.table("features.txt")
     colnames(testdata) <- cn$V2

11. Again, since instructions for the final result were to only extract the measurements on 
    the mean and standard deviation for each measurement. This was achieved by selecting 
    only columns with mean() and std() in the name, as follows:
      subtest1 <- testdata[ , grep("mean()", colnames(testdata),fixed=TRUE)]
      subtest2 <- testdata[ , grep("std()", colnames(testdata),fixed=TRUE)]
      subtest <- cbind(subtest1,subtest2)

12. To conclude the data for test, I made a combined tibble df as follows:
     testdf <- cbind(testsubject,testactivity,subtest)
     testdf <- tbl_df(testdf)

13. To free up memory, I cleaned up by removing df's no longer required:
      rm(testsubject)
      rm(testactivity)
      rm(testdata)
      rm(cn)
      rm(subtest)
      rm(subtest1)
      rm(subtest2)

14. Finally, to get to the required result, the training and test data had to be combined.
    This was achieved as follows:
      totaldata <- rbind(traindf,testdf)

15. To find the required average of each variable for each activity and each subject 
    the data had to be split into groups by subject and by activity, as follows:
      finaldata <- group_by(totaldata,subject,activity)

16. Next, the average for each variable was calculated as follows:
      summary <- summarise_each(finaldata,funs(mean))

17. At this stage, the activities were still numbers. The activity names were
    included as follows:
      activities <- read.table("activity_labels.txt")
      for (i in 1:6) {summary$activity[summary$activity==i] <- as.character(activities[i,2])}

18. The column names 2 - 68 in "summary" now had to be changed to show that the values were
    the average per group. This was achieved as follows:
      library(stringr)
      for (i in 3:68) { colnames(summary)[i]<-paste("average",colnames(summary)[i]) }

19. The required tidy set is contained in the data frame "summary"  

