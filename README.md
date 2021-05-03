The R script in run_analysis.R does the following:

  The script uses the folder "UCI_HAR_Dataset" as input data.
  
  Starting on line 9, we have helper functions:
  
    #function to be applied in lapply to list to split each string into vectors, and only keep features we want, according to include_feature_v
    space_split <- function(x){
      as_vector(strsplit(str_squish(x), split = "\\s+"))[include_feature_v]
    }
    
    #function to transpose a tibble
    transpose_tibble <- function(tibble){
      as_tibble(cbind(t(tibble))) 
    }


  
  On line 20, we get our activity labels:
  
      activity_labels <- scan("activity_labels.txt", what="", sep="\n") # vector of 6, ex: [1] "1 WALKING" 
      activity_labels <- str_remove_all(activity_labels, "\\d ") %>% str_replace_all("_", " ")
      activity_labels
      
      [1] "WALKING"            "WALKING UPSTAIRS"   "WALKING DOWNSTAIRS" "SITTING" "STANDING"       etc.
      
      
      
  On line 27 we get our features labels:
  
      #Get features labels
    features_labels <- scan("features.txt", what="", sep="\n") 
    #make logical vector to be used to keep only the features we want (mean and standard deviation)
    include_feature_v <- str_detect(features_labels, "mean\\(\\)|std\\(\\)") 
    included_features_labels <- features_labels[include_feature_v] %>%  str_remove_all("\\d\\s*")
    included_features_labels
    [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"      etc.
    
    
    
  On line 37 we create a function that returns subject IDs. This is called later with the test subject and train subject data

    ##functions to get and convert data. Repeated with test and train folders##
    #get subject ids
    get_subject_ids <-function(filename){
      subject_ids <- read_delim(filename, delim ="\n",  col_names=c("subject_id"))
      #add unique ids to be used when merging tables
      subject_ids$observation_id <- 1:nrow(subject_ids)
      subject_ids
    }
    
    
    
  On line 47 we create a function that gets and returns subject activity data and replaces codes with labels. It also adds a unique id that is used for merging tables later. This is called later for both test and train.
  
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
    



  On line 60 we create a function that gets features data. This is called later for both test and train.
  
       #get features data
      get_features <- function(filename){
        features <- read_delim(filename, delim ="\n", col_names=c("features"))
        features
      }
      
  
  
  
  On line 66 we create a function that cleans a features tibble. This is called later for both test and train.
  
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

  

  On line 81 we call our function get get a subject_ids tibble
  
    #test subject ids
    test_subject_ids <- get_subject_ids("test/subject_test.txt")
    > test_subject_ids
    # A tibble: 2,947 x 2
       subject_id observation_id
            <dbl>          <int>
     1          2              1
     2          2              2
     ...
     
     
     
  On line 86 we call our function to get a test_subject_activity tibble
  
    #test subject activities
    test_subject_activity <- get_subject_activity("test/y_test.txt")
    > test_subject_activity
    # A tibble: 2,947 x 2
       activity observation_id
       <fct>             <int>
     1 STANDING              1
     2 STANDING              2
     ...
     
     
     
  Starting on Line 90, we call our functions to retrieve and clean the test_features tibble
  
    #import features set
    test_features <- get_features("test/X_test.txt")
    test_features
    #clean up and organize features set
    test_features <- clean_features(test_features)
    > test_features
    # A tibble: 2,947 x 1
     features                                                                                                           
    <chr>                                                                                                               
     1 "  2.5717778e-001 -2.3285230e-002 -1.4653762e-002 -9.3840400e-001 -9.2009078e-001 -6.6768331e-001 -9.5250112e-001 -9.2…
     2 "  2.8602671e-001 -1.3163359e-002 -1.1908252e-001 -9.7541469e-001 -9.6745790e-001 -9.4495817e-001 -9.8679880e-001 -9.6…
     
     
     
  On line 97 we join the test tibbles that we just made

    #join test data tibbles
    test_tb <- left_join(test_subject_ids, test_subject_activity, by="observation_id")  %>% left_join(., test_features, by="observation_id") 
    
    > test_tb
    # A tibble: 2,947 x 69
    subject_id observation_id activity `tBodyAcc-mean(… `tBodyAcc-mean(… `tBodyAcc-mean(… `tBodyAcc-std()… `tBodyAcc-std()…
        <dbl>          <int> <fct>    <chr>            <chr>            <chr>            <chr>            <chr>           
     1          2              1 STANDING 2.5717778e-001   -2.3285230e-002  -1.4653762e-002  -9.3840400e-001  -9.2009078e-001 
     2          2              2 STANDING 2.8602671e-001   -1.3163359e-002  -1.1908252e-001  -9.7541469e-001  -9.6745790e-001 
     ...
     
     

  Starting on line 105, we run the same functions to get and join tibbles for our training data, as it's the same data, but different subjects
  
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

    > training_tb
    # A tibble: 7,352 x 69
       subject_id observation_id activity `tBodyAcc-mean(… `tBodyAcc-mean(… `tBodyAcc-mean(… `tBodyAcc-std()… `tBodyAcc-std()…
            <dbl>          <int> <fct>    <chr>            <chr>            <chr>            <chr>            <chr>           
     1          1              1 STANDING 2.8858451e-001   -2.0294171e-002  -1.3290514e-001  -9.9527860e-001  -9.8311061e-001 
     2          1              2 STANDING 2.7841883e-001   -1.6410568e-002  -1.2352019e-001  -9.9824528e-001  -9.7530022e-001 

    
  On line 120, we combine the test and training tibbles by observation_id

    #join test and training tibbles
    combined_tibble <- bind_rows(test_tb, training_tb) %>% arrange(subject_id) 
    combined_tibble$observation_id <- 1:nrow(combined_tibble) #assign new observation id to make it unique again ()
    
  Starting on line 125 we use regular expressions to clean up variable names
  
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



  On line 142 we convert numbers from scientific notation

    #convert columns to numeric
    combined_tibble[, c(4:ncol(combined_tibble))] <- sapply(combined_tibble[, c(4:ncol(combined_tibble))], as.numeric)
    
    > combined_tibble
    # A tibble: 10,299 x 69
       subject_id observation_id activity time_ime_body_a… time_ime_body_a… time_ime_body_a… time_ime_body_a… time_ime_body_a…
            <dbl>          <int> <fct>               <dbl>            <dbl>            <dbl>            <dbl>            <dbl>
     1          1              1 STANDING            0.289         -0.0203            -0.133           -0.995           -0.983
     2          1              2 STANDING            0.278         -0.0164            -0.124           -0.998           -0.975

    
    
  On line 146 we use rtidy to make an averages table

      ## Make averages tibble ##
    averages_tibble <- combined_tibble %>%
      select(-observation_id) %>% 
      group_by(subject_id, activity) %>% 
      summarise_all(mean)
    
    
  Finally, we save the tibbles as CSVs
  
    #save tibbles as CSVs
    write.table(combined_tibble , file = "../combined_tibble.csv")
    write.table(averages_tibble , file = "../averages_tibble.csv")