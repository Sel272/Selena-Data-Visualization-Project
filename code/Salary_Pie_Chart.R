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
  Pos == "3B"~ "Third Baseman",
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
  Pos == "2B"~ "Second Baseman",
  Pos == "RP"~ "Relief Pitcher",
  TRUE ~ "Others"))

# Get the total salary for 2023
salary_total_2023 <- mean(salary_2023_final$total_2023,na.rm=TRUE)


# Create pie chart for the first dataset
pie1 <- plot_ly(salary_2019_final, labels = ~Pos, values = ~salary_sum_2019, type = 'pie',
                textinfo = 'percent',
                text = ~paste("2019 Total Payroll:", format(salary_total_2019, big.mark = ",", scientific = FALSE), "<br>Position:", salary_2019_final$Pos, "<br>Salary:",format(salary_2019_final$salary_sum_2019, big.mark = ",", scientific = FALSE)),
                hoverinfo = 'text',
                textposition = 'inside',     # Position the text inside the slices
                marker = list(
                  colors = c('#0072B2','#F0E442', '#D55E00', '#CC79A7', '#009E73'), # Assign new colors
                  line = list(color = '#FFFFFF', width = 2)  # Set slice borders
                ),
                domain = list(x = c(0, 0.6), y = c(0, 1)),
                name = "2019 Payroll") %>% 
  layout(title = "2019 Payroll Allocations", showlegend = TRUE)

# Create pie chart for the second dataset
pie2 <- plot_ly(salary_2023_final, labels = ~Pos, values = ~salary_sum_2023, type = 'pie',
                textinfo = 'percent',
                text = ~paste("2023 Total Payroll:", format(salary_total_2023, big.mark = ",", scientific = FALSE), "<br>Position:", salary_2023_final$Pos, "<br>Salary:",format(salary_2023_final$salary_sum_2023, big.mark = ",", scientific = FALSE)),
                hoverinfo = 'text',
                textposition = 'inside',     # Position the text inside the slices
                marker = list(
                  colors = c('#0072B2','#F0E442', '#FF0000', '#CC79A7', '#009E73'), # Assign new colors
                  line = list(color = '#FFFFFF', width = 2)  # Set slice borders
                ),
                domain = list(x = c(0.6, 1), y = c(0, 0.5)),
                name = "2023 Payroll") %>% 
  layout(title = "2023 Payroll Allocations", showlegend = TRUE)

# Combine the pie charts side by side
subplot(pie1, pie2, nrows = 1, shareX = TRUE, shareY = TRUE, titleX = TRUE) %>%
  layout(title = "Payroll Pie Charts, 2019(Left) Versus 2023(Right)")