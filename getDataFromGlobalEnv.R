#
ls()
#Data Frames
df <- data.frame( a = seq(1:5), 
                  b = seq(6:10))

df1 <- data.frame( a = seq(1:5), 
                   b = seq(6:10))

df2 <- data.frame( a = seq(1:5), 
                   b = seq(6:10))

#List DataFrame #End with number
ls()[grepl("[0-9]$",ls())]  #Only captures object names of interest
#Put them into a vector
ls_data_frame <- c( ls()[grepl("[0-9]$",ls())]) #change to vector
ls_data_frame
#Convert the characters to symbol
dfs <- sapply(ls_data_frame, FUN = function(x) as.symbol(x), USE.NAMES = TRUE)
dfs
#bind the data frames
data <- cbind.data.frame(dfs)
data
#
