library(reshape2)

#load test data
subject_test <- read.table("data/test/subject_test.txt")
X_test <- read.table("data/test/X_test.txt")
y_test <- read.table("data/test/y_test.txt")

#load train data
subject_train <- read.table("data/train/subject_train.txt")
X_train <- read.table("data/train/X_train.txt")
y_train <- read.table("data/train/y_train.txt")

#load activity names
activity_labels <- read.table("data/activity_labels.txt")

#load feature names
features <- read.table("data/features.txt")
headers <- features[,2]

#name columns of test and train features
names(X_test) <- headers
names(X_train) <- headers

#select only mean and std headers
mean_and_std <- grepl("mean\\(\\)|std\\(\\)", headers)

#filter mean and std columns on test and train
X_test_mean_and_std <- X_test[,mean_and_std]
X_train_mean_and_std <- X_train[,mean_and_std]

#merge all test and train rows
subject_all <- rbind(subject_test, subject_train)
X_all <- rbind(X_test_mean_and_std, X_train_mean_and_std)
y_all <- rbind(y_test, y_train)

#combine all vectors/data.frames into one data.frame
merged <- cbind(subject_all, y_all, X_all)
names(merged)[1] <- "SubjectID"
names(merged)[2] <- "Activity"

#aggregate by subjectid and activity
agg <- aggregate(. ~ SubjectID + Activity, data=merged, FUN = mean)

#give activities better names
agg$Activity <- factor(agg$Activity, labels=activity_labels[,2])

write.table(agg, file="./tidyagg.txt", sep="\t", row.names=FALSE)


