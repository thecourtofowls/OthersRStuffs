# Initialize DataFrame ---------------------------------------------
initialiseDataFrame <- function(x = "Data"){
  a <- data.frame( #Create df of 0' #x can be string column unique id
    Name = x, col1 = c(0), col2 = 0, `3s` = 0, Tot = 0, check.names = F)
  a #returns dataframe
}

dataA <- initialiseDataFrame("Topher") #Initialize datas
dataA
#Printing Function
print_Function <- function(dataframe, header = FALSE){
  if (is.character(dataframe)){ #If supplied argument is a string
    if (dataframe %in% ls(envir = .GlobalEnv) ) { #check data inglobal env
      if (header == FALSE){ #header argument
        a = get(dataframe, envir = .GlobalEnv)
        names(a) <- NULL #remove header
        a
      } else{
        get(dataframe, envir = .GlobalEnv) #supply data with header
      }
    }
  } else {#Else captures the output of function or simply a df
    if (header == FALSE){ #If arg is false
      a = dataframe
      names(a) <- NULL
      a
    } else{
      dataframe
    }
  } 
}

print_Function(dataframe = "dataA", header = TRUE)
print_Function(dataframe = dataA)
#Data Vec for Updating
data_vec <- c("col1", "col2", "3s")
#Updating Function
updateData <- function(dataframe, data_vec ){
  a = get(deparse(substitute(dataframe)), envir = .GlobalEnv) #Check df in global env
  # manipulate data within function
  for (col in data_vec){
    ifelse(col == "col1", a$col1[1] <- a$col1[1]+1,
           ifelse(col == "col2", a$col2[1] <- a$col2[1]+1,
                  a$`3s` <- a$`3s` + 1))}
  
  a$Tot[1] <- a$col1[1] + a$col2[1] + a$`3s`[1] #Totals
  #Update the dataframe outside of the function
  assign(deparse(substitute(dataframe)), a, envir = .GlobalEnv)
  dataframe
}
#Print ur data #We supply function output as input
print_Function(updateData(dataA, data_vec), header = TRUE)
print_Function(updateData(dataA, data_vec = "col2"), header = FALSE)

