library(tidyverse)
library(ggplot2)

pitch_2019 <- read.csv('player_pitching_2019.csv')
pitch_2023 <- read.csv('player_pitching_2023.csv')

df_2019 <- pitch_2019 %>%
  filter(Tm=='WSN')%>%
  select(Name,IP,Tm,ERA,WHIP,H9,SO9,BB9)%>%
  arrange(desc(IP))%>%
  na.omit()%>%
  slice_head(n=20)

df_2023 <- pitch_2023 %>%
  filter(Tm =='WSN')%>%
  select(Name,IP,Tm,ERA,WHIP,H9,SO9,BB9)%>%
  arrange(desc(IP))%>%
  na.omit()%>%
  slice_head(n=20)

df_2019_norm <- df_2019 %>%
  mutate(across(.cols = c(IP, ERA, WHIP, H9, SO9,BB9), 
                .fns = ~ (. - min(.)) / (max(.) - min(.))))

df_2019_norm <- df_2019_norm%>%
  mutate(ERA=1-ERA)%>%
  mutate(WHIP=1-WHIP)%>%
  mutate(H9=1-H9)%>%
  mutate(BB9=1-BB9)


df_2023_norm <- df_2023 %>%
  mutate(across(.cols = c(IP, ERA, WHIP, H9, SO9,BB9), 
                .fns = ~ (. - min(.)) / (max(.) - min(.))))

df_2023_norm <- df_2023_norm%>%
  mutate(ERA=1-ERA)%>%
  mutate(WHIP=1-WHIP)%>%
  mutate(H9=1-H9)%>%
  mutate(BB9=1-BB9)

library(plotly)

theta_labels= c('Earned Run Average', 'Walk+Hit per inning','Hit per 9 inning','StrikeOut per 9 inning','Walk per 9 inning')

fig <- plot_ly(
  type = 'scatterpolar',
  fill = 'toself'
) 
fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2019_norm[1,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(255, 0, 0, 0.3)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    text = paste("2019","<br>Name:",df_2019$Name[1],colnames(df_2023[4:8]), "<br>Value:", c(df_2019[1,4:8])),
    name = '2019'
  ) 
fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2023_norm[1,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(0, 255, 0, 0.3)',
    line = list(color = 'rgba(0, 255, 0, 0.5)'),
    text=paste("2023","<br>Name:",df_2023$Name[1],colnames(df_2023[4:8]),"<br>Value:", c(df_2023[1,4:8])),
    name = '2023'
  ) 

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2019_norm[2,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(255, 0, 0, 0.3)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    text=paste("2019","<br>Name:",df_2019$Name[2],colnames(df_2019[4:8]),"<br>Value:", c(df_2019[2,4:8])),
    name = '2019',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2023_norm[2,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(0, 255, 0, 0.3)',
    line = list(color = 'rgba(0, 255, 0, 0.5)'),
    text=paste("2023","<br>Name:",df_2023$Name[2],colnames(df_2023[4:8]),"<br>Value:", c(df_2023[2,4:8])),
    name = '2023',
    visible=F
  ) 

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2019_norm[3,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(255, 0, 0, 0.3)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    text=paste("2019","<br>Name:",df_2019$Name[3],colnames(df_2019[4:8]),"<br>Value:", c(df_2019[3,4:8])),
    name = '2019',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2023_norm[3,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(0, 255, 0, 0.3)',
    line = list(color = 'rgba(0, 255, 0, 0.5)'),
    text=paste("2023","<br>Name:",df_2023$Name[3],colnames(df_2023[4:8]),"<br>Value:", c(df_2023[3,4:8])),
    name = '2023',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2019_norm[4,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(255, 0, 0, 0.3)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    text=paste("2019","<br>Name:",df_2019$Name[4],colnames(df_2019[4:8]),"<br>Value:", c(df_2019[4,4:8])),
    name = '2019',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2023_norm[4,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(0, 255, 0, 0.3)',
    line = list(color = 'rgba(0, 255, 0, 0.5)'),
    text=paste("2023","<br>Name:",df_2023$Name[4],colnames(df_2023[4:8]),"<br>Value:", c(df_2023[4,4:8])),
    name = '2023',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2019_norm[5,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(255, 0, 0, 0.3)',
    line = list(color = 'rgba(255, 0, 0, 0.5)'),
    text=paste("2019","<br>Name:",df_2019$Name[5],colnames(df_2019[4:8]),"<br>Value:", c(df_2019[5,4:8])),
    name = '2019',
    visible=F
  )

fig <- fig %>%
  add_trace(
    r = unlist(as.numeric(df_2023_norm[5,4:8])),
    theta = theta_labels,
    fillcolor = 'rgba(0, 255, 0, 0.3)',
    line = list(color = 'rgba(0, 255, 0, 0.5)'),
    text=paste("2023","<br>Name:",df_2023$Name[5],colnames(df_2023[4:8]),"<br>Value:", c(df_2023[5,4:8])),
    name = '2023',
    visible=F
  )

fig <- fig %>%
  layout(
    polar = list(
      radialaxis = list(
        range = c(0,1)
      )
    )
  )


final_plot <- fig %>% layout(
  title = 'Washington Nationals Top 5 Pitchers 2019 vs 2023',
  updatemenus = list(
    list(
      type = 'buttons',
      direction = 'left',
      x = 0,
      xanchor = 'left',
      y = -0.2,
      yanchor = 'top',
      buttons = list(
        list(method = 'update', args = list(list(visible = c(T, T, T, F, F, F,F, F,F, F,F)), list(title = 'pitcher 1')), label = '1st pitcher'),
        list(method = 'update', args = list(list(visible = c(T,F, F, T, T, F,F, F,F, F,F)), list(title = 'pitcher 2')), label = '2nd pitcher'),
        list(method = 'update', args = list(list(visible = c(T,F, F, F, F, T,T, F,F, F,F)), list(title = 'pitcher 3')), label = '3rd pitcher'),
        list(method = 'update', args = list(list(visible = c(T,F, F, F, F, F,F, T,T, F,F)), list(title = 'pitcher 4')), label = '4th pitcher'),
        list(method = 'update', args = list(list(visible = c(T,F, F, F, F, F,F, F,F, T,T)), list(title = 'pitcher 5')), label = '5th pitcher')
      )
    )
  )
)

final_plot


