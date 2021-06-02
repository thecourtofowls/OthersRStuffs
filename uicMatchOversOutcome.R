## 1
#over = c("run1", "out", "illegal", "run2", "run0", "run1")#Test
set.seed(45)
## 2
ballOutcomes <- c("run0", "run1", "run2", "run3", "run5", "illegal", "out")
generateOver <- function(ballOutcomes = ballOutcomes){
  out_list <- list()
  #x = sample(ballOutcomes, size = 36, replace = T) #sample random outcomes
  for (i in 1:6){
    out_list[[i]] <- sample(ballOutcomes, size =6)
  }
  out_list
}

over <- generateOver(ballOutcomes)
print(over)

