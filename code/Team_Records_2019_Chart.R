# Load the data
library(plotly)
library(tidyverse)
record_2019 <- read_csv("../data/2019_record.csv") 
# https://www.baseball-reference.com/teams/WSN/2019-schedule-scores.shtml

# Create the margin graphs by selecting the columns and calculating margins as R-RA
record_2019_v1 <- record_2019 %>% select('W/L','R','RA','Gm#','Opp') %>% mutate(Margin=R-RA) %>% mutate(`W/L`=ifelse(R>RA,"W","L"))
record_2019_v1 <- record_2019_v1 %>% mutate(hover_text = paste("Opponent Team:", Opp, "<br>Margin:", Margin,"<br>Result:",`W/L`))  # Add a hover text column

# Create the ggplot object
p_2019 <- ggplot(record_2019_v1, aes(x = `Gm#`, y = Margin, fill = `W/L`,text = hover_text)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("W" = "green", "L" = "red")) +
  xlab('Game Played') + 
  labs(title = "2019 Season Nationals Game Results") +
  theme_minimal()

# Convert to plotly object for interactivity
plotly_2019 <- ggplotly(p_2019, tooltip = "text")  # Ensure tooltips are added

# Print the Plotly object
plotly_2019