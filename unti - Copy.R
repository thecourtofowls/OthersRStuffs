
# Q6
df_val = 24
mu_val = 12
sd_val = 5

t_value = (mu_val - 0) / (sd_val / sqrt(df_val))
sample_se = sd_val/sqrt(df_val)
alpha = 0.05
degrees_freedom = df_val - 1
t_score = qt(p = alpha/2, df= degrees_freedom, lower.tail=F)
margin_error <- t_score * sample_se
lower_bound <- mu_val - margin_error
upper_bound <- mu_val + margin_error
print(c(lower_bound,upper_bound))
#


# Q8
# a
Font <- as.factor(c(1, 1, 1, 2, 2, 2, 3, 3, 3))
Speed <- c(60, 94, 80, 90, 140, 100, 130, 200, 150)
aovdata <- data.frame(Speed, Font)
aovdata
#
aovdata$Font = factor(
  aovdata$Font, levels = c(1,2,3), 
  labels =  c('Arial', 'Lexic', 'LexPro')
)
aovdata
# d
# split into a list
aov_data_list <- with(aovdata, split(Speed, Font))
# mean and standard deviation
grand_mean <- mean(unlist(aov_data_list))
group_mean <- sapply(aov_data_list, mean)
group_sd <- sapply(aov_data_list, sd)
n <- sapply(aov_data_list, length)
#
Total_SS <- sum((unlist(aov_data_list) - grand_mean)^2)
Error_SS <- sum(((n - 1) * group_sd^2))
Group_SS <- Total_SS - Error_SS
# Degree of freedom 
Total_df <- length(unlist(aov_data_list)) - 1
Error_df <- length(unlist(aov_data_list)) - length(n)
Group_df <- Total_df - Error_df
# Means of Sum of Squares:
MS_Error <- Error_SS/Error_df
MS_Group <- Group_SS/Group_df
# Test Statistic (F) and corresponding P-values:
F_value <- MS_Group / MS_Error
p_value <- pf(F_value, Group_df, Error_df, lower.tail = FALSE)
#
aov_data_anova_output <- matrix(
  c(Group_df, Error_df, Total_df,
    Group_SS, Error_SS, Total_SS,
    MS_Group, MS_Error, NA,
    F_value, NA, NA,
    p_value, NA, NA),
  ncol = 5)
dimnames(aov_data_anova_output) <- list(
  "Group" = c("Between", "Within", "Total"),
  "ANOVA" = c("Df", "Sum_Sq", "Mean_Sq", "F_value", "P_value")
)
#
printCoefmat(aov_data_anova_output, signif.stars = TRUE, 
             has.Pvalue = TRUE, digits = 4, na.print = "")


