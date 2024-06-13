import streamlit as st
import pandas as pd
import plotly.express as px

# Load data from CSV
data = pd.read_csv("Book1.csv")

# Create a copy for filtering
data_filtered = data.copy()

# Operation selection in the sidebar
operation = st.sidebar.selectbox("Select Operation", ["1", "1-South","1-North","1-West","2","2-South","2-North","All Sectors"])

if operation == "1":
    data_filtered = data_filtered[data_filtered["Sectors"] == "1"]
elif operation == "1-South":
    data_filtered = data_filtered[data_filtered["Sectors"] == "1A"]
elif operation == "1-North":
    data_filtered = data_filtered[data_filtered["Sectors"] == "1B"]
elif operation == "1-West":
    data_filtered = data_filtered[data_filtered["Sectors"] == "1C"]
elif operation == "2":
    data_filtered = data_filtered[data_filtered["Sectors"] == "2"]
elif operation == "2-South":
    data_filtered = data_filtered[data_filtered["Sectors"] == "2A"]
elif operation == "2-North":
    data_filtered = data_filtered[data_filtered["Sectors"] == "2B"]
elif operation == "3":
    data_filtered = data_filtered[data_filtered["Sectors"] == "3"]
elif operation == "4":
    data_filtered = data_filtered[data_filtered["Sectors"] == "4"]
elif operation == "5":
    data_filtered = data_filtered[data_filtered["Sectors"] == "5"]
else:
    pass 


tree_types = sorted(data_filtered["Name"].unique())

# Multi-select widget
if operation != "All Sectors": 
    selected_tree_types = st.sidebar.multiselect(
        "Select Tree Types:", tree_types, default=tree_types
    )
    #(if multi-select is enabled)
    data_filtered = data_filtered[data_filtered["Name"].isin(selected_tree_types)]

# Create scatter plot
fig = px.scatter(
    data_filtered,
    x="x",
    y="y",
    color="Name",
    title="Scatter Plot of Tree Data",
)


st.plotly_chart(fig, use_container_width=True)

tree_count = data_filtered["Name"].value_counts().reset_index()
tree_count.columns = ["Name of tree", "Number of trees"]

# Display the table with tree names and counts
st.table(tree_count)

# Calculate total number of tree types and total number of trees
total_tree_types = len(tree_types)
total_trees = len(data_filtered)

# Display summary information
st.write(f"Number of types of trees: {total_tree_types}")
st.write(f"Number of all trees: {total_trees}")
