import pandas as pd
import plotly.express as px

# Load and preprocess data
injury2023 = pd.read_csv('../data/2023 Injury Data.csv')
injury2023 = injury2023[injury2023['Name'] != 'Víctor Arano']
position_full_names = {
    'SP': 'Starting Pitcher',
    '3B': 'Third Baseman',
    'RP': 'Relief Pitcher',
    'C': 'Catcher',
    'OF': 'Outfielder',
    'INF/OF': 'Infielder/Outfielder'
}
injury2023['Pos'] = injury2023['Pos'].map(position_full_names)
injury2023['Injury / Surgery Date'] = pd.to_datetime(injury2023['Injury / Surgery Date'])
injury2023['Eligible to Return'] = pd.to_datetime(injury2023['Eligible to Return'])
injury2023.dropna(subset=['Injury / Surgery Date', 'Eligible to Return'], inplace=True)
injury2023.sort_values('Injury / Surgery Date', inplace=True)

# Define season start and end dates
season_start = pd.Timestamp('2023-03-30')
season_end = pd.Timestamp('2023-11-01')

# Create the timeline plot with annotations as part of the layout
fig = px.timeline(
    injury2023,
    x_start="Injury / Surgery Date",
    x_end="Eligible to Return",
    y="Pos",
    color="Name",
    hover_name="Name",
    title='2023 Washington Nationals Injury Timeline'
)

fig.update_layout(
    width=730,  # Set the width of the figure (in pixels)
    xaxis=dict(
        range=[season_start, season_end],
        title='Date'
    ),
    yaxis=dict(
        autorange="reversed",  # Ensure positions go top-down
        title='Player Position'
    ),
    shapes=[
        # Line Vertical for season start
        {'type': 'line', 'xref': 'x', 'yref': 'paper',
         'x0': season_start, 'y0': 0, 'x1': season_start, 'y1': 1,
         'line': {'color': 'green', 'width': 2, 'dash': 'dash'}},
        # Line Vertical for season end
        {'type': 'line', 'xref': 'x', 'yref': 'paper',
         'x0': season_end, 'y0': 0, 'x1': season_end, 'y1': 1,
         'line': {'color': 'red', 'width': 2, 'dash': 'dash'}}
    ],
    annotations=[
        # Annotation for the season start
        {'x': season_start, 'y': 0.1, 'xref': 'x', 'yref': 'paper',
         'text': "Season Start", 'showarrow': False,
         'bgcolor': 'white', 'bordercolor': 'green', 'borderwidth': 2},
        # Annotation for the season end
        {'x': season_end, 'y': 0.1, 'xref': 'x', 'yref': 'paper',
         'text': "Season End", 'showarrow': False,
         'bgcolor': 'white', 'bordercolor': 'red', 'borderwidth': 2}
    ]
)
