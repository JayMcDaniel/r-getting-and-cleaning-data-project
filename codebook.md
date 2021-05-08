CODEBOOK

The data described below can be found in the new "combined_tibble.csv" and "averages_tibble.csv" and were made with "run_analysis.R".

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals (time_acceleration) (time_gyro). These time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (time_body_acceleration_)<xyz> and (time_gravity_acceleration_)<xyz> using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (time_body_acceleration_jerk_)<xyz> and time_body_gyro_jerk)<xyz>. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (time_body_acceleration_magnitude, time_gravity_acceleration_magnitude, time_body_acceleration_jerk_magnitude, time_body_gyro_magnitude, time_body_gyro_jerk_magnitude). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing frequency_body_acceleration_<xyz>, frequency_body_acceleration_jerk<xyz>, frequency_body_gyro_<xyz>, frequency_body_acceleration_jerk_magnitude, frequency_body__gyro_magnitude, frequency_body_gyro_jerk_magnitude. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern: x,y,z are used to denote 3-axial signals in the X, Y and Z directions.
Values for these have been converted from scientifc notation to numeric. The averages_tibble, made in run_analysis.R, contains all of the same variables except observation_id and displays the mean values by subject by activity.

 subject_id : ID unique to the subject (1-30)                                                     
 observation_id : ID (added) unique to observation (1-10299)                                                   
 activity : Activity recorded: ”WALKING”, ”WALKING UPSTAIRS”, "WALKING DOWNSTAIRS”, “SITTING”,”STANDING", "LAYING"         time_body_acceleration_mean_value_x                        
 The variables listeed below are the same data as the original, keeping only the means and standard deviation variables. The names have been spelled out to be more clear. In averages_tibble, these are simply the means of each activity by subject id:
 averages_tibble <- combined_tibble %>%
  select(-observation_id) %>% 
  group_by(subject_id, activity) %>% 
  summarise_all(mean)
 
 time_body_acceleration_mean_value_y                               
 time_body_acceleration_mean_value_z                               
 time_body_acceleration_standard_deviation_x                       
 time_body_acceleration_standard_deviation_y                       
 time_body_acceleration_standard_deviation_z                       
 time_gravity_acceleration_mean_value_x                            
 time_gravity_acceleration_mean_value_y                            
 time_gravity_acceleration_mean_value_z                            
 time_gravity_acceleration_standard_deviation_x                    
 time_gravity_acceleration_standard_deviation_y                    
 time_gravity_acceleration_standard_deviation_z                    
 time_body_acceleration_jerk_mean_value_x                          
 time_body_acceleration_jerk_mean_value_y                          
 time_body_acceleration_jerk_mean_value_z                          
 time_body_acceleration_jerk_standard_deviation_x                  
 time_body_acceleration_jerk_standard_deviation_y                  
 time_body_acceleration_jerk_standard_deviation_z                  
 time_body_gyro_mean_value_x                                       
 time_body_gyro_mean_value_y                                       
 time_body_gyro_mean_value_z                                       
 time_body_gyro_standard_deviation_x                               
 time_body_gyro_standard_deviation_y                               
 time_body_gyro_standard_deviation_z                               
 time_body_gyro_jerk_mean_value_x                                  
 time_body_gyro_jerk_mean_value_y                                  
 time_body_gyro_jerk_mean_value_z                                  
 time_body_gyro_jerk_standard_deviation_x                          
 time_body_gyro_jerk_standard_deviation_y                          
 time_body_gyro_jerk_standard_deviation_z                          
 time_body_acceleration_magnitude_mean_value                       
 time_body_acceleration_magnitude_standard_deviation               
 time_gravity_acceleration_magnitude_mean_value                    
 time_gravity_acceleration_magnitude_standard_deviation            
 time_body_acceleration_jerk_magnitude_mean_value                  
 time_body_acceleration_jerk_magnitude_standard_deviation          
 time_body_gyro_magnitude_mean_value                               
 time_body_gyro_magnitude_standard_deviation                       
 time_body_gyro_jerk_magnitude_mean_value                          
 time_body_gyro_jerk_magnitude_standard_deviation                  
 frequency_body_acceleration_mean_value_x                          
 frequency_body_acceleration_mean_value_y                          
 frequency_body_acceleration_mean_value_z                          
 frequency_body_acceleration_standard_deviation_x                  
 frequency_body_acceleration_standard_deviation_y                  
 frequency_body_acceleration_standard_deviation_z                  
 frequency_body_acceleration_jerk_mean_value_x                     
 frequency_body_acceleration_jerk_mean_value_y                     
 frequency_body_acceleration_jerk_mean_value_z                     
 frequency_body_acceleration_jerk_standard_deviation_x             
 frequency_body_acceleration_jerk_standard_deviation_y             
 frequency_body_acceleration_jerk_standard_deviation_z             
 frequency_body_gyro_mean_value_x                                  
 frequency_body_gyro_mean_value_y                                  
 frequency_body_gyro_mean_value_z                                  
 frequency_body_gyro_standard_deviation_x                          
 frequency_body_gyro_standard_deviation_y                          
 frequency_body_gyro_standard_deviation_z                          
 frequency_body_acceleration_magnitude_mean_value                  
 frequency_body_acceleration_magnitude_standard_deviation          
 frequency_body_body_acceleration_jerk_magnitude_mean_value        
 frequency_body_body_acceleration_jerk_magnitude_standard_deviation
 frequency_body_body_gyro_magnitude_mean_value                     
 frequency_body_body_gyro_magnitude_standard_deviation             
 frequency_body_body_gyro_jerk_magnitude_mean_value                
 frequency_body_body_gyro_jerk_magnitude_standard_deviation     