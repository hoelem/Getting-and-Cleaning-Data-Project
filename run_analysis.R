######################################################
## title: "CodeBook.md"
## author: "Eric H"
## date: "January 31, 2016"
## 
## runAnalysis.r
######################################################

# 1 - Merges the training and the test sets to create one data set.

#set working directory
setwd("~/GitHub/GCDassignment");

# Read in the training data
f <- read.table('./data/features.txt');
activity <- read.table('./data/activity_labels.txt');
colnames(activity) <- c('activityId','activityType');
subjecttrain <- read.table('./data/train/subject_train.txt');
colnames(subjecttrain) <- "subjectId";
xtrain <- read.table('./data/train/x_train.txt');
colnames(xtrain) <- f[,2]; 
ytrain <- read.table('./data/train/y_train.txt');
colnames(ytrain) <- "activityId";
train <-  cbind(subjecttrain,ytrain,xTrain);

# Read in the test data
subjecttest <- read.table('./data/test/subject_test.txt');
colnames(subjecttest) <- "subjectId";
xtest <- read.table('./data/test/x_test.txt');
colnames(xtest) <- f[,2]; 
ytest <- read.table('./data/test/y_test.txt');
colnames(ytest) <- "activityId";
test = cbind(subjecttest,ytest,xtest);

# create a final data set
final <- rbind(train,test);

#2 - Extracts only the measurements on the mean and standard deviation for each measurement.


names  <- colnames(final); 
#log <- (grepl("activity..",names) | grepl("subject..",names) | grepl("-mean..",names) 
#        & !grepl("-meanFreq..",names) & !grepl("mean..-",names) | grepl("-std..",names) 
 #       & !grepl("-std()..-",names));
cols <- c(1,2,grep(".*mean.*|.*std.*", names));

# final dataset with desired columns
final <- final[,cols];

#3- Uses descriptive activity names to name the activities in the data set
final$activityId <- factor(final$activityId, levels = activity[,1], labels = activity[,2]);

#4 - Appropriately labels the data set with descriptive variable names.
names <- colnames(final);
names <- gsub('[-()]', '', names);
names <- tolower(names);
colnames(final) <- names;

#5 - From the data set in step 4, creates a second, independent tidy data set with the average of   
#each variable for ealibrarych activity and each subject.
#Using package rehape2 to reshape dataset for mean calc
tidy <- melt(final, id = c("subjectid", "activityid"));
tidy <- dcast(tidy, subjectid + activityid ~ variable, mean);

write.table(tidy, "tidy.txt", row.names = FALSE, quote = FALSE);



