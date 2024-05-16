import config
import os
import pandas as pd
import pyodbc
import sys

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(parent_dir)

import utils

def connect_db_create_cursor(database_conf_name):
    # Call to read the configuration file
    db_conf = utils.get_sql_config(config.sql_server_config, database_conf_name)
    # Create a connection string for SQL Server
    
    #db_conn_str = 'Driver={};Server={};Database={};UID={};PWD={};'.format(*db_conf)

    #Windows users can try this version and comment the upper line
    db_conn_str = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*db_conf)

    # Connect to the server and to the desired database
    db_conn = pyodbc.connect(db_conn_str)
    # Create a Cursor class instance for executing T-SQL statements
    db_cursor = db_conn.cursor()
    return db_cursor


def load_query(query_name, task_type):
    input_dir = config.choosing_input_dir(task_type)   
    print(input_dir) 
    for script in os.listdir(input_dir):
        if query_name in script:
            with open(input_dir + '/' + script, 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script


def create_table(cursor):
    create_table_script = load_query('relational_db_table_creation', 'create_table')
    cursor.execute(create_table_script)
    cursor.commit()
    print("The tables have been created in the ORDERS_RELATIONAL_DB database")
 

def insert_into_table(cursor, table_name, source_data):
    # Read the excel table
    df = pd.read_excel(source_data, sheet_name=table_name, header=0)
    df = df.fillna("null")
    insert_into_table_script = load_query('insert_into_{}'.format(table_name), "insert_data")

    # Populate a table in sql server
    for index, row in df.iterrows():
        # Extract column names from the DataFrame and convert them to a list
        columns = list(df.columns)

        # Prepare the parameter values based on the column names
        params = [row[column] for column in columns]

        cursor.execute(insert_into_table_script, *params)
        cursor.commit()

    print(f"{len(df)} rows have been inserted into the {table_name} table")


def add_table_constraints(cursor):
    add_constraint_script = load_query('relational_db_add_PK_FK_constraints', 'add_constraint')
    cursor.execute(add_constraint_script)
    cursor.commit()
    print("Add constraints on the tables of ORDERS_RELATIONAL_DB database")
