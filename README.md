## Synopsis

This project takes raw data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and tidies it up. 

## Code Example

# This R script does the following:
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard
    deviation for each measurement.
 3. Uses descriptive activity names to name the activities in the
    data set
 4. Appropriately labels the data set with descriptive variable names.
 5. Creates a second, independent tidy data set with the average of
   each variable for each activity and each subject.

##How it goes about it:
#assumption UCI data folder in wd

First the script checks all packages are installed and loaded as necessary.

1. The x train data is rbind onto xtest.
2. Appropriate column labels are defined based on features.txt
3. Subject and activity are cbind onto end creating 563 variables total.
4. Renamed as subject and activity.
5. Variables with mean and std selected using grep.
6. Woops we lost subject and activity but as order hasnt changed we just re-append it.
7. grouped or subsetted by activity, activity_description column added with appropriate character name given.
8. rebound the new subsets using rbind, removed the old activity column.
9. Melted the data and reordered using subject and activity_description.
10.Wrote as table.
##output
tidy_data.txt



## Motivation

This project was completed to develop good workflow for similar projects in the future.

## Installation

Provide code examples and explanations of how to get the project.

## License

All open source, a few packages were used in R.
