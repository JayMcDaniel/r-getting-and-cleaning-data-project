library(tidyverse)

setwd("UCI_HAR_Dataset")
options(scipen=999)


## Helper Functions ##
#function to be applied in lapply to list to split each string into vectors, and only keep features we want, according to include_feature_v
space_split <- function(x){
  as_vector(strsplit(str_squish(x), split = "\\s+"))[include_feature_v]
}

#function to transpose a tibble
transpose_tibble <- function(tibble){
  as_tibble(cbind(t(tibble))) 
}


# Get Activity labels
activity_labels <- scan("activity_labels.txt", what="", sep="\n") # vector of 6, ex: [1] "1 WALKING" 
activity_labels <- str_remove_all(activity_labels, "\\d ") %>% str_replace_all("_", " ")

#Get features labels
features_labels <- scan("features.txt", what="", sep="\n") 
#make logical vector to be used to keep only the features we want (mean and standard deviation)
include_feature_v <- str_detect(features_labels, "mean\\(\\)|std\\(\\)") 
included_features_labels <- features_labels[include_feature_v] %>%  str_remove_all("\\d\\s*")


##functions to get and convert data. Repeated with test and train folders##
#get subject ids
get_subject_ids <-function(filename){
  subject_ids <- read_delim(filename, delim ="\n",  col_names=c("subject_id"))
  #add unique ids to be used when merging tables
  subject_ids$observation_id <- 1:nrow(subject_ids)
  subject_ids
}



#get subject activity data
get_subject_activity <- function(filename){
  subject_activity <- read_delim(filename, delim ="\n", col_names=c("activity"))
  #Replace codes with labels
  subject_activity$activity <- as.factor(subject_activity$activity) 
  levels(subject_activity$activity) = activity_labels
  #add unique ids to be used when merging tables
  subject_activity$observation_id <- 1:nrow(subject_activity)
  subject_activity
}

#get inertial signal 
get_inertial_signal <- function (filename, colnames){
  inertial_signal <- read_delim(filename, delim ="\n", col_names = colnames)
  inertial_signal
}

#get features data
get_features <- function(filename){
  features <- read_delim(filename, delim ="\n", col_names=c("features"))
  features
}

#clean features data
clean_features <- function (features){
  features <- as.list(features$features) #covert column to list of strings
  features <- lapply(features, space_split) #convert each string in the list to vectors
  #convert list of vectors into a tibble where each vector is a new row
  names(features) <- c(1:length(features)) #list elements must have names to be turned into a tibble
  features <- as_tibble(features) #convert list to tibble
  features <- transpose_tibble(features) #transpose to give us what we want (2957 obs of 66 variables (features))
  names(features) <- included_features_labels
  features$observation_id <- 1:nrow(features)
  features
}




##Get Test subjects data##

#test subject ids
test_subject_ids <- get_subject_ids("test/subject_test.txt")

#test subject activities
test_subject_activity <- get_subject_activity("test/y_test.txt")

# import test subject estimated body acceleration
test_estimated_body_acceleration_x <- get_inertial_signal("test/inertial_signals/body_acc_x_test.txt", c("estimated_body_acceleration_x"))
test_estimated_body_acceleration_x[1,1]

#import features set
test_features <- get_features("test/X_test.txt")
#clean up and organize features set
test_features <- clean_features(test_features)

#join test data tibbles
test_tb <- left_join(test_subject_ids, test_subject_activity, by="observation_id")  %>% left_join(., test_features, by="observation_id") 



##Get Training subjects data##

#training subject ids
training_subject_ids <- get_subject_ids("train/subject_train.txt")
  
#test subject activities
training_subject_activity <- get_subject_activity("train/y_train.txt")

#import features set
training_features <- get_features("train/X_train.txt")
#clean up and organize features set
training_features <- clean_features(training_features)

#join test data tibbles
training_tb <- left_join(training_subject_ids, training_subject_activity, by="observation_id")  %>% left_join(., training_features, by="observation_id") 


#join test and training tibbles
combined_tibble <- bind_rows(test_tb, training_tb) %>% arrange(subject_id) 
combined_tibble$observation_id <- 1:nrow(combined_tibble) #assign new observation id to make it unique again ()

#clean up column names
names(combined_tibble) <- tolower(names(combined_tibble)) %>% 
  str_replace("mean\\(\\)", "mean_value") %>% 
  str_replace("std\\(\\)", "standard_deviation") %>% 
  str_replace_all( "-", "_") %>% 
  str_replace_all("^f","frequency_") %>% 
  str_replace_all("^t","time_") %>%  
  str_replace_all("acc","_acceleration_") %>% 
  str_replace_all("bodygyro","body_gyro") %>% 
  str_replace_all("jerkmag","jerk_mag") %>% 
  str_replace_all("gyromag","gyro_mag") %>% 
  str_replace_all("gyrojerk","gyro_jerk") %>% 
  str_replace_all("bodybody","body_body") %>% 
  str_replace_all("mag","magnitude") %>% 
  str_replace_all("__","_")


#convert columns to numeric
combined_tibble[, c(4:ncol(combined_tibble))] <- sapply(combined_tibble[, c(4:ncol(combined_tibble))], as.numeric)


## Make averages tibble ##
averages_tibble <- combined_tibble %>%
  select(-observation_id) %>% 
  group_by(subject_id, activity) %>% 
  summarise_all(mean)

mean(averages_tibble)



