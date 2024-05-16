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

class RelationalDataFlow:
    def __init__(self):
        # Generate a unique UUID and assign it to execution_id attribute
        self.execution_id = utils.uuid_generator()
        # Establish database connection and create a cursor
        self.conn_ER = tasks.connect_db_create_cursor("Database1")

    def exec(self):
        #Creating tables
        tasks.create_table(self.conn_ER)

        #Adding constraints
        tasks.add_table_constraints(self.conn_ER)

        #Ingesting data into the tables
        tasks.insert_into_table(self.conn_ER, 'Categories', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Customers', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Employees', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'OrderDetails', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Orders', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Products', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Region', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Shippers', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Suppliers', excel_file_path)
        tasks.insert_into_table(self.conn_ER, 'Territories', excel_file_path)

        self.conn_ER.close()

        # Log execution completion
        logger.info(f"Execution completed for execution_id: {self.execution_id}")

if __name__ == '__main__':
    # Create an instance of RelationalDataFlow
    flow = RelationalDataFlow()
    # Execute the tasks in the right order
    flow.exec()
