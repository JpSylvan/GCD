# Read all the useful tables
features = read.table("features.txt")
features = features[,2]
X_train = read.table("train/X_train.txt")
y_train = read.table("train/y_train.txt")
subject_train = read.table("train/subject_train.txt")
X_test = read.table("test/X_test.txt")
y_test = read.table("test/y_test.txt")
subject_test = read.table("test/subject_test.txt")
activities = read.table("activity_labels.txt")

# Name the variables
names(X_train) = names(X_test) = features
names(y_train) = names(y_test) = "class"
names(subject_train) = names(subject_test) = "subject"
names(activities) = c("code","activity")

# Concatenate X, y, train and test
data_train = cbind(X_train, subject_train, y_train)
data_test = cbind(X_test, subject_test, y_test)
data = rbind(data_train,data_test)

# Keep only mean() and std() (grepl(pattern,x) tells us if pattern is included in the string x)
# We need to remove meanFreq() since grepl("mean()",features) is equal to TRUE when the feature name contains meanFreq() (which we
# don't want')
keep = (grepl("mean()",features) | grepl("std()",features)) & !grepl("meanFreq()",features)
data = data[,c(keep,T,T)] # We add 2 TRUE values to keep, to keep the last 2 columns of data which are 

# Label the activities (1=WALKING, 2=WALKING_UPSTAIRS, etc...)
# Remove the first column of data which is activity_code (from 1 to 6) and that we don't need anymore
data = merge(x=data,y=activities,by.x="class",by.y="code",all.x=T)
data = data[,-1]

# Average by group activity-subject
datasplit = split(data,list(data$subject,data$activity)) #datasplit is a list, each element is a dataframe corresponding to a couple
#(subject,activity)

# For each dataframe of the list datasplit, we compute the mean for each column. We remove the last 2 columns which are the activity 
# and the subject (we don't want to compute mean() on these variables). 
# Then we aggregate this in a same data.frame
tidydata = NULL
for (i in 1:length(datasplit)) {
    nbcol = dim(datasplit[[i]])[2]
    tidydata = rbind(tidydata,colMeans(datasplit[[i]][,-c(nbcol-1,nbcol)]))
}

# Transform the matrix into a data.frame and add the name of the couple (subject,activity) to each row
tidydata = data.frame(tidydata)
tidydata = data.frame(group = names(datasplit),tidydata)

#Don't know why but after the 2 previous lines, characters "-" and "()" in features names are replaced with 
# ".", so I give the original names back
names(tidydata) = c("subject-activity",as.character(features[keep]))

#Write data in .txt files
write.table(tidydata,file="tidydata.txt",row.name=F)
