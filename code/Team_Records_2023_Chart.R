# Load the data
library(plotly)
library(tidyverse)
record_2023 <- read_csv("../data/2023_record.csv")
# https://www.baseball-reference.com/teams/WSN/2023-schedule-scores.shtml

# Create the margin graphs by selecting the columns and calculating margins as R-RA
# Calculate average margin by month
record_2023_v1 <- record_2023 %>% select('W/L','R','RA','Gm#','Date','Opp') %>% mutate(Margin=R-RA) %>% mutate(`W/L`=ifelse(R>RA,"W","L")) %>% mutate(hover_text = paste("Opponent Team:", Opp, "<br>Margin:", Margin,"<br>Result:",`W/L`))  # Add a hover text column

# record_2023_v1 <- record_2023 %>% select('W/L','R','RA','Gm#','Date') %>% mutate(Margin=R-RA) %>% mutate(`W/L`=ifelse(R>RA,"W","L")) %>% mutate(Date = mdy(paste(Date, "2023")),Month = format(Date, "%b")) %>% group_by(Month) %>% summarize(Avg_Margin =mean(Margin,na.rm=TRUE), `W/L`=ifelse(Avg_Margin>0,'W','L'))


# Create the ggplot object
p_2023 <- ggplot(record_2023_v1, aes(x = `Gm#`, y = Margin, fill = `W/L`,text = hover_text)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("W" = "green", "L" = "red")) +
  xlab('Game Played') + 
  labs(title = "2023 Season Nationals Game Results") +
  theme_minimal()

# Convert to plotly object for interactivity
plotly_2023 <- ggplotly(p_2023, tooltip = "text")  # Ensure tooltips are added

# Print the Plotly object
plotly_2023