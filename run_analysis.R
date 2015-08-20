library(dplyr)
library(tidyr)

#read files
path='UCI HAR Dataset'
path_test='UCI HAR Dataset/test'
path_train='UCI HAR Dataset/train'
path_test_is='UCI HAR Dataset/test/Inertial Signals'
path_train_is='UCI HAR Dataset/train/Inertial Signals'
activity_labels=tbl_df(read.table(paste(path,'activity_labels.txt',sep = '/'), header=F))
features=tbl_df(read.table(paste(path,'features.txt',sep = '/'), header=F))
subject_test=tbl_df(read.table(paste(path_test,'subject_test.txt',sep = '/'), header=F))
X_test=tbl_df(read.table(paste(path_test,'X_test.txt',sep = '/'), header=F))
y_test=tbl_df(read.table(paste(path_test,'y_test.txt',sep = '/'), header=F))
subject_train=tbl_df(read.table(paste(path_train,'subject_train.txt',sep = '/'), header=F))
X_train=tbl_df(read.table(paste(path_train,'X_train.txt',sep = '/'), header=F))
y_train=tbl_df(read.table(paste(path_train,'y_train.txt',sep = '/'), header=F))

#processing
features <- features %>% 
  mutate(feature_num=V1,feature_name=as.character(V2)) %>%
  select(feature_num, feature_name)

# 1.Merges the training and the test sets to create one data set.
train=bind_cols(subject_train, y_train, X_train)
colnames(train)[1:2]=c('subject','label')
test=bind_cols(subject_test, y_test, X_test)
colnames(test)[1:2]=c('subject','label')
rm(subject_train, y_train, X_train, subject_test, y_test, X_test)
raw_data=tbl_df(bind_rows(train, test))
rm(train, test, raw_data_label)

#3. Uses descriptive activity names to name the activities in the data set
raw_data_label=as.factor(raw_data$label)
levels(raw_data_label)=activity_labels$V2 
raw_data$label=raw_data_label


#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
cols_mean=apply(features %>% select(feature_name), 
                        2, contain_mean <- function(x)  grepl("mean", x))
cols_std=apply(features %>% select(feature_name), 
                        2, contain_mean <- function(x)  grepl("std", x))
raw_data_mean=raw_data[,c(1:561)[cols_mean]+2]
colnames(raw_data_mean)=features$feature_name[cols_mean]
raw_data_std=raw_data[,c(1:561)[cols_std]+2]
colnames(raw_data_std)=features$feature_name[cols_std]
raw_data=bind_cols(raw_data[,1:2], raw_data_mean, raw_data_std)
raw_data=tbl_df(raw_data)
rm(raw_data_mean, raw_data_std)

# 4. Appropriately labels the data set with descriptive variable names. 
raw_names=lapply(names(raw_data), tolower)
raw_names=sub("^t","time domain ",raw_names)
raw_names=sub("^f","frequency domain ",raw_names)
raw_names=sub("mean\\(\\)","mean",raw_names)
raw_names=sub("std\\(\\)","std",raw_names)
raw_names=sub("meanfreq\\(\\)","mean frequency",raw_names)
raw_names=gsub("-"," ",raw_names)
raw_names=sub("bodybody","body",raw_names)
raw_names=sub("body","body ",raw_names)
raw_names=sub("gravity","gravity ",raw_names)
#accelerometer and gyroscope
raw_names=sub("gyro", "gyroscope ", raw_names)
raw_names=sub("acc", "accelerometer ", raw_names)
raw_names=sub("jerk", "jerk ", raw_names)
raw_names=sub("mag", "magnitude", raw_names)
raw_names=sub("  ", " ", raw_names)
names(raw_data)=raw_names
names(raw_data)[2]="activity"

# 5. From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable
# for each activity and each subject.
data_avg=raw_data %>% group_by(activity, subject) %>% summarise_each(funs(mean))
names(data_avg)[3:81]=paste("avg", names(data_avg)[3:81])
data_avg=gather(data_avg, variable, value, -(activity:subject))

#create txt file
write.table(data_avg, 'data_avg.txt', row.names = FALSE)
