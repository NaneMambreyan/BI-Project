# Import the logging module
import logging
import logging.config

# Import the necessary modules
import tasks
import os
import utils


# Get the configuration file path
config_file_path = os.path.join((os.getcwd()), 'logging.conf')

# Configure logging from logging.py
from logging import getLogger
logging.config.fileConfig(config_file_path)

logger = getLogger(__name__)

# Get the current and parent directory
current_directory = os.getcwd()
parent_directory = os.path.dirname(current_directory)

# Specify the path to the Excel file
excel_file_path = os.path.join(current_directory, "raw_data_source.xlsx")

class DimensionalDataFlow:
    def __init__(self):
        # Generate a unique UUID and assign it to execution_id attribute
        self.execution_id = utils.uuid_generator()
        # Establish database connection and create a cursor
        self.conn_ER = tasks.connect_db_create_cursor("Database2")

    def exec(self):
        
        #Creating tables
       # tasks.create_dimension_tables(self.conn_ER)
        tasks.create_dimension_tables(self.conn_ER)


        #Ingesting data into the tables
        tasks.update_dim_table(self.conn_ER, 'Categories', 'ORDERS_DIMENSIONAL_DB', 'dbo', 'Categories', 'ORDERS_RELATIONAL_DB', 'dbo')
        tasks.update_dim_table(self.conn_ER, 'Customers', 'ORDERS_DIMENSIONAL_DB', 'dbo', 'Customers', 'ORDERS_RELATIONAL_DB', 'dbo')

        self.conn_ER.close()

        # Log execution completion
        logger.info(f"Execution completed for execution_id: {self.execution_id}")

if __name__ == '__main__':
    # Create an instance of RelationalDataFlow
    flow = DimensionalDataFlow()
    # Execute the tasks in the right order
    flow.exec()


