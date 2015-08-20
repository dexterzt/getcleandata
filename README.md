The repo contains the dataset and the R script (run_analysis.R) used to created 
the required resulting datasets. The code is self contained. 
Data, variable descriptions and our data processing methods are described in CodeBook.md.
The original data description files (featurs.txt and features_info.txt) from the dataset are also included.

##*Our tasks*

Create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##*Steps we take*

1.We read data from files activity_labels.txt, train/X_train.txt, train/y_train.txt, test/X_test.txt, test/y_test.txt, train/subject_train.txt and test/subject_test.txt and merged them to create one single complete raw data set. Because in task 2, we only need the mean and std variables, by looking at and features_info.txt and features.txt,  we find that we don’t need the data in train/Inertial Signals and test/Inertial Signals. 

2.We changed the activity labels in the raw data to their corresponding activity name and thus completed task 3. We also converted activity to a factor variable.

3.We found the feature names that contain ‘mean’ or ‘std’ and extracted these columns, thus completing task 2.

4.We changed all letters in feature names to lower case, turnd each feature name into a single space separated phrase in (mostly) complete and understandable words, thus completing task 4. The resulting dataset is called ‘raw_data’.

5.We grouped the raw data by activity and subject and compute the mean of each variable for each group. Then we turn the variable names to ‘avg ’ + their original name. Last, we gather all variable columns and turn them into key, value pairs. The resulting dataset is called ‘data_avg’. And we save it as data_avg.txt.

