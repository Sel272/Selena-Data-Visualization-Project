# Load the data
library(plotly)
library(tidyverse)
# Source: https://legacy.baseballprospectus.com/compensation/?team=WAS
salary_2019 <- read_csv("../data/Salary_2019.csv")
# Source: https://www.spotrac.com/mlb/washington-nationals/payroll/2023/
salary_2023 <- read_csv("../data/Salary_2023.csv")

# Looking at position and salary column
salary_2019 <- salary_2019 %>% dplyr::select("Pos","Salary") %>% na.omit()
salary_2023 <- salary_2023 %>% dplyr::select("POS.","BASE SALARY") %>% na.omit()

# check positions in each dataset
# unique(salary_2019$Pos)
# unique(salary_2023$`POS.`)

# replace the 2023 "RP/CL" to "RP", change the dollar format into value format
salary_2023 <- salary_2023 %>% mutate(Pos = ifelse(`POS.`!="RP/CL",`POS.`,"RP")) %>% mutate(Salary_2023=as.numeric(gsub("\\$", "", gsub(",", "", `BASE SALARY`))))  %>% dplyr::select(Pos, Salary_2023)

# change the 2019 data dollar format into value format
salary_2019 <- salary_2019 %>% mutate(Salary_2019=as.numeric(gsub("\\$", "", gsub(",", "", Salary))))

# Group by position
salary_2023_1 <- salary_2023 %>% group_by(Pos) %>% summarize(salary_sum_2023=sum(as.numeric(Salary_2023)))
# calculate total
salary_2023_1$total_2023 <- sum(salary_2023_1$salary_sum_2023)
# calculate percentage
salary_2023_1$percentage_2023 <- salary_2023_1$salary_sum_2023/salary_2023_1$total_2023

# Group by position
salary_2019_1 <- salary_2019 %>% group_by(Pos) %>% summarize(salary_sum_2019=sum(as.numeric(Salary_2019)))
# calculate total
salary_2019_1$total_2019 <- sum(salary_2019_1$salary_sum_2019)
# calculate percentage
salary_2019_1$percentage_2019 <- salary_2019_1$salary_sum_2019/salary_2019_1$total_2019

# Choose the top 4 and combine the rest
top_four_2019 <- salary_2019_1 %>% arrange(desc(percentage_2019)) %>% slice(1:4)
others_2019 <- salary_2019_1 %>% arrange(desc(percentage_2019)) %>% slice(5:n()) %>% summarise(Pos = 'Others',salary_sum_2019 = sum(salary_sum_2019),total_2019 = first(total_2019), percentage_2019 = sum(percentage_2019))
salary_2019_final <- rbind(top_four_2019,others_2019)
# Rename the positions
salary_2019_final <- salary_2019_final %>% mutate(Pos= case_when(
  Pos == "SP" ~ "Starting Pitcher",
  Pos == "1B"~ "First Baseman",
  Pos == "3B"~ "Other Baseman",
  Pos == "RP"~ "Relief Pitcher",
  TRUE ~ "Others"))

# Get the total salary for 2019
salary_total_2019 <- mean(salary_2019_final$total_2019,na.rm=TRUE)

# Choose the top 4 and combine the rest
top_four_2023 <- salary_2023_1 %>% arrange(desc(percentage_2023)) %>% slice(1:4)
others_2023 <- salary_2023_1 %>% arrange(desc(percentage_2023)) %>% slice(5:n()) %>% summarise(Pos = 'Others',salary_sum_2023 = sum(salary_sum_2023),total_2023 = first(total_2023), percentage_2023 = sum(percentage_2023))
salary_2023_final <- rbind(top_four_2023,others_2023)
# Rename the positions
salary_2023_final <- salary_2023_final %>% mutate(Pos= case_when(
  Pos == "SP" ~ "Starting Pitcher",
  Pos == "1B"~ "First Baseman",
  Pos == "2B"~ "Other Baseman",
  Pos == "RP"~ "Relief Pitcher",
  TRUE ~ "Others"))

# Get the total salary for 2023
salary_total_2023 <- mean(salary_2023_final$total_2023,na.rm=TRUE)

salary_combined <- salary_2019_final %>% left_join(salary_2023_final,by='Pos') %>% mutate(change_percent = (percentage_2023-percentage_2019)) %>% mutate(change_dollar = salary_sum_2023- salary_sum_2019) %>% mutate(percentage_shift =change_dollar/salary_sum_2019) %>% dplyr::select("Pos","change_percent","change_dollar","percentage_shift")

# Create separate hover texts for each metric
hover_text_dollars <- with(salary_combined, paste(
  "Position: ", Pos, "<br>",
  "Change in Dollars: $", format(change_dollar, big.mark = ",")
))

hover_text_percent <- with(salary_combined, paste(
  "Position: ", Pos, "<br>",
  "Change Percent: ", format(change_percent * 100, digits = 2, nsmall = 2), "%"
))

hover_text_shift <- with(salary_combined, paste(
  "Position: ", Pos, "<br>",
  "Percentage Shift: ", format(percentage_shift * 100, digits = 2, nsmall = 2), "%"
))

# Create the initial plot with the default display set to 'change_dollar'
p <- plot_ly(
  data = salary_combined, 
  x = ~Pos, 
  y = ~change_dollar, 
  type = 'bar', 
  name = 'Change in Dollars',
  text = ~hover_text_dollars, # Assign initial hover text
  hoverinfo = "text", # Specify that hoverinfo should show text
  marker = list(color = 'rgb(49,130,189)'),
  textposition = 'none'
)

# Adding the update menu for toggling
p <- p %>% layout(
  title = "Washington Nationals Payroll Changes from 2019 to 2023",
  xaxis = list(title = "Position"),
  yaxis = list(title = "Change in Dollars"), # Initial y-axis title
  updatemenus = list(
    list(
      type = "buttons",
      direction = "left",
      x = 0,
      xanchor = "left",
      y = -0.1,
      yanchor = "top",
      buttons = list(
        list(
          method = "update",
          args = list(list("y" = list(salary_combined$change_dollar), "text" = list(hover_text_dollars)), 
                      list("yaxis.title" = "Change in Dollars")),
          label = "Change in Dollars"
        ),
        list(
          method = "update",
          args = list(list("y" = list(salary_combined$change_percent), "text" = list(hover_text_percent)),
                      list("yaxis.title" = "Change in Proportion")),
          label = "Change in Proportion"
        ),
        list(
          method = "update",
          args = list(list("y" = list(salary_combined$percentage_shift), "text" = list(hover_text_shift)),
                      list("yaxis.title" = "Proportion Shift Based on 2019 Payroll")),
          label = "Proportion Shift Based on 2019 Dollars"
        )
      )
    )
  )
)

# Print the plot
p