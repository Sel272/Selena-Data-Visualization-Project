# Load the data
library(plotly)
library(tidyverse)

# Load the data
record_2023 <- read_csv("../data/2023_record.csv") 
# https://www.baseball-reference.com/teams/WSN/2023-schedule-scores.shtml

# Load the new data
status_2023 <- read.csv("../data/2023_stats.csv")
# https://www.baseball-reference.com/leagues/majors/2023-standings.shtml

# Create a list mapping team full name to its abbreviation
mlb_teams <- data.frame(
  Full_Name = c(
    "Arizona Diamondbacks", 
    "Atlanta Braves", 
    "Baltimore Orioles",
    "Boston Red Sox",
    "Chicago Cubs",
    "Chicago White Sox",
    "Cincinnati Reds",
    "Cleveland Guardians",
    "Colorado Rockies",
    "Detroit Tigers",
    "Houston Astros",
    "Kansas City Royals",
    "Los Angeles Angels",
    "Los Angeles Dodgers",
    "Miami Marlins",
    "Milwaukee Brewers",
    "Minnesota Twins",
    "New York Mets",
    "New York Yankees",
    "Oakland Athletics",
    "Philadelphia Phillies",
    "Pittsburgh Pirates",
    "San Diego Padres",
    "San Francisco Giants",
    "Seattle Mariners",
    "St. Louis Cardinals",
    "Tampa Bay Rays",
    "Texas Rangers",
    "Toronto Blue Jays",
    "Washington Nationals"
  ),
  Abbreviation = c(
    "ARI", 
    "ATL", 
    "BAL",
    "BOS",
    "CHC",
    "CHW",
    "CIN",
    "CLE",
    "COL",
    "DET",
    "HOU",
    "KCR",
    "LAA",
    "LAD",
    "MIA",
    "MIL",
    "MIN",
    "NYM",
    "NYY",
    "OAK",
    "PHI",
    "PIT",
    "SDP",
    "SFG",
    "SEA",
    "STL",
    "TB",
    "TEX",
    "TOR",
    "WSH"
  ),
  Logo = c(
    "https://content.sportslogos.net/logos/54/50/full/arizona_diamondbacks_logo_primary_20123733.png",
    "https://content.sportslogos.net/logos/54/51/full/atlanta_braves_logo_primary_20221869.png",
    "https://content.sportslogos.net/logos/53/52/full/baltimore_orioles_logo_primary_20195398.png",
    "https://content.sportslogos.net/logos/53/53/full/boston_red_sox_logo_primary_20097510.png",
    "https://content.sportslogos.net/logos/54/54/full/chicago_cubs_logo_primary_19792956.png",
    "https://content.sportslogos.net/logos/53/55/full/chicago_white_sox_logo_primary_19911413.png",
    "https://content.sportslogos.net/logos/54/56/full/cincinnati_reds_logo_primary_20133208.png",
    "https://content.sportslogos.net/logos/53/6804/full/cleveland_guardians_logo_primary_2022_sportslogosnet-5538.png",
    "https://content.sportslogos.net/logos/54/58/full/colorado_rockies_logo_primary_20171892.png",
    "https://content.sportslogos.net/logos/53/59/full/detroit_tigers_logo_primary_20162109.png",
    "https://content.sportslogos.net/logos/53/4929/full/houston_astros_logo_primary_20137038.png",
    "https://content.sportslogos.net/logos/53/62/full/kansas_city_royals_logo_primary_20198736.png",
    "https://content.sportslogos.net/logos/53/6521/full/4389_los_angeles_angels-primary-2016.png",
    "https://content.sportslogos.net/logos/54/63/full/los_angeles_dodgers_logo_primary_20127886.png",
    "https://content.sportslogos.net/logos/54/3637/full/miami_marlins_logo_primary_20194007.png",
    "https://content.sportslogos.net/logos/54/64/full/6474_milwaukee_brewers-primary-2020.png",
    "https://content.sportslogos.net/logos/53/65/full/minnesota_twins_logo_primary_20102311.png",
    "https://content.sportslogos.net/logos/54/67/full/m01gfgeorgvbfw15fy04alujm.png",
    "https://content.sportslogos.net/logos/53/68/full/new_york_yankees_logo_primary_19685115.png",
    "https://content.sportslogos.net/logos/53/69/full/6xk2lpc36146pbg2kydf13e50.png",
    "https://content.sportslogos.net/logos/54/70/full/philadelphia_phillies_logo_primary_20193931.png",
    "https://content.sportslogos.net/logos/54/71/full/1250_pittsburgh_pirates-primary-2014.png",
    "https://content.sportslogos.net/logos/54/73/full/7517_san_diego_padres-primary-2020.png",
    "https://content.sportslogos.net/logos/54/74/full/san_francisco_giants_logo_primary_20002208.png",
    "https://content.sportslogos.net/logos/53/75/full/seattle_mariners_logo_primary_19933809.png",
    "https://content.sportslogos.net/logos/54/72/full/3zhma0aeq17tktge1huh7yok5.png",
    "https://content.sportslogos.net/logos/53/2535/full/tampa_bay_rays_logo_primary_20196768.png",
    "https://content.sportslogos.net/logos/53/77/full/ajfeh4oqeealq37er15r3673h.png",
    "https://content.sportslogos.net/logos/53/78/full/toronto_blue_jays_logo_primary_20208446.png",
    "https://content.sportslogos.net/logos/54/578/full/washington_nationals_logo_primary_20117280.png"
  )
)

# Select the W, L and team name
status_2023_v1 <- status_2023 %>% select(Tm,W,L)

# Get the W Loss Margin columns for 2023
record_2023_v2 <- record_2023 %>% select('W/L','R','RA','Opp') %>% mutate(Margin=R-RA) %>% group_by(Opp) %>% summarize(Game_Count_2023 = n(),Margin_avg=mean(Margin))

# Add a rank column to create color bins for better visuals
record_2023_v2 <- record_2023_v2 %>% mutate(Rank = rank(Game_Count_2023, ties.method = "min")) %>% mutate

# join the table to get the game played, W, L for each team
record_2023_v3 <- record_2023_v2 %>% left_join(mlb_teams, by = c("Opp" = "Abbreviation")) %>% left_join(status_2023_v1, by=c("Full_Name"="Tm"))

# Create custom hover text
# record_2023_v3$hover_text <- paste("Team: ", record_2023_v3$Full_Name, "<br>Game Count: ", record_2023_v3$Game_Count_2023, '<br><img src="', record_2023_v3$Logo, '" width="50" height="50" />', sep = "")
record_2023_v3$hover_text <- paste("Team: ", record_2023_v3$Full_Name, "<br>Game Count: ", record_2023_v3$Game_Count_2023,sep = "")


# Load the data
record_2019 <- read_csv("../data/2019_record.csv") 
# https://www.baseball-reference.com/teams/WSN/2019-schedule-scores.shtml

# Load the new data
status_2019 <- read.csv("../data/2019_stats.csv")
# https://www.baseball-reference.com/leagues/majors/2019-standings.shtml

# Select the W, L and team name
status_2019_v1 <- status_2019 %>% select(Tm,W,L)

# Get the W Loss Margin columns for 2019
record_2019_v2 <- record_2019 %>% select('W/L','R','RA','Opp') %>% mutate(Margin=R-RA) %>% group_by(Opp) %>% summarize(Game_Count_2019 = n(),Margin_avg=mean(Margin))

# Add a rank column to create color bins for better visuals
record_2019_v2 <- record_2019_v2 %>% mutate(Rank = rank(Game_Count_2019, ties.method = "min")) %>% mutate

# join the table to get the game played, W, L for each team
record_2019_v3 <- record_2019_v2 %>% left_join(mlb_teams, by = c("Opp" = "Abbreviation")) %>% left_join(status_2019_v1, by=c("Full_Name"="Tm"))

# Create custom hover text
# record_2019_v3$hover_text <- paste("Team: ", record_2019_v3$Full_Name, "<br>Game Count: ", record_2019_v3$Game_Count_2019, '<br><img src="', record_2019_v3$Logo, '" width="50" height="50" />', sep = "")
record_2019_v3$hover_text <- paste("Team: ", record_2019_v3$Full_Name, "<br>Game Count: ", record_2019_v3$Game_Count_2019,sep = "")

# Create the 2023 plot
fig <- plot_ly() %>%
  add_markers(data = record_2023_v3, x = ~W, y = ~Margin_avg,
              marker = list(size = ~Game_Count_2023*100, sizemode = 'area',
                            color = ~Rank, colorscale = 'Viridis', alpha = 0.4),
              mode = 'markers',
              text = ~Opp,  # Display team names inside the bubbles
              textfont = list(size = 12),
              textposition = 'middle center',  # Position the text in the center of the bubbles
              hoverinfo = 'text',
              hovertext = ~paste("Team:", Full_Name, "<br>Game Count: ", Game_Count_2023),
              name = '2023',
              visible = T) # Ensure the 2023 data is visible by default

# Add the 2019 data to the same plot
fig <- fig %>%
  add_markers(data = record_2019_v3, x = ~W, y = ~Margin_avg,
              marker = list(size = ~Game_Count_2019*100, sizemode = 'area',
                            color = ~Rank, colorscale = 'Viridis', alpha = 0.4),
              mode = 'markers+text',
              text = ~Opp,  # Display team names inside the bubbles
              textposition = 'middle center',  # Position the text in the center of the bubbles
              hoverinfo = 'text',
              textfont = list(size = 12),
              hovertext = ~paste("Team:", Full_Name, "<br>Game Count: ", Game_Count_2019),
              name = '2019',
              visible = F) # Start with this trace hidden

# Customize the layout with a toggle button
fig <- fig %>%
  layout(
    title = 'Wins and Margins Plot By Opponent Teams',
    xaxis = list(title = 'Wins', range = c(45, 110)),
    yaxis = list(title = 'Avg Margin'),
    updatemenus = list(
      list(
        type = 'buttons',
        direction = 'left',
        x = -0.1,
        xanchor = 'left',
        y = 1.1,
        yanchor = 'top',
        buttons = list(
          list(method = "update",
               args = list(list(visible = c(TRUE, FALSE)),
                           list(title = "Wins and Margins Plot By Opponent Teams in 2023")),
               label = "2023"),
          list(method = "update",
               args = list(list(visible = c(FALSE, TRUE)),
                           list(title = "Wins and Margins Plot By Opponent Teams in 2019")),
               label = "2019")
        )
      )
    )
  )

# Show the plot
fig
