import logging
import os
import datetime

# Create logs directory if it doesn't exist
log_dir = os.path.join(os.getcwd(), 'logs')
if not os.path.exists(log_dir):
    os.makedirs(log_dir)

# Configure logging from logging.conf
logging.config.fileConfig('logging.conf')

# Get the logger
logger = logging.getLogger('DimensionalDataFlow')

# Configure logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')

# Create a logger
logger = logging.getLogger('DimensionalDataFlow')

# Create a file handler
log_file = os.path.join(log_dir, 'logs_dimensional_data_pipeline.txt')
file_handler = logging.FileHandler(log_file)

# Set the format for the file handler
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)

# Add the file handler to the logger
logger.addHandler(file_handler)
