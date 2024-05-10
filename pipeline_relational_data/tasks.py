import pyodbc
import pandas as pd

def create_db_connection(server, database, username, password):
    """
    Establishes a database connection using given credentials.

    :param server: Server address
    :param database: Database name
    :param username: User name
    :param password: Password
    :return: Connection object or None
    """
    try:
        connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'
        connection = pyodbc.connect(connection_string)
        print("Database connection successful.")
        return connection
    except Exception as e:
        print(f"Failed to connect to database: {e}")
        return None


def check_table_existence(connection, table_name):
    """
    Checks whether a table exists in the database.

    :param connection: Database connection object
    :param table_name: Name of the table to check existence for
    :return: True if the table exists, False otherwise
    """
    try:
        cursor = connection.cursor()
        # SQL query to check table existence
        sql = f"SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{table_name}'"
        cursor.execute(sql)
        # Fetch the first row (if any) from the result set
        row = cursor.fetchone()
        # If row is not None, table exists
        if row:
            return True
        else:
            return False
    except Exception as e:
        print(f"Error checking table existence: {e}")
        return False








def create_table(connection, create_table_sql):
    """
    Creates a table in the database based on the provided SQL command.

    :param connection: Database connection object
    :param create_table_sql: SQL string to create the table
    """
    try:
        cursor = connection.cursor()
        cursor.execute(create_table_sql)
        connection.commit()
        print("Table created successfully.")
    except Exception as e:
        connection.rollback()
        print(f"Failed to create table: {e}")



        

def ingest_data(connection, data, table_name):
    """
    Ingests data into a specified table from a DataFrame.

    :param connection: Database connection object
    :param data: Pandas DataFrame containing data to ingest
    :param table_name: Name of the table to ingest data into
    """
    try:
        cursor = connection.cursor()
        # Prepare insert statement dynamically based on DataFrame columns
        placeholders = ', '.join(['?'] * len(data.columns))
        columns = ', '.join(data.columns)
        sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
        # Execute insert for each row in DataFrame
        for row in data.itertuples(index=False, name=None):
            cursor.execute(sql, row)
        connection.commit()
        print(f"Data ingested successfully into {table_name}.")
    except Exception as e:
        connection.rollback()
        print(f"Failed to ingest data: {e}")




'''
def drop_table(connection, table_name):
    """
    Drops a table from the database.

    :param connection: Database connection object
    :param table_name: Name of the table to drop
    """
    try:
        cursor = connection.cursor()
        # SQL query to drop the table
        sql = f"DROP TABLE {table_name}"
        cursor.execute(sql)
        connection.commit()
        print(f"Table '{table_name}' dropped successfully.")
    except Exception as e:
        connection.rollback()
        print(f"Failed to drop table: {e}")
'''



