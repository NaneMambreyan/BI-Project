import uuid
import pyodbc
import tasks
import sys
import os

# Get the current directory of this script (pipeline_relational_data)
current_directory = os.path.dirname(os.path.abspath(__file__))

# Get the parent directory (project root)
parent_directory = os.path.dirname(current_directory)

# Add the parent of directory to the Python path
sys.path.append(parent_directory)
print(parent_directory)

import utils

class RelationalDataFlow:
    def __init__(self):
        # Generate a unique execution_id using UUID
        self.execution_id = str(uuid.uuid4())
        '''
        # Set up logger
        self.logger = logging.getLogger(_name_)
        self.logger.setLevel(logging.INFO)
        log_file = os.path.join(os.path.dirname(_file_), '..', 'logs', 'logs_relational_data_pipeline.txt')
        file_handler = logging.FileHandler(log_file)
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - [Execution ID: %(execution_id)s] - %(message)s')
        file_handler.setFormatter(formatter)
        self.logger.addHandler(file_handler)
        '''
        
    def exec(self):
        # Get database connection parameters from config file
        server = "localhost"
        database = "ORDERS_RELATIONAL_DB"
        username = "areg"
        password = "2003"
        
        # Create database connection
        connection = tasks.create_db_connection(server, database, username, password)
        
        if connection:
            try:
                # Execute SQL script to create tables
                table_creation_filepath = os.path.join(os.path.dirname(__file__), '..', 'infrastructure_initiation', 'relational_db_table_creation.sql')
                #self.logger.info("Executing SQL script to create tables...")
                tasks.read_and_execute_sql_script(connection, table_creation_filepath)
                
                # Execute SQL script to add primary and foreign key constraints
                constraints_filepath = os.path.join(os.path.dirname(__file__), '..', 'infrastructure_initiation', 'relational_db_add_PK_FK_constraints.sql')
               # self.logger.info("Executing SQL script to add primary and foreign key constraints...")
                tasks.read_and_execute_sql_script(connection, constraints_filepath)
                
                # Execute SQL scripts to insert data into tables
                queries_folder = os.path.join(os.path.dirname(__file__), 'queries')
                for filename in os.listdir(queries_folder):
                    if filename.startswith("insert_into_") and filename.endswith(".sql"):
                        filepath = os.path.join(queries_folder, filename)
                        self.logger.info(f"Executing SQL script to insert data into {filename}...")
                        tasks.read_and_execute_sql_script(connection, filepath)
                        
                #self.logger.info("Data insertion completed.")
                
            finally:
                # Close the database connection
                connection.close()
              #  self.logger.info("Database connection closed.")
       # else:
          #  self.logger.error("Failed to establish database connection.")

if __name__ == "__main__":
    # Create an instance of RelationalDataFlow and execute tasks
    flow = RelationalDataFlow()
    flow.exec()