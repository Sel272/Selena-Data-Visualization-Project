
# Washington Nationals 2019 vs 2023 Analysis
  
# Data prep 
library(openxlsx)
library(plotly)
library(tidyverse)
library(fmsb)
library(ggplot2)
library(readxl)


# Read the datasets
pitching2019 <- read_excel("../data/2019Washington_Pitching_Individual.xlsx")
batting2019 <- read_excel("../data/2019Washington_Batting_Individual.xlsx")

pitching2023 <- read_excel("../data/2023Washington_Pitching_Individual.xlsx")
batting2023 <- read_excel("../data/2023Washington_Batting_Individual.xlsx")

# Print the first few rows of the data to confirm it's read correctly
# head(pitching2019)
# head(batting2019)
# head(pitching2023)
# head(batting2023)


# Convert columns to numeric, ignoring non-numeric values (coerce problems to NA)
pitching2019$ERA <- as.numeric(pitching2019$ERA)
pitching2019$WHIP <- as.numeric(pitching2019$WHIP)
pitching2019$SO9 <- as.numeric(pitching2019$SO9)

pitching2023$ERA <- as.numeric(pitching2023$ERA)
pitching2023$WHIP <- as.numeric(pitching2023$WHIP)
pitching2023$SO9 <- as.numeric(pitching2023$SO9)

# Handle NA values by using mean with na.rm = TRUE
pitching_data <- data.frame(
  metric = c("ERA", "WHIP", "SO9"),
  `2019` = c(mean(pitching2019$ERA, na.rm = TRUE), mean(pitching2019$WHIP, na.rm = TRUE), mean(pitching2019$SO9, na.rm = TRUE)),
  `2023` = c(mean(pitching2023$ERA, na.rm = TRUE), mean(pitching2023$WHIP, na.rm = TRUE), mean(pitching2023$SO9, na.rm = TRUE))
)



# Combined '2019' and '2023' for pitching & batting
# Add a 'Year' column to each dataset

# Filter on only SP and RP
pitching2019 <- pitching2019 %>% mutate(Year = 2019) %>% filter(Pos=="SP"|Pos=="RP")

# Filter on top 15 rank
batting2019 <- batting2019 %>% mutate(Year = 2019) %>% filter(Rk <= 15)

# Filter on only SP and RP
pitching2023 <- pitching2023 %>% mutate(Year = 2023) %>% filter(Pos=="SP"|Pos=="RP")

# Filter on top 15 rank
batting2023 <- batting2023 %>% mutate(Year = 2023) %>% filter(Rk <= 15)

# Combine the pitching datasets
combined_pitching <- rbind(pitching2019, pitching2023)

# Combine the batting datasets
combined_batting <- rbind(batting2019, batting2023)

# Drop Inf for ERA col in 'combined_pitching'
combined_pitching <- combined_pitching[is.finite(combined_pitching$ERA), ]

# Print the first few rows of the combined data to confirm it's combined correctly
# head(combined_pitching)
# head(combined_batting)


# Calculate the mean of the provided pitching stats for the team
# We first calculate the means of the statistics for the team
team_stats_2019 <- pitching2019 %>%
  summarise(ERA = mean(ERA, na.rm = TRUE),
            WHIP = mean(WHIP, na.rm = TRUE),
            SO9 = mean(SO9, na.rm = TRUE),
            FIP = mean(FIP, na.rm = TRUE),
            H = mean(H, na.rm = TRUE),
            R = mean(R, na.rm = TRUE))

categories <- c("ERA", "WHIP", "SO9", "FIP", "H", "R","ERA")

max_values <- c(ERA = max(combined_pitching$ERA), WHIP = max(combined_pitching$WHIP), SO9 = max(combined_pitching$SO9), FIP = max(combined_pitching$FIP), H = max(combined_pitching$H), R = max(combined_pitching$R)) # Upper limit of poor performance
min_values <- c(ERA = min(combined_pitching$ERA), WHIP = min(combined_pitching$WHIP), SO9 = min(combined_pitching$SO9), FIP = min(combined_pitching$FIP), H = min(combined_pitching$H), R = min(combined_pitching$R)) # Lower limit of good performance

# Normalize the stats (Lower is better for ERA, WHIP, FIP, H, and R; higher is better for SO9)
# For ERA, WHIP, FIP, H, R we subtract from the max value to invert the scale
team_stats_normalized_2019 <- mutate(team_stats_2019,
                                     ERA = (max_values['ERA'] - ERA) / (max_values['ERA'] - min_values['ERA']),
                                     WHIP = (max_values['WHIP'] - WHIP) / (max_values['WHIP'] - min_values['WHIP']),
                                     SO9 = (SO9-min_values['SO9']) / (max_values['SO9'] - min_values['SO9']),
                                     FIP = (max_values['FIP'] - FIP) / (max_values['FIP'] - min_values['FIP']),
                                     H = (max_values['H'] - H) / (max_values['H'] - min_values['H']),
                                     R = (max_values['R'] - R) / (max_values['R'] - min_values['R']))

values_2019 <- c(team_stats_normalized_2019$ERA, team_stats_normalized_2019$WHIP, team_stats_normalized_2019$SO9,
                 team_stats_normalized_2019$FIP, team_stats_normalized_2019$H, team_stats_normalized_2019$R)
values_2019 <- c(values_2019, values_2019[1]) # Add the first value to the end to close the radar chart

team_stats_2023 <- pitching2023 %>%
  summarise(ERA = mean(ERA, na.rm = TRUE),
            WHIP = mean(WHIP, na.rm = TRUE),
            SO9 = mean(SO9, na.rm = TRUE),
            FIP = mean(FIP, na.rm = TRUE),
            H = mean(H, na.rm = TRUE),
            R = mean(R, na.rm = TRUE))

categories <- c("ERA", "WHIP", "SO9", "FIP", "H", "R","ERA")

max_values <- c(ERA = max(combined_pitching$ERA), WHIP = max(combined_pitching$WHIP), SO9 = max(combined_pitching$SO9), FIP = max(combined_pitching$FIP), H = max(combined_pitching$H), R = max(combined_pitching$R)) # Upper limit of poor performance
min_values <- c(ERA = min(combined_pitching$ERA), WHIP = min(combined_pitching$WHIP), SO9 = min(combined_pitching$SO9), FIP = min(combined_pitching$FIP), H = min(combined_pitching$H), R = min(combined_pitching$R)) # Lower limit of good performance

# Normalize the stats (Lower is better for ERA, WHIP, FIP, H, and R; higher is better for SO9)
# For ERA, WHIP, FIP, H, R we subtract from the max value to invert the scale
team_stats_normalized_2023 <- mutate(team_stats_2023,
                                     ERA = (max_values['ERA'] - ERA) / (max_values['ERA'] - min_values['ERA']),
                                     WHIP = (max_values['WHIP'] - WHIP) / (max_values['WHIP'] - min_values['WHIP']),
                                     SO9 = (SO9-min_values['SO9']) / (max_values['SO9'] - min_values['SO9']),
                                     FIP = (max_values['FIP'] - FIP) / (max_values['FIP'] - min_values['FIP']),
                                     H = (max_values['H'] - H) / (max_values['H'] - min_values['H']),
                                     R = (max_values['R'] - R) / (max_values['R'] - min_values['R']))

values_2023 <- c(team_stats_normalized_2023$ERA, team_stats_normalized_2023$WHIP, team_stats_normalized_2023$SO9,
                 team_stats_normalized_2023$FIP, team_stats_normalized_2023$H, team_stats_normalized_2023$R)
values_2023 <- c(values_2023, values_2023[1]) # Add the first value to the end to close the radar chart


# Define the batting statistics we are interested in
batting_stats <- c("BA", "OBP", "SLG", "OPS", "OPS+", "HR")

# Calculate the mean for each batting statistic for 2019 and 2023 separately
batting_stats_2019 <- combined_batting %>%
  filter(Year == 2019) %>%
  summarise(across(all_of(batting_stats), mean, na.rm = TRUE))

batting_stats_2023 <- combined_batting %>%
  filter(Year == 2023) %>%
  summarise(across(all_of(batting_stats), mean, na.rm = TRUE))

# Calculate max and min values for normalization from the combined dataset
max_values_batting <- sapply(combined_batting[, batting_stats], max, na.rm = TRUE)
min_values_batting <- sapply(combined_batting[, batting_stats], min, na.rm = TRUE)

# Normalize the stats for each year
normalized_batting_2019 <- as.data.frame(mapply(function(x, min, max) (x - min) / (max - min), batting_stats_2019, min_values_batting, max_values_batting))
normalized_batting_2023 <- as.data.frame(mapply(function(x, min, max) (x - min) / (max - min), batting_stats_2023, min_values_batting, max_values_batting))

# Add the first statistic at the end to close the radar chart loop
values_2019 <- unlist(normalized_batting_2019)
values_2019 <- c(values_2019, values_2019[1]) # Add the first value to the end to close the radar chart

values_2023 <- unlist(normalized_batting_2023)
values_2023 <- c(values_2023, values_2023[1]) # Add the first value to the end to close the radar chart

categories <- c(batting_stats, batting_stats[1]) # Add the first category to the end to close the loop

# Create the original values
values_2019_org <- unlist(batting_stats_2019)
values_2019_org <- c(values_2019_org, values_2019_org[1]) # Add the first value to the end to close the radar chart

values_2023_org <- unlist(batting_stats_2023)
values_2023_org <- c(values_2023_org, values_2023_org[1]) # Add the first value to the end to close the radar chart

# Create a radar chart in plotly with both 2019 and 2023 data
p2 <- plot_ly() %>%
  add_trace(
    type = 'scatterpolar',
    mode = 'markers+lines',
    fill = 'toself',
    r = values_2019,
    theta = categories,
    fillcolor = 'rgba(255, 0, 0, 0.5)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    hoverinfo='text',
    hovertext= ~paste("2019","<br>Stat:",categories,"<br>Original Value:", round(values_2019_org,3)),
    name = '2019'
  ) %>%
  add_trace(
    type = 'scatterpolar',
    mode = 'markers+lines',
    fill = 'toself',
    r = values_2023,
    theta = categories,
    fillcolor = 'rgba(0, 0, 255, 0.5)',
    line = list(color = 'rgba(0, 0, 255, 0.5)'),
    hoverinfo='text',
    hovertext= ~paste("2023","<br>Stat:",categories,"<br>Original Value:", round(values_2023_org,3)),
    name = '2023'
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = TRUE,
        range = c(0, 1)
      )
    ),
    showlegend = TRUE,
    title = "Team Batting Stats Radar Chart (2019 vs 2023)"
  )

# Print the plot
p2
