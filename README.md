
# Bring the Washington Nationals Back to MLB Championship Contention

## Team Members
Xuening Yang, Zhuoyan Guo, Marcus Li, Congfei Yin

## Summary:
The Washington Nationals, a professional baseball team part of Major League Baseball (MLB), are based in Washington, D.C., and play their home games at Nationals Park. In 2019, they achieved a remarkable playoff run, ultimately winning their first MLB championship in the franchise's history. However, subsequent years impacted by COVID and various rebuilding phases have seen the team's performance decline, positioning them among the lower ranks in their conference within five years.

Our team has analyzed a range of operational, offensive, and defensive statistics for the Washington Nationals, comparing data from 2019 to 2023. These findings are detailed in the 'Project Summary' tab, where the audience can access a comprehensive proposal for this project. The goal is to employ data visualization tools to effectively communicate to the audience, focusing on team management improvements that could help propel the Washington Nationals back into championship contention.

## Repository structure

```.
├── README.md
├── code/
├── data/
├── img/
├── website/
└── instructions.md
```
## Website

https://sely27.georgetown.domains/Data_Visualization_Project/


## Data description

1. Salary_2019.csv: This file contains the salary by player for the total payroll of the Washington Nationals in 2019. It is used to create Figure 4's pie chart and Figure 5's bar chart. The data was obtained from https://legacy.baseballprospectus.com/compensation/?team=WAS.

2. Salary_2023.csv: This file contains the salary by player for the total payroll of the Washington Nationals in 2023. It is used to create Figure 4's pie chart and Figure 5's bar chart. The data was obtained from https://www.spotrac.com/mlb/washington-nationals/payroll/2023/.

3. 2019_record.csv: This file contains the 2019 Washington Nationals game records. It is used to create the Figure 1 margin graph. The data was https://www.baseball-reference.com/teams/WSN/2019-schedule-scores.shtml.

4. 2023_record.csv: This file contains the 2023 Washington Nationals game records. It is used to create the Figure 2 margin graph.  The data was obtained from https://www.baseball-reference.com/teams/WSN/2019-schedule-scores.shtml.

5. 2019_stats.csv: This file contains the 2019 season records for all 30 MLB teams. It is used to create the Figure 3 scattered  bubble chart.  The data was obtained from https://www.baseball-reference.com/leagues/majors/2019-standings.shtml.

6. `22023_stats.csv`: This file contains the 2023 season records for all 30 MLB teams. It is used to create the Figure 3 scattered bubble chart.  The data was obtained from https://www.baseball-reference.com/leagues/majors/2023-standings.shtml.

7. `Nationals_Stadium_Stats.csv`: This file contains some operational level data for the Washington Nationals from 2008 to 2023. It is used for the Figure 6 line chart. The data was obtained from https://www.baseball-reference.com/teams/WSN/attend.shtml.

8. `statistic_id196692_washington-nationals-revenue-2001-2022.xlsx`: This file contains the Nationals' yearly revenue from 2001 to 2022. It is used for the Figure 6 line chart. The data was obtained from https://www.statista.com/statistics/196692/revenue-of-the-washington-nationals-since-2006/.

9. `statistic_id203506_washington-nationals-average-ticket-price-2006-2023.xlsx`: This file contains the Nationals' average ticket price from 2006 to 2023. It is used for the Figure 6 line chart. The data was obtained from https://www.statista.com/statistics/203506/washington-nationals-average-ticket-price/.

10. `2019Washington_Batting_Individual.xlsx` and `2023Washington_Batting_Individual.xlsx`: These two files contain detailed batting information for each Washington Nationals player in 2019 and 2023, respectively. The data is used to create the radar chart in Figure 9. The data were obtained from https://www.baseball-reference.com/teams/WSN/2023.shtml#all_team_batting and https://www.baseball-reference.com/teams/WSN/2019.shtml#all_team_batting.

11. `2019Washington_Pitching_Individual.xlsx` and `2023Washington_Pitching_Individual.xlsx`: These two files contain detailed batting information for each Washington Nationals player in 2019 and 2023, respectively. The data is used to create the radar chart in Figure 7.  The data were obtained from https://www.baseball-reference.com/teams/WSN/2023.shtml#all_team_pitching and https://www.baseball-reference.com/teams/WSN/2019.shtml#all_team_pitching

12. `player_batting_2019.csv` and `player_batting_2023.csv`: These two files contain detailed batting statistics for each MLB players in 2019 and 2023, respectively. The data is used to create the radar chart in figure 10. The data were obtained from https://www.baseball-reference.com/leagues/majors/2019-standard-batting.shtml and https://www.baseball-reference.com/leagues/majors/2023-standard-pitching.shtml .

13. `player_pitching_2019.csv` and `player_pitching_2023.csv`: These two files contain detailed piching statistics for each MLB players in 2019 and 2023, respectively. The data is used to create the radar chart in figure 8. The data were obtained from https://www.baseball-reference.com/leagues/majors/2019-standard-pitching.shtml and https://www.baseball-reference.com/leagues/majors/2023-standard-pitching.shtml .

14. `2023 Injury Data.csv`: This file contains 2023 Washington Nationals players injury data. It is used to create Figure 11. 2023 Injury Timeline. The data is obtained from https://www.fangraphs.com/roster-resource/injury-report/nationals?&season=2023.


## Code

1. `Team_Records_2023_Chart.R`: This file is used to create Figure 2's margin graph, which shows the Washington Nationals' game margins in 2023.

2. `Team_Records_2019_Chart.R`: This file is used to create Figure 1's margin graph, which shows the Washington Nationals' game margins in 2019.

3. `Salary_Pie_Chart.R`: This file is used to create Figure 4's payroll pie chart, illustrating the allocation of salary across different positions in 2019 and 2023.

4. `Salary_Bar_Chart.R`: This file is used to create Figure 5's payroll change bar chart, explaining the differences in payroll between 2019 and 2023 as a supplement to the pie chart.

5. `Stadium_Stats.R`: This file is used to create Figure 6's line chart to examine the yearly changes in various Nationals operational statistics.

6. `Opp_Team_Bubble_Chart.R`: This file is used to create Figure 3's scatter bubble chart, showing the opponent teams' strength in 2019 and 2023.

7. `Pitching_Radar_Chart.R`: This file is used to create Figure 7's pitching radar chart, showcasing the Washington Nationals' average statistics from six aspects in 2019 and 2023.

8. `Batting_Radar_Chart.R`: This file is used to create Figure 9's pitching radar chart, showcasing the Washington Nationals' average statistics from six aspects in 2019 and 2023.

9. `2023_injury.py`: This file is used to create Figure 11's 2023 Injury Timeline. It tracks the onset and anticipated recovery duration of player injuries in 2023, as well as the availability of key players.

10. `player_batting.R`: This file is used to create Figure 10's radar chart, showcasing the Washington Nationals top five batters performance in 5 aspects in 2019 and 2023.

11. `player_pitching.R`: This file is used to create Figure 8's radar chart, showcasing the Washington Nationals top five pitchers performance in 5 aspects in 2019 and 2023.
