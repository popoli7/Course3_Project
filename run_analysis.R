if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip("./data/Dataset.zip", files = NULL, list = FALSE, exdir = ".", unzip = "internal")


X_train = read.table("UCI HAR Dataset/train/X_train.txt")
y_train = read.table("UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")

X_test = read.table("UCI HAR Dataset/test/X_test.txt")
y_test = read.table("UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")


train_dat <- cbind(subject_train, y_train, X_train)
test_dat <- cbind(subject_test, y_test, X_test)

main_dat <- rbind(train_dat, test_dat)

features <- read.table("UCI HAR Dataset/features.txt")[, 2]

names(main_dat) <- c("subject", "activity", as.vector(features))

sub_dat <- main_dat[,grepl("mean()", colnames(main_dat), fixed = TRUE) | grepl("std()", colnames(main_dat), fixed = TRUE) |
        grepl("subject", colnames(main_dat), fixed = TRUE) | grepl("activity", colnames(main_dat), fixed = TRUE)]

#names(sub_dat)
names(sub_dat) <- sub("\\()","",names(sub_dat),)
names(sub_dat) <- sub("\\-","_",names(sub_dat),)
names(sub_dat) <- sub("\\-","_",names(sub_dat),)



sub_dat$activity <- factor(sub_dat$activity,
                    levels = c(1,2,3,4,5,6),
                    labels = c("walk", "walk_up", "walk_down", "sit", "stand", "lay"))



tidy_data <- aggregate(sub_dat[, 3:68], list(subject = sub_dat$subject, activity = sub_dat$activity), mean)
#tidy_data


write.table(tidy_data, file = "tidy_data.txt", row.names=FALSE)

