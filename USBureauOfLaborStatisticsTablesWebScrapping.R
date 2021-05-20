library(tidyverse)
library(rvest)
library(XML)


# Table1 ------------------------------------------------------------------

#Table 1. Union affiliation of employed wage and salary workers by 
#selected characteristics, 2019-2020 annual averages

table_1_union_affiliation <- "https://www.bls.gov/news.release/union2.t01.htm"
table_1 <- table_1_union_affiliation %>%
  read_html() %>% 
  html_nodes(xpath='//*[@id="union_a01"]') %>% 
  html_table(fill = TRUE)
table_1 <- table_1[[1]]
View(table_1)

#Data
table_1_age <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,4:11),]
table_1_sex_men <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,13:20),]
table_1_sex_women <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,22:29),]

table_1_race_white <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,32:34),]
table_1_race_black <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,36:38),]
table_1_race_asian <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,40:42),]
table_1_race_hispanic <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,44:46),]

table_1_work_status <- as.data.frame(apply(table_1,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,49:50),]


clean_table_1 <- function(table_1){
  
  table_1[table_1==""] <- NA
  table_1 <- na.omit(table_1)
  #View(table_1)
  table_1_l <- t(table_1[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_1_l) <- c("Year","Total",table_1[-1,1])
  
  table_1_l$Year <- ifelse(str_length(table_1_l$Year) == 4, as.numeric(table_1_l$Year), as.numeric(str_sub(table_1_l$Year,1,4)))
  table_1_l$Total <- gsub("\\(.)","",table_1_l$Total)
  table_1_l$Characteristic <- gsub("\\(.)","",table_1_l$Characteristic)
  
  table_1_l$Characteristic <- ifelse(
    table_1_l$Total == "Totalemployed", "Totalemployed", table_1_l$Characteristic)
  
  table_1_l[,3] <- c("Totalemployed", "Total", "Percentofemployed", "Total", "Percentofemployed",
                     "Totalemployed", "Total","Percentofemployed", "Total","Percentofemployed")
  table_1_l
  
}

table_1_age <- clean_table_1(table_1_age) %>% as_tibble() %>% 
  add_column(age = rep("Age",10))
table_1_sex_men <- clean_table_1(table_1_sex_men) %>% 
  as_tibble() %>% add_column(gender = rep("Men",10))
table_1_sex_women <- clean_table_1(table_1_sex_women) %>% 
  as_tibble() %>% add_column(gender = rep("Women",10))
table_1_race_white <- clean_table_1(table_1_race_white) %>% 
  as_tibble() %>% add_column(race = rep("White",10))
table_1_race_black <- clean_table_1(table_1_race_black) %>% 
  as_tibble() %>% add_column(race = rep("Black",10))
table_1_race_asian <- clean_table_1(table_1_race_asian) %>% 
  as_tibble() %>% add_column(race = rep("Asian",10))
table_1_race_hispanic <- clean_table_1(table_1_race_hispanic) %>% 
  as_tibble() %>% add_column(race = rep("Hispanic",10))
table_1_work_status <- clean_table_1(table_1_work_status) %>% 
  as_tibble() %>% add_column(status = rep("Work",10))

View(table_1_age)


# Table2 ------------------------------------------------------------------

#Table 2. Median weekly earnings of full-time wage and salary workers by union affiliation 
#and selected characteristics, 2019-2020 annual averages

table_2_median_weekly_earnings <- "https://www.bls.gov/news.release/union2.t02.htm"
table_2 <- table_2_median_weekly_earnings %>%
  read_html() %>% 
  html_nodes(xpath='//*[@id="union_a02"]') %>% 
  html_table(fill = TRUE)
table_2 <- table_2[[1]]
View(table_2)


table_2_age <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,3:10),]
table_2_sex_men <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,12:19),]
table_2_sex_women <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,21:28),]

table_2_race_white <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,31:33),]
table_2_race_black <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,35:37),]
table_2_race_asian <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,39:41),]
table_2_race_hispanic <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,43:45),]

table_2_work_status <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,43:45),]


clean_table_2 <- function(table_2){
  table_2 <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)
  table_2[table_2==""] <- NA
  table_2 <- na.omit(table_2)
  
  #View(table_2)
  
  table_2_l <- t(table_2[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_2_l) <- c("Year","Total",table_2[-1,1])
  
  table_2_l$Year <- ifelse(str_length(table_2_l$Year) == 4, as.numeric(table_2_l$Year), as.numeric(str_sub(table_2_l$Year,1,4)))
  table_2_l$Total <- gsub("\\(.)","",table_2_l$Total)
  table_2_l$`Total, 16 years and over` <- gsub(
    "\\$","", table_2_l$`Total, 16 years and over`)
  table_2_l
}

#
clean_table_22 <- function(table_2){
  table_2 <- as.data.frame(apply(table_2,2,function(x) trimws(x) ), stringsAsFactors = FALSE)
  table_2[table_2==""] <- NA
  table_2 <- na.omit(table_2)
  
  #View(table_2)
  
  table_2_l <- t(table_2[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_2_l) <- c("Year","Total",table_2[-1,1])
  
  table_2_l$Year <- ifelse(str_length(table_2_l$Year) == 4, as.numeric(table_2_l$Year), as.numeric(str_sub(table_2_l$Year,1,4)))
  table_2_l$Total <- gsub("\\(.)","",table_2_l$Total)
  table_2_l
}

table_2_age <- clean_table_2(table_2_age) %>% as_tibble() %>% 
  add_column(age = rep("Age",8))
table_2_sex_men <- clean_table_22(table_2_sex_men) %>% 
  as_tibble() %>% add_column(gender = rep("Men",8))
table_2_sex_women <- clean_table_22(table_2_sex_women) %>% 
  as_tibble() %>% add_column(gender = rep("Women",8))
table_2_race_white <- clean_table_22(table_2_race_white) %>% 
  as_tibble() %>% add_column(race = rep("White",8))
table_2_race_black <- clean_table_22(table_2_race_black) %>% 
  as_tibble() %>% add_column(race = rep("Black",8))
table_2_race_asian <- clean_table_22(table_2_race_asian) %>% 
  as_tibble() %>% add_column(race = rep("Asian",8))
table_2_race_hispanic <- clean_table_22(table_2_race_hispanic) %>% 
  as_tibble() %>% add_column(race = rep("Hispanic",8))
table_2_work_status <- clean_table_22(table_2_work_status) %>% 
  as_tibble() %>% add_column(status = rep("Work",8))

View(table_2_age)



# Table 3 -----------------------------------------------------------------

#Table 3. Union affiliation of employed wage and salary workers by occupation and 
#industry, 2019-2020 annual averages

table_3_union_affiliation <- "https://www.bls.gov/news.release/union2.t03.htm"
table_3 <- table_3_union_affiliation %>%
  read_html() %>% 
  html_nodes(xpath='//*[@id="union_a03"]') %>% 
  html_table(fill = TRUE)
table_3 <- table_3[[1]]

table_3_occupation <- as.data.frame(apply(table_3,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2,4:32),]
table_3_industry <- as.data.frame(apply(table_3,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,2, 35:75),]


clean_table_3 <- function(table_3){
  
  table_3[table_3==""] <- NA
  table_3 <- na.omit(table_3)
  
  #View(table_3)
  
  table_3_l <- t(table_3[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_3_l) <- c("Year","Total",table_3[-1,1])
  
  table_3_l$Year <- ifelse(str_length(table_3_l$Year) == 4, as.numeric(table_3_l$Year), as.numeric(str_sub(table_3_l$Year,1,4)))
  table_3_l$Total <- gsub("\\(.)","",table_3_l$Total)
  table_3_l$`Occupation and industry` <- gsub("\\(.)","",table_3_l$`Occupation and industry`)
  
  table_3_l$`Occupation and industry` <- ifelse(
    table_3_l$Total == "Totalemployed", "Totalemployed", table_3_l$`Occupation and industry`)
  
  table_3_l[,3] <- c("Totalemployed", "Total", "Percentofemployed", "Total", "Percentofemployed",
                     "Totalemployed", "Total","Percentofemployed", "Total","Percentofemployed")
  table_3_l
  
}

table_3_occupation <- clean_table_3(table_3_occupation) %>% as_tibble() %>% 
  add_column(occupation = rep("Occupation",10))
table_3_industry <- clean_table_3(table_3_industry) %>% 
  as_tibble() %>% add_column(Industry = rep("Industry",10))

View(table_3_occupation)
View(table_3_industry)


# Table 4 -----------------------------------------------------------------

#Table 4. Median weekly earnings of full-time wage and salary workers by union 
#affiliation, occupation, and industry, 2019-2020 annual averages

table_4_median_weekly_earnings <- "https://www.bls.gov/news.release/union2.t04.htm"
table_4 <- table_4_median_weekly_earnings %>%
  read_html() %>% 
  html_nodes(xpath='//*[@id="union_a04"]') %>% 
  html_table(fill = TRUE)
table_4 <- table_4[[1]]
View(table_4)

table_4_occupation <- as.data.frame(apply(table_4,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1,4:32),]
table_4_industry <- as.data.frame(apply(table_4,2,function(x) trimws(x) ), stringsAsFactors = FALSE)[c(1, 35:75),]


clean_table_4 <- function(table_4){
  
  table_4[table_4==""] <- NA
  table_4 <- na.omit(table_4)
  
  #View(table_4)
  
  table_4_l <- t(table_4[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_4_l) <- c("Year","Total",table_4[-1,1])
  
  table_4_l$Year <- ifelse(str_length(table_4_l$Year) == 4, as.numeric(table_4_l$Year), as.numeric(str_sub(table_4_l$Year,1,4)))
  table_4_l$Total <- gsub("\\(.)","",table_4_l$Total)
  table_4_l$`Management, professional, and related occupations` <- gsub(
    "\\$","", table_4_l$`Management, professional, and related occupations`)
  
  table_4_l
}

#
clean_table_42 <- function(table_4){
  
  table_4[table_4==""] <- NA
  table_4 <- na.omit(table_4)
  #View(table_4)
  table_4_l <- t(table_4[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_4_l) <- c("Year","Total",table_4[-1,1])
  
  table_4_l$Year <- ifelse(str_length(table_4_l$Year) == 4, as.numeric(table_4_l$Year), as.numeric(str_sub(table_4_l$Year,1,4)))
  table_4_l$Total <- gsub("\\(.)","",table_4_l$Total)
  
  table_4_l
}

table_4_occupation <- clean_table_4(table_4_occupation) %>% as_tibble() %>% 
  add_column(Occupation = rep("Occupation",8))
table_4_industry<- clean_table_42(table_4_industry) %>% 
  as_tibble() %>% add_column(Industry = rep("Industry",8))

View(table_4_occupation)
View(table_4_industry)


# Table 5 -----------------------------------------------------------------

#Table 5. Union affiliation of employed wage and salary workers by state,
#2019-2020 annual averages

table_5_state_wages <- "https://www.bls.gov/news.release/union2.t05.htm"
table_5 <- table_5_state_wages %>%
  read_html() %>% 
  html_nodes(xpath='//*[@id="union_a05"]') %>% 
  html_table(fill = TRUE)
table_5 <- table_5[[1]]
View(table_5)

table_5 <- table_5[c(1:57),]
table_5[table_5==""] <- NA
table_5 <- na.omit(table_5)
View(table_5)

table_5_states <- as.data.frame(apply(table_5,2,function(x) trimws(x) ), stringsAsFactors = FALSE)
View(table_5_states)

clean_table_5 <- function(table_5){
  table_5[table_5==""] <- NA
  table_5 <- na.omit(table_5)
  
  #View(table_5)
  
  table_5_l <- t(table_5[,-1]) %>% as.data.frame() %>% 
    rownames_to_column("Year")
  colnames(table_5_l) <- c("Year","Total",table_5[-1,1])
  
  table_5_l$Year <- ifelse(str_length(table_5_l$Year) == 4, as.numeric(table_5_l$Year), as.numeric(str_sub(table_5_l$Year,1,4)))
  table_5_l$Total <- gsub("\\(.)","",table_5_l$Total)
  table_5_l$State <- gsub("\\(.)","",table_5_l$State)
  
  table_5_l$State <- ifelse(table_5_l$Total == "Totalemployed", "Totalemployed", table_5_l$State)
  table_5_l[,3] <- c("Totalemployed", "Total", "Percentofemployed", "Total", "Percentofemployed",
                     "Totalemployed", "Total","Percentofemployed", "Total","Percentofemployed")
  table_5_l
  
}

table_5_states <- clean_table_5(table_5_states) %>% as_tibble()
View(table_5_states)

# Other -------------------------------------------------------------------