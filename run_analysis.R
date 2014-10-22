#Coursera getting and cleaning data
#Course Project

# This R script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard
#    deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the
#    data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. Creates a second, independent tidy data set with the average of
#    each variable for each activity and each subject.
#
#
#   VISUALISE THE DATA:
#
#                     features.txt(mean and std)       subject             activity (recode!)           
#     
#                     X_train.txt               subject_train.text         y_train.text
#
#                     X_test.txt                subject_test.txt            y_test.txt
#
#
#
#ASSUMPTION
#UCI HAR Dataset folder is assumed to be in the home directory or working directory

#SETUP
rm(list = ls()) #clear workspace

#PACKAGES
# Check for, install, and load packages if needed

if(!require("data.table")) {
  install.packages("data.table")
  require("data.table")
}

if(!require("reshape2")) {
  install.packages("reshape2")
  require("reshape2")
}

if(!require("dplyr")) {
  install.packages("dplyr")
  require("dplyr")
}

#DIRECTORY
setwd("C://Users//mammykins//Documents//R//coursera//getandclean//project") #this is for me during testing
setwd(".//UCI HAR Dataset") 
WD <- getwd() #use this to reset directory


#first create a folder to hold new output if required,
if (!file.exists("output")) {
  dir.create("output")
}

###########################
###########################

#1  Merges the training and the test sets to create one data set.

#next merge the data with appropriate headers or labels
#let's do the training set first, need to column bind the data to the labels
setwd(WD) #reset directory
setwd(".//train") #go to train dir
x_train <- read.table("x_train.txt", header=F)

#Repeat but with test data...
setwd(WD) #reset working directory
setwd(".//test") #go to appropriate dir for test data
x_test<- read.table("x_test.txt", header=F)

#################################################
#################################################
# 4. Appropriately labels the data set with descriptive variable names.

#labels or variable names to be added from "features.txt", create a dataframe
setwd(WD) #reset working directory
features <- read.table("features.txt", header=F)

#rename the data with more informaive column or variable names from the file features.txt
names(x_train)<-features[[2]]
names(x_test)<-features[[2]] #In order to reference a list member directly, we have to use the double square bracket "[[]]" operator.

#bind the rows together, should be 561 variables
#the training and test data are rows of the overall dataframe and need to be bound, train is on top
x_data <- rbind(x_train, x_test)

#convert data to tabl_df to avoid excessive printing and check
x_data_tbl_df <- tbl_df(x_data)


#next merge the x_data with the columns of subject and activit(y_train), train is on top of test
#let's read in all the files we need
setwd(WD) #reset directory
setwd(".//train") #go to train dir

subject_train <- read.table("subject_train.txt", header=F)
y_train <- read.table("y_train.txt", header=F)

#Repeat but with test data...
setwd(WD) #reset working directory
setwd(".//test") #go to appropriate dir for test data

subject_test <- read.table("subject_test.txt", header=F)
y_test <- read.table("y_test.txt", header=F)

#WD irrelevant as we are using objects from the global environment
#put the subject_train on the subject_test
subject_data <- rbind(subject_train,subject_test)
#put the y_train on the y_test
y_data <- rbind(y_train,y_test)

#let's give them sensible names like subject and activity
names(subject_data)<-"subject"
names(y_data)<-"activity"

#now bind the columns together to create complete dataframe with all variable labelled
big <- cbind(x_data,subject_data,y_data)
big_tbl_df <- tbl_df(big)

######################################
######################################
# 2. Extracts only the measurements on the mean and standard
#    deviation for each measurement.
#let's selecet columns containing only the measurements with mean and standard deviations in
dataExtract <- grep("-mean|-std", colnames(big)) #provide column reference number for those that meet conditions
MeanStd <- big[,c(1,2,dataExtract)]

##########################################
##########################################
# 3. Uses descriptive activity names to name the activities in the
#    data set

#woops, we lost our activity and subject but we can stick them on again
dMeanStd <- tbl_df(cbind(MeanStd,subject_data,y_data))

#group by activity
walking <- dMeanStd[dMeanStd$activity == 1, ]
walking_upstairs <- dMeanStd[dMeanStd$activity == 2, ]
walking_downstairs <- dMeanStd[dMeanStd$activity == 3, ]
sitting <- dMeanStd[dMeanStd$activity == 4, ]
standing <- dMeanStd[dMeanStd$activity == 5, ]
laying <- dMeanStd[dMeanStd$activity == 6, ]

#now that they've been grouped we can add extra column for activity_description
walking <- mutate(walking, 
       activity_description = "walking")
walking_upstairs <- mutate(walking_upstairs, 
                  activity_description = "walking upstairs")
walking_downstairs <- mutate(walking_downstairs, 
                  activity_description = "walking downstairs")
sitting <- mutate(sitting, 
                  activity_description = "sitting")
standing <- mutate(standing, 
                  activity_description = "standing")
laying <- mutate(laying, 
                  activity_description = "laying")

#we can rbind again and then drop the old activity column
recoded <- rbind(walking,walking_upstairs,walking_downstairs,sitting,standing,laying)
recoded <- recoded[,-83] #drop redundant activity code

##################################################
##################################################
  
# 5. Creates a second, independent tidy data set with the average of
#    each variable for each activity and each subject.

setwd(WD) #reset directory
setwd(".//output") #go to output dir

# summarise means by groups - subject/activity_description
meltData = melt(recoded, id.var = c("subject", "activity_description"))
dataMeans = dcast(meltData, subject + activity_description ~ variable, mean)

# Write to new tidy data file
write.table(dataMeans, file="tidy_data.txt", sep=" ",row.names=FALSE)
