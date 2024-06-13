import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px
import plotly.graph_objs as go

# Load data from CSV
data = pd.read_csv("Book1.csv")

# List of sectors and transformation rules
sectors = ["1", "1A", "1B", "1C", "2", "2A", "2B", "3", "4", "5","6","LaneWest","LaneEast"]

# Transformation rules: (shift_x, shift_y)
transformations = {
    "1": (30, 3),
    "1A": (30, 33),
    "1B": (30, 0),
    "1C": (49, 3), # No specific position mentioned for 1C, keeping default
    "2": (15, 3),
    "2A": (15, 32),
    "2B": (15, 0),
    "3": (10, 3), # Adding an example shift for other sectors
    "3A": (9, 0),
    "3B": (10,0),
    "4": (0, 20),
    "5": (0, 12),
    "6":(0,0),
    "LaneWest":(9,0),
    "LaneEast":(7,0)
}

app = dash.Dash(__name__)

# External stylesheets for dark theme
app.css.append_css({"external_url": "https://codepen.io/chriddyp/pen/bWLwgP.css"})

app.layout = html.Div(style={'backgroundColor': '#1E1E1E', 'color': 'white', 'padding': '10px'}, children=[
    html.H1("Tree Data Visualization", style={'textAlign': 'center'}),
    dcc.Dropdown(
        id='sector-dropdown',
        options=[{'label': sector, 'value': sector} for sector in sectors],
        value=sectors,  # Default to selecting all sectors
        multi=True,
        style={'backgroundColor': '#333', 'color': 'white'}
    ),
    dcc.Checklist(
        id='select-all-sectors',
        options=[{'label': 'Select all sectors', 'value': 'all'}],
        value=['all'],
        style={'color': 'white'}
    ),
    dcc.Dropdown(
        id='tree-type-dropdown',
        multi=True,
        style={'backgroundColor': '#333', 'color': 'white'}
    ),
    dcc.Graph(id='scatter-plot', style={'height': '70vh'}),
    html.Div(id='tree-table-container'),
    html.Div(id='summary', style={'paddingTop': '20px'})
])


@app.callback(
    Output('sector-dropdown', 'value'),
    Input('select-all-sectors', 'value')
)
def select_all_sectors(selected):
    if 'all' in selected:
        return sectors
    return dash.no_update


@app.callback(
    Output('tree-type-dropdown', 'options'),
    Output('tree-type-dropdown', 'value'),
    Input('sector-dropdown', 'value')
)
def update_tree_types(selected_sectors):
    filtered_data = data[data['Sectors'].isin(selected_sectors)]
    tree_types = sorted(filtered_data['Name'].unique())
    return [{'label': tree, 'value': tree} for tree in tree_types], tree_types


@app.callback(
    Output('scatter-plot', 'figure'),
    Output('tree-table-container', 'children'),
    Output('summary', 'children'),
    Input('sector-dropdown', 'value'),
    Input('tree-type-dropdown', 'value')
)
def update_scatter_plot(selected_sectors, selected_tree_types):
    filtered_data = data[data['Sectors'].isin(selected_sectors)]
    filtered_data = filtered_data[filtered_data['Name'].isin(selected_tree_types)]

    # Apply transformations to the coordinates
    for sector, (shift_x, shift_y) in transformations.items():
        filtered_data.loc[filtered_data['Sectors'] == sector, 'x'] += shift_x
        filtered_data.loc[filtered_data['Sectors'] == sector, 'y'] += shift_y
    
    fig = px.scatter(
        filtered_data,
        x='x',
        y='y',
        color='Name',
        title='Scatter Plot of Tree Data',
    )
    fig.update_layout(
        xaxis=dict(scaleanchor="y", scaleratio=1),
        yaxis=dict(scaleanchor="x", scaleratio=1),
        paper_bgcolor='#1E1E1E',
        plot_bgcolor='#1E1E1E',
        font=dict(color='white')
    )
    
    tree_count = filtered_data['Name'].value_counts().reset_index()
    tree_count.columns = ["Name of tree", "Number of trees"]
    
    table_header = [
        html.Tr([html.Th("Name of tree"), html.Th("Number of trees")], style={'border': '1px solid white'})
    ]
    table_body = [html.Tr([html.Td(row["Name of tree"]), html.Td(row["Number of trees"])], style={'border': '1px solid white'}) for _, row in tree_count.iterrows()]
    table = table_header + table_body
    
    table_element = html.Table(
        children=table,
        style={'width': '100%', 'borderCollapse': 'collapse', 'border': '1px solid white'}
    )
    
    total_tree_types = len(filtered_data['Name'].unique())
    total_trees = len(filtered_data)
    
    summary = f"Number of types of trees: {total_tree_types} | Number of all trees: {total_trees}"
    
    return fig, table_element, summary


if __name__ == '__main__':
    app.run_server(debug=True)
