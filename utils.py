import pyodbc

def create_db_connection(server, database, username, password):
    """
    Creates and returns a database connection to a SQL Server instance.

    :param server: The server name or IP address
    :param database: The database name
    :param username: The username for database authentication
    :param password: The password for database authentication
    :return: A connection object
    """
    connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'
    try:
        connection = pyodbc.connect(connection_string)
        print("Connection successful")
        return connection
    except Exception as e:
        print(f"An error occurred connecting to the database: {e}")
        return None

def read_and_execute_sql_script(db_connection, script_path):
    """
    Reads an SQL script from a file and executes it using the given database connection.

    :param db_connection: A database connection object
    :param script_path: The path to the .sql file
    """
    with open(script_path, 'r') as file:
        sql_script = file.read()
    execute_sql_script(db_connection, sql_script)

def execute_sql_script(db_connection, sql_script):
    """
    Executes an SQL script using the given database connection.

    :param db_connection: A database connection object
    :param sql_script: A string containing SQL commands
    """
    try:
        cursor = db_connection.cursor()
        cursor.execute(sql_script)
        db_connection.commit()
        print("Script executed successfully")
    except Exception as e:
        db_connection.rollback()
        print(f"An error occurred: {e}")