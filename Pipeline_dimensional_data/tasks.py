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
    for script in os.listdir(input_dir):
        if query_name in script:
            with open(os.path.join(input_dir, script), 'r') as script_file:
                sql_script = script_file.read()
            break
    return sql_script 



def create_dimension_tables(cursor):
    create_table_script = load_query('dimensional_db_table_creation', 'create_table')
    statements = create_table_script.split("GO")
    for statement in statements:
        if statement.strip():  # Check if the statement is not empty
            cursor.execute(statement)
    cursor.commit()
    print("The tables have been created in the ORDERS_DIMENSIONAL_DB database")

'''
def create_table(cursor, table_name, db, schema):
    create_table_script = load_query('create_table_{}'.format(table_name, 'create_table')).format(db=db, schema=schema)
    cursor.execute(create_table_script)
    cursor.commit()
    print("The {schema}.{table_name} table from the database {db} has been created".format(db=db, schema=schema,
                                                                                           table_name=table_name))
'''

'''
def create_table(cursor, sql_file_path):
    with open(sql_file_path, 'r') as sql_file:
        create_table_script = sql_file.read()

    cursor.execute(create_table_script)
    cursor.commit()
    print("The tables have been created.")




def insert_into_table(cursor, table_name):
    # Read the SQL script
    with open(dimensional_db_table_creation, 'r') as sql_file:
        insert_into_table_script = sql_file.read()

    # Execute the SQL script
    cursor.execute(insert_into_table_script)
    cursor.commit()

    print(f"Data inserted into the {table_name} table")
'''


def update_dim_table(cursor, table_dst, db_dst, schema_dst, table_src, db_src, schema_src):

    update_table_script = load_query('update_dim_{}'.format(table_dst)).format(
        db_dim=db_dst, schema_dim=schema_dst, table_dim=table_dst,
        db_rel=db_src, schema_rel=schema_src, table_rel=table_src)

    # Execute the query
    cursor.execute(update_table_script)
    cursor.commit()

    print(f"The dimension table {table_dst} has been updated.")