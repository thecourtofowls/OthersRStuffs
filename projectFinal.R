   
# 4.1 Initialize Player State ---------------------------------------------

# For each player, we must record the player’s name, the number of times they scored 
# 0, 1, 2, 3 and 5 runs, the number of illegal balls bowled, and the number of times 
# they were given out.

# Write a function initialisePlayer() that takes a player name, and creates and returns a 
# data structure (such as a list) that provides a player’s state at the beginning of the 
# game (with all counts set to zero).

initialisePlayer <- function(x = "Data"){
  a <- data.frame( #Create df of 0's
    Name = x, #Name column
    `0s` = c(0), #0 runs
    `1s` = 0,#1 runs
    `2s` = 0,#2 runs
    `3s` = 0,#3 runs
    `5s` = 0,#5runs
    X = 0,#out
    Out = 0,#illegal
    Tot = 0, check.names = F#total
  )
  a #function returns a data frame similaar to the example within the guidelines
}

#initate playerA and playerB data
playerA <- initialisePlayer("T Smith") #Initialize datas
playerB <- initialisePlayer("N Starc")
#

# Write another function playerScoreBoard that takes a player’s data structure and prints 
# out the contents of the list and the players total number of runs 
# (calculated from the list contents) to provide a scoreboard for the player.
#

playerScoreBoard <- function(dataframe, header = FALSE){
  #Arguments
  #dataframe is player data structure
  #header defines whether to print with column headers(TRUE) or not (FALSE)
  
  if (is.character(dataframe)){ 
    #Check if dataframe argument is a character or string with the is.character()
    #ie if it is then
    if (dataframe %in% ls() ) { #check data existence
      if (header == FALSE){ #If header argument is false
        a = dataframe 
        names(a) <- NULL #remove header
        a #return the dataframe without headers or column names as known in simple english
      } else{ #otherwise, if header argument is TRUE
        dataframe #get dataframe with header and return it as it is
      }
    }
  } else { #If dataframe argument value  is not a sting, then
    if (header == FALSE){ 
      a = dataframe
      names(a) <- NULL
      a
    } else{
      dataframe
    }
  } 
}

#You see the difference in passing string arguments, we took care of that in the function 
#creation, so ....
playerScoreBoard(dataframe = "playerA", header = TRUE) 
playerScoreBoard(dataframe = "playerB")

#passing the arguments but not as string/character values
playerScoreBoard(dataframe = playerA, header = TRUE) 
playerScoreBoard(dataframe = playerB)

#Both of the above provide similar results


# 4.2 Updating the Player State -------------------------------------------

# An over consists of six balls bowled by one bowler to one batsman and the outcome of each 
# ball can be one of 0 runs, 1 run, 2 runs, 3 runs, 5 runs, illegal, or out. 
# The batsman’s state must be updated after each of the balls, but the bowlers state is 
# only adjusted after an illegal ball.

#Write a function updateBatsman that takes the outcome of a ball and the batsman’s state, 
#and returns the batsman’s updated state.

#The rules are

# Rule1:	At any time, there is one bowler and one batsman and any other players 
# are  elders.
# Rule2:	The batsman bats for a set number of overs. where each over consist of six balls
# and each of the overs to be bowled are evenly divided between the remaining 
# players (e.g. 6 overs for one player, 3 for two, 2 for three).
# Rule3:	Due to the game being indoor, no more that one run can be run, but 2, 3, and 5 runs 
# can be awarded for hitting certain targets.
# Rule4:	If a batsman is given out, they lose ve runs, and the batsman continues 
# to bat (so it is possible to nish with a negative number of runs).
# Rule5:	Finally, any illegal deliveries bowled subtract one run from bowler’s 
# batting score and add three to the batsman’s score; a batsman cannot not score 
# runs from an illegal delivery and unlike other forms of cricket an extra ball is not bowled.

updateBatsman <- function(ballOutComes, dataframe){
  
  a = dataframe
  #We are updating scores of batsman at each ballOutComes
  #If any of the outcome occurs, the number of runs for each is added by one
  #Ifelse are the basic loop functions in R
  
  ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+1,
         ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+1, 
                ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+1, 
                       ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+1, 
                              ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+1, 
                                     ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                            a$Out[1] <- a$Out[1]+1))))))
  
  #For total scores,we multiply number of runs times the run type
  a$Tot[1] <- (0*a$`0s`[1])+(1*a$`1s`[1])+(2*a$`2s`[1])+(3*a$`3s`[1])+
    (5*a$`5s`[1])#-(a$X[1])#-(a$Out[1])
  
  #
  if (a$Out >= 1){
    a$Tot[1] = a$Tot[1] + -5#Rule 3
  }
  
  if ((a$X[1] >= 1)){
    a$Tot[1] = a$X[1] * 3 #Rule 5
  }
  
  a$X[1] = 0
  
 a#return the dataframe
}

# Write a function updateBowler that takes the outcome of a ball and the bowler’s state, 
# and returns the bowler’s updated state. Remember that the bowler’s state is only 
# e ected by illegal balls.

updateBowler <- function(ballOutComes, dataframe){
  a = dataframe
  
  #Basic ifelse function used to loop across all instances of ballOutcomes
  ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+0,
         ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+0, 
                ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+0, 
                       ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+0, 
                              ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+0, 
                                     ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                            a$Out[1] <- a$Out[1]+0))))))
  
  a$Tot[1] <- (0*a$`0s`[1])+(1*a$`1s`[1])+(2*a$`2s`[1])+(3*a$`3s`[1])+
    (5*a$`5s`[1])-(1*a$X[1]) #Total calculation plus inclusion of Rule5
  
  a#return the dataframe
}

#Initialize the data structures
playerA <- initialisePlayer("T Smith")
playerB <- initialisePlayer("N Starc")
#
playerA
playerB

#Print Outs
# test batsman
playerScoreBoard(updateBatsman("run0", playerA), header = TRUE)
#Name	0s	1s	2s	3s	5s	X	Out	Tot
#T Smith	1	0	0	0	0	0	0	0
playerScoreBoard(updateBatsman("run1", playerA))
#T Smith	0	1	0	0	0	0	0	1
playerScoreBoard(updateBatsman("run2", playerA))
#T Smith	0	0	1	0	0	0	0	2
playerScoreBoard(updateBatsman("run3", playerA))
#T Smith	0	0	0	1	0	0	3	
playerScoreBoard(updateBatsman("run5", playerA))
#T Smith	0	0	0	0	1	0	0	5
playerScoreBoard(updateBatsman("illegal", playerA))
#T Smith	0	0	0	0	0	1	0	-1
playerScoreBoard(updateBatsman("out", playerA))
#T Smith	0	0	0	0	0	0	1	-5

# test bowler
playerScoreBoard(updateBowler("run0", playerA))
#T Smith	0	0	0	0	0	0	0	0
playerScoreBoard(updateBowler("run5", playerA))
#T Smith	0	0	0	0	0	0	0	0
playerScoreBoard(updateBowler("illegal", playerA))
#T Smith	0	0	0	0	0	1	0	-1

#If not understood, ask

# 4.3 One Over ------------------------------------------------------------

ballOutcomes <- c("run0", "run1", "run2", "run3", "run5", "illegal", "out")

#The rules are

# Rule1:	At any time, there is one bowler and one batsman and any other players 
# are  elders.
# Rule2:	The batsman bats for a set number of overs. where each over consist of six balls
# and each of the overs to be bowled are evenly divided between the remaining 
# players (e.g. 6 overs for one player, 3 for two, 2 for three).
# Rule3:	Due to the game being indoor, no more that one run can be run, but 2, 3, and 5 runs 
# can be awarded for hitting certain targets.
# Rule4:	If a batsman is given out, they lose ve runs, and the batsman continues 
# to bat (so it is possible to nish with a negative number of runs).
# Rule5:	Finally, any illegal deliveries bowled subtract one run from bowler’s 
# batting score and add three to the batsman’s score; a batsman cannot not score 
# runs from an illegal delivery and unlike other forms of cricket an extra ball is not bowled.

#
# Write the functions updateBatsmanOver and updateBowlerOver that takes the outcome of six 
# balls, the state of the batsman and the state of the bowler before the over begins, 
# and returns the state of the batsman and bowler after the over ends, respectively.

updateBatsmanOver <- function(ballOutCome, dataframe){
  a = dataframe
  #Use basic for loop to go through the ball outcomes and update number of runs given the 
  #occurrence of the outcome
  
  for (ballOutComes in ballOutCome){
    ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+1,
           ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+1, 
                  ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+1, 
                         ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+1, 
                                ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+1, 
                                       ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                              a$Out[1] <- a$Out[1]+1))))))}
  #Add totals by multiplying number of runs with run type
  a$Tot[1] <- (0*a$`0s`[1])+(1*(a$`1s`[1]))+(2*a$`2s`[1])+(3*a$`3s`[1])+
    (5*a$`5s`[1])##add scores
  
  if (a$Out[1] >= 1){
    a$Tot[1] = a$Tot[1] + -5*a$Out[1] #Rule 4
  }
  if ((a$X[1] >= 1)){
    a$Tot[1] = a$X[1] * 3 + a$Tot[1] #Rule 5
  }
  a$X[1] = 0
  
  if (a$`1s`[1] > 1){
    ifelse(a$`2s`[1] == 0, a$`2s`[1] <- a$`2s`[1] + a$`1s`[1] - 1, 
           ifelse(a$`3s`[1] == 0, a$`3s`[1] <- a$`3s`[1] + a$`1s`[1] - 1, 
                  ifelse(a$`5s`[1] == 0, a$`5s`[1] <- a$`5s`[1] + a$`1s`[1] - 1, 
                         a$`5s`[1] <- a$`5s`[1]+ a$`1s`[1] - 1)
           ))
  } else {a$`1s` <- a$`1s`}
  
  a
}

updateBowlerOver <- function(ballOutCome, dataframe){
  a = dataframe
  #Use basic for loop to go through the ball outcomes and update number of runs given the 
  #occurrence of the outcome
  for (ballOutComes in ballOutCome){
    ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+0,
           ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+0, 
                  ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+0, 
                         ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+0, 
                                ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+0, 
                                       ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                              a$Out[1] <- a$Out[1]+0))))))
  }
  
  ##Add totals by multiplying number of runs with run type
  a$Tot[1] <- (0*a$`0s`[1])+(1*a$`1s`[1])+(2*a$`2s`[1])+(3*a$`3s`[1])+
    (5*a$`5s`[1])-(1*a$X[1])
  
  #Given that we are modifying the dataframe within a function, we want the updates projected
  #to the dataframe outside of the function to allow printing etc, so basically
  a
}
#
playerA <- initialisePlayer("T Smith")
playerB <- initialisePlayer("N Starc")
playerA
playerB
over = c("run1", "out", "illegal", "run2", "run0", "run1")#Test
playerScoreBoard(updateBatsmanOver(over, playerA), header = TRUE)
#Name	0s	1s	2s	3s	5s	X	Out	Tot
#T Smith	1	2	1	1	0	0	1	2
playerScoreBoard(updateBowlerOver(over, playerB))
#N Starc	0	0	0	0	0	1	0	-1


# 4.4 Match Result --------------------------------------------------------

#The results are made independently and totals made at end of all overs

# The o cial Ultimate Indoor Cricket rules provide a sequencing for the bowler and 
# batter for each over. Below we show the sequence for a two and three player game 
# containing six overs. The variable over provides the over number, the variables 
# bowler and batter provide the id of the player.

# Rule1:	At any time, there is one bowler and one batsman and any other players 
# are  elders.
# Rule2:	The batsman bats for a set number of overs. where each over consist of six balls
# and each of the overs to be bowled are evenly divided between the remaining 
# players (e.g. 6 overs for one player, 3 for two, 2 for three).
# Rule3:	Due to the game being indoor, no more that one run can be run, but 2, 3, and 5 runs 
# can be awarded for hitting certain targets.
# Rule4:	If a batsman is given out, they lose ve runs, and the batsman continues 
# to bat (so it is possible to nish with a negative number of runs).
# Rule5:	Finally, any illegal deliveries bowled subtract one run from bowler’s 
# batting score and add three to the batsman’s score; a batsman cannot not score 
# runs from an illegal delivery and unlike other forms of cricket an extra ball is not bowled.

# Write the function generateOver to randomly sample from the above ball outcomes to 
# provide the outcome of six balls. Run the function and show the result of the over.

source("uicMatchOversOutcome.R")

#Two Player ------------

#I think this 2 functions are well explained by now and no need for unnecessary repetitions
updateBatsmanOver <- function(ballOutCome, dataframe){
  a = dataframe
  #update the run count
  for (ballOutComes in ballOutCome){
    ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+1,
           ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+1, 
                  ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+1, 
                         ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+1, 
                                ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+1, 
                                       ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                              a$Out[1] <- a$Out[1]+1))))))}
  #Totals
  a$Tot[1] <- (0*a$`0s`[1])+(1*(a$`1s`[1]))+(2*a$`2s`[1])+(3*a$`3s`[1])+ 
    (5*a$`5s`[1])
  
  if (a$Out[1] >= 1){#Remove Out Scores
    a$Tot[1] = a$Tot[1] + -5*a$Out[1]
  }
  if ((a$X[1] >= 1)){#Add illegals suplied
    a$Tot[1] = a$X[1] * 3 + a$Tot[1]
  }
  a$X[1] = 0
  a
}

updateBowlerOver <- function(ballOutCome, dataframe){
  a = dataframe
  #update runs
  for (ballOutComes in ballOutCome){
    ifelse(ballOutComes == "run0", a$`0s`[1] <- a$`0s`[1]+0,
           ifelse(ballOutComes == "run1", a$`1s`[1] <- a$`1s`[1]+0, 
                  ifelse(ballOutComes == "run2", a$`2s`[1] <- a$`2s`[1]+0, 
                         ifelse(ballOutComes == "run3", a$`3s`[1] <- a$`3s`[1]+0, 
                                ifelse(ballOutComes == "run5", a$`5s`[1] <- a$`5s`[1]+0, 
                                       ifelse(ballOutComes == "illegal", a$X[1] <- a$X[1]+1, 
                                              a$Out[1] <- a$Out[1]+0))))))
  }
  #Totals
  a$Tot[1] <- (0*a$`0s`[1])+(1*a$`1s`[1])+(2*a$`2s`[1])+(3*a$`3s`[1])+
    (5*a$`5s`[1])-(1*a$X[1])+(1*a$Out[1])
  return(a)
}

twoPlayer <- list(
  ##	batter and bowler for each over 
  list(over = 1, bowler = 1, batter = 2), list(over = 2, bowler = 2, batter = 1), 
  list(over = 3, bowler = 1, batter = 2), list(over = 4, bowler = 2, batter = 1), 
  list(over = 5, bowler = 1, batter = 2), list(over = 6, bowler = 2, batter = 1)
)

over = c("run1", "out", "illegal", "run2", "run0", "run1")#Test




##choose player 
overSequence <- twoPlayer 

#The following list shows “T Smith” with id 1, “B Border” with id 2, and “S Ponting” with id 3.
players <- list(
  initialisePlayer("T Smith"), initialisePlayer("B Border"), initialisePlayer("S Ponting")
)

#Substituted the player names with the variables 
playerA <- players[[1]]
playerB <- players[[2]]
playerC <- players[[3]]


#TwoPlayers only------------------
totalsFunction <- function(playerX=playerA, sequence = twoPlayer, over_s = over, playerNumber = 1){
  
  playerX = playerX
  # 2 players, One Round
  #A dataframe will be easier to work with to obtain the bowler batsman positions per over
  play_df = data.frame(data.table::rbindlist(sequence, fill=TRUE))
  
  ## Assuming playerNumber is player
  #list for storing scores per over
  bow_lists <- list() #Bowler
  bat_lists <- list() #batman
  #
  for (i in 1:nrow(play_df)){ 
    if (sequence[[i]]$bowler == playerNumber){
      player = playerX
      bow_lists[[i]] <- updateBowlerOver(over_s[[i]], player) #update player
    }
    if (sequence[[i]]$batter == playerNumber){
      player = playerX
      bat_lists[[i]] <- updateBatsmanOver(over_s[[i]], player) #update player
    }
  }
  
  #Bind all scores intoa datframe, then aggregate all runs and totals
  if (playerNumber == 1){
    over_scores <- rbind(bow_lists[[1]],bow_lists[[3]],bow_lists[[5]],
                         bat_lists[[2]], bat_lists[[4]], bat_lists[[6]])
  } else {
    over_scores <- rbind(bow_lists[[2]],bow_lists[[4]],bow_lists[[6]],
                         bat_lists[[1]], bat_lists[[3]], bat_lists[[5]])
  }
  #Aggregate scores
  m <- aggregate(
    . ~ Name,
    data = over_scores,
    FUN = sum)
  m
}
#
playerA <- totalsFunction(playerX=playerA, sequence = twoPlayer, over_s = over, playerNumber = 1)
playerB <- totalsFunction(playerX=playerB, sequence = twoPlayer, over_s = over, playerNumber = 2)

#Final score
playerScoreBoard(playerA, header = TRUE)#players[[1]]
playerScoreBoard(playerB, header = TRUE)#players[[2]]


#Three Player ---------------------------------

#threePlayers
threePlayer <- list(
  ##	batter and bowler for each over 
  list(over = 1, bowler = 1, batter = 2), list(over = 2, bowler = 2, batter = 3), 
  list(over = 3, bowler = 3, batter = 2), list(over = 4, bowler = 2, batter = 1), 
  list(over = 5, bowler = 1, batter = 3), list(over = 6, bowler = 3, batter = 1)
)
#
overSequence <- threePlayer
#The following list shows “T Smith” with id 1, “B Border” with id 2, and 
#“S Ponting” with id 3.
players <- list(
  initialisePlayer("T Smith"), initialisePlayer("B Border"), initialisePlayer("S Ponting")
)

playerA <- players[[1]]
playerB <- players[[2]]
playerC <- players[[3]]
#
totalsFunction <- function(playerX=playerA, sequence = threePlayer, over_s = over, playerNumber = 1){
  
  playerX = playerX
  # 2 players, One Round
  #A dataframe will be easier to work with to obtain the bowler batsman positions per over
  play_df = data.frame(data.table::rbindlist(sequence, fill=TRUE))
  
  ## Assuming playerNumber is player
  #list for storing scores per over
  bow_lists <- list() #Bowler
  bat_lists <- list() #batman
  #
  for (i in 1:nrow(play_df)){ #Rowwise calculation of runs and totals
    if (sequence[[i]]$bowler == playerNumber){
      player = playerX
      bow_lists[[i]] <- updateBowlerOver(over_s[[i]], player) #update player
    }
    if (sequence[[i]]$batter == playerNumber){
      player = playerX
      bat_lists[[i]] <- updateBatsmanOver(over_s[[i]], player) #update player
    }
  }
  
  #Bind all scores intoa datframe, then aggregate all runs and totals
  if (playerNumber == 1){
    over_scores <- rbind(bow_lists[[1]],bow_lists[[5]],
                         bat_lists[[4]], bat_lists[[6]])
  } else {
    if (playerNumber == 2){
      over_scores <- rbind(bow_lists[[2]],bow_lists[[4]],
                           bat_lists[[1]], bat_lists[[3]])
    }
    else {
      over_scores <- rbind(bow_lists[[3]],bow_lists[[6]],
                           bat_lists[[2]], bat_lists[[5]])
    }
  }
  #Aggregate scores
  m <- aggregate(
    . ~ Name,
    data = over_scores,
    FUN = sum)
  m #return
}

playerA <- totalsFunction(playerX=playerA, sequence = threePlayer, over_s = over, playerNumber = 1)
playerB <- totalsFunction(playerX=playerB, sequence = threePlayer, over_s = over, playerNumber = 2)
playerC <- totalsFunction(playerX=playerC, sequence = threePlayer, over_s = over, playerNumber = 3)

#Final score
playerScoreBoard(playerA, header = TRUE)#players[[1]]
playerScoreBoard(playerB, header = TRUE)#players[[2]]
playerScoreBoard(playerC, header = TRUE) #players[[3]]
#