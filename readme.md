NOTES ON SCRIPTS AND ASSIGNMENT

A complete description of the variables and the steps followed to complete this
assignment can be found in "CodeBook.md".

An explanation of the script is given here:

SECTION A

The function "read.table" is used to read the data, which is supplied in .txt files:

     traindata <- read.table("X_train.txt") 
reads the main data for training into a data frame called "traindata" (7352 x 651)

     trainactivity <- read.table("y_train.txt")
reads the training activities into a data frame called "trainactivity" (7352 x 1)

     trainsubject <- read.table("subject_train.txt")
reads the training subjects into a data frame called "trainsubject" (7352 x 1)


The function "colnames" is used to fix column names:

    colnames(trainactivity)[1]<-"activity"
changes the name of the column in trainactivity to "activity"

    colnames(trainsubject)[1]<-"subject"
changes the name of the column in trainsubject to "subject"

    cn <- read.table("features.txt")  
reads the names of the features into a data frame called "cn" (561 x 2)
    colnames(traindata) <- cn$V2
changes the names of the 561 columns in traindata to the names in column 2 of cn


The function "grep" is used to select only columns with mean() and std() in the name:

    subtr1 <- traindata[ , grep("mean()", colnames(traindata),fixed=TRUE)]
subsets traindata by selecting columns that contain "mean()"in the name;
fixed=TRUE ensures an exact match. The result is stored in a data frame called "subtr1"

    subtr2 <- traindata[ , grep("std()", colnames(traindata),fixed=TRUE)]
subsets traindata by selecting columns that contain "std()"in the name;
fixed=TRUE ensures an exact match. The result is stored in a data frame called "subtr2"


The function "cbind" is used to combine data frames into a single data frame:

    subtr <- cbind(subtr1,subtr2)
combines the data frames "subtr1" and "subtr2" into a single data frame called "subtr"
places the columns in the order given

    traindf <- cbind(trainsubject,trainactivity,subtr)
combines the data frames "trainsubject" and "trainactivity" and "subtr" into a single 
data frame called "traindf" and places the columns in the order given

The function "tbl_df" in the library dplyr is used to change a data frame to a tibble:

    library(dplyr)


The function "rm" is used to delete/remove data frames no longer required:

    rm(trainsubject)
    rm(trainactivity)
    rm(subtr)
    rm(subtr1)
    rm(subtr2)

SECTION B

The functions and procedures given in section A are applied likewise to the testdata:

 read test data: 
     testdata <- read.table("X_test.txt")
     testactivity <- read.table("y_test.txt")
     testsubject <- read.table("subject_test.txt")
 fix column names: 
    colnames(testactivity)[1]<-"activity"
    colnames(testsubject)[1]<-"subject"
    cn <- read.table("features.txt")
    colnames(testdata) <- cn$V2
 select only columns with mean() and std() in the name
    subtest1 <- testdata[ , grep("mean()", colnames(testdata),fixed=TRUE)]
    subtest2 <- testdata[ , grep("std()", colnames(testdata),fixed=TRUE)]
    subtest <- cbind(subtest1,subtest2)
 Make combined tibble df for test and clean up
    testdf <- cbind(testsubject,testactivity,subtest)
    testdf <- tbl_df(testdf)
    rm(testsubject)
    rm(testactivity)
    rm(testdata)
    rm(cn)
    rm(subtest)
    rm(subtest1)
    rm(subtest2)

SECTION C

The function "Rbind" is used to combine the test and training data frames into a single data 
frame called "totaldata"

    totaldata <- rbind(traindf,testdf)

The "group_by" function is used to group the data first by subject and then by activity.
The result is stored in a data frame called "finaldata"

    finaldata <- group_by(totaldata,subject,activity)

The "summarise_each" function is used to get average for each variable; the result is placed 
in a data frame called "summary":

    summary <- summarise_each(finaldata,funs(mean))

Finally, the activity names need to be added to "summary" and the column names need to be 
changed to be meaningful:

    activities <- read.table("activity_labels.txt")
Read the activity labels into a data frame called "activities" (6 x 2)

    for (i in 1:6) {summary$activity[summary$activity==i] <- as.character(activities[i,2])}
Replace each of the numbers 1 to 6 in the 2nd column with the corresponding name of the
activity, e.g. 1 becomes WALKING

    library(stringr)
    for (i in 3:68) { colnames(summary)[i]<-paste("average",colnames(summary)[i]) }
Add the word "average" at the beginning of each column name, columns 3 to 68

The required tidy data set is contained in the data frame "summary"

