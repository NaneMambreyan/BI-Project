# pipeline_relational_data/flow.py

import uuid
import tasks
from . import utils

class RelationalDataFlow:
    def __init__(self):
        # Generate a unique execution_id using UUID
        self.execution_id = str(uuid.uuid4())
    
    def exec(self):
        # Create database connection
        connection = utils.create_db_connection(server, database, username, password)
        
        if connection:
            try:
                # Execute SQL script to create tables
                utils.read_and_execute_sql_script(connection, table_creation_filepath)
                
                # Execute SQL script to insert data
                utils.read_and_execute_sql_script(connection, data_ingestion_filepath)
                
            finally:
                # Close the database connection
                connection.close()
        else:
            print("Failed to establish database connection.")

if __name__ == "__main__":
    # Define database connection parameters
    server = "your_server_name"
    database = "ORDERS_RELATIONAL_DB"
    username = "your_username"
    password = "your_password"
    table_creation_filepath = "path_to_relational_db_table_creation.sql"
    data_ingestion_filepath = "path_to_insert_into_table.sql"

    # Create an instance of RelationalDataFlow and execute tasks
    flow = RelationalDataFlow()
    flow.exec()
