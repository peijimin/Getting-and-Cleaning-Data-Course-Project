library(dplyr)
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
combined_data <- cbind(subject_data, y_data, x_data)

finaldata <- combined_data %>% select(subject, code, contains("mean"), contains("std"))

finaldata$code <- activities[finaldata$code, 2]
names(finaldata)[2] = "activity"
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("^t", "Time", names(finaldata))
names(finaldata)<-gsub("^f", "Frequency", names(finaldata))
names(finaldata)<-gsub("tBody", "TimeBody", names(finaldata))
names(finaldata)<-gsub("-mean()", "Mean", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-std()", "STD", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-freq()", "Frequency", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("angle", "Angle", names(finaldata))
names(finaldata)<-gsub("gravity", "Gravity", names(finaldata))

sep_tidy_data <- finaldata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(sep_tidy_data, "sep_tidy_data.txt", row.name=FALSE)
str(sep_tidy_data)
