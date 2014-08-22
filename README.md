---
title: "ReadMe"
output: html_document
---

## Warning

Before lauching the script Project.txt, be sure that the Coursera dataset is in your working directory. The script does not change
it so it is your duty to make sure the files are in the right folder.

## Result

Then you just have to run the script. It will create a table called tidydata.txt in your working directory, which is the tidy data set Coursera asked.

## Steps

Here are the steps of the script : 

1. Reads all the useful tables : 
    * X_train.txt
    * y_train.txt
    * subject_train.txt
    * X_test.txt
    * y_test.txt
    * subject_test.txt
    * features.txt
    * subjectactivity_labels.txt
2. Since these data sets have no names, the script names them. 
    * Names of the X_train and X_test columns are found in the features.txt data set. They are in the right order.
    * Names of y_train and y_test columns are "class"
    * Names of subject_train and subject_test are "subject"
    * Names of activity are "code" and "activity"
3.  Aggregates 
    * Put X_train, subject_train and y_train in a same data.frame called data_train, with cbind. dim(data_train) == c(7352, 563)
    * Put X_test, subject_test and y_test in a same data.frame called test, with cbind. dim(data_train) == c(2947, 563)
    * Aggregate train and test with rbind to create a data.frame called data. dim(data) == c(10299, 563)
4. Keeps only the features which are mean and std. We know it because it is written "mean()" of "std()" in the feature names.
5. Labels the activities, which are for the moment only numbers from 1 to 6. It is done with a merge on the activity data set
6. Creates a tidy data set by averaging every measurement by (subject, activity). It is done with the function split which creates 
a list of length 180, where each element is a data.frame associated to a couple (subject,activity). Then the script uses colMeans on each of these data.frames in a loop.
7. Writes the tidy data set in a file called "tidydata.txt"

