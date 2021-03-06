
# Get Test Data
setwd(
  "C:/Users/pordo/Documents/Coursera/Data_Science/Getting and Cleaning Data/Assig/UCI HAR Dataset/test"
  )
testset <- read.table("X_test.txt")
testlables <- read.table("y_test.txt")
subjecttest <- read.table("subject_test.txt")

# Get Training Data
setwd(
  "C:/Users/pordo/Documents/Coursera/Data_Science/Getting and Cleaning Data/Assig/UCI HAR Dataset/train"
  )
trainset <-  read.table("X_train.txt")
trainlables <- read.table("y_train.txt")
subjecttrain <- read.table("subject_train.txt")  

# Get Features 
setwd(
  "C:/Users/pordo/Documents/Coursera/Data_Science/Getting and Cleaning Data/Assig/UCI HAR Dataset"
  )

features <- read.table("features.txt", as.is = TRUE)

# Get Activity Labels

activitylabels <- read.table("activity_labels.txt")
colnames(activitylabels) <- c("activityid", "activity")

# 1. Merge training set and test set to create one data set

data_set_one <- rbind(
  cbind(subjecttrain, trainset, trainlables),
  cbind(subjecttest, testset, testlables)
)

colnames(data_set_one) <- c("subject", features[, 2], "activity")

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.

KeepColumns <- grepl("subject|activity|mean|std", colnames(data_set_one))

data_set_two <- data_set_one[, KeepColumns]

# 3. Use descriptive activity names to name the activities in the data set

data_set_two$activity <- factor(data_set_two$activity, 
                                 levels = activitylabels[, 1], 
                                labels = activitylabels[, 2])

# 4. Appropriately labels the data set with descriptive variable names


data_set_two_cols <- colnames(data_set_two)
data_set_two_cols <- gsub("[-\\(\\)]", "", data_set_two_cols)
data_set_two_cols <- gsub("^f", "frequencydomain", data_set_two_cols)
data_set_two_cols <- gsub("^t", "timedomain", data_set_two_cols)
data_set_two_cols <- gsub("Acc", "accelerometer", data_set_two_cols)
data_set_two_cols <- gsub("Gyro", "gyroscope", data_set_two_cols)
data_set_two_cols <- gsub("Mag", "magnitude", data_set_two_cols)
data_set_two_cols <- gsub("Freq", "frequency", data_set_two_cols)
data_set_two_cols <- gsub("mean", "mean", data_set_two_cols)
data_set_two_cols <- gsub("std", "standarddeviation", data_set_two_cols)
data_set_two_cols <- gsub("BodyBody", "body", data_set_two_cols)
colnames(data_set_two) <- data_set_two_cols

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data_set_three <- 
  data_set_two %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(data_set_three, 
            "tidy_data_final.txt", 
            row.names = FALSE, 
            quote = FALSE)
