import logging
import colorlog

def setup_logger():
    # Create a logger object
    logger = logging.getLogger(_name_)
    logger.setLevel(logging.INFO)

    # Define log format with color
    formatter = colorlog.ColoredFormatter(
        '%(log_color)s%(asctime)s - %(levelname)s - %(message)s',
        log_colors={
            'DEBUG':    'cyan',
            'INFO':     'green',
            'WARNING':  'yellow',
            'ERROR':    'red',
            'CRITICAL': 'red,bg_white',
        }
    )

    # Define file handler
    file_handler = logging.FileHandler('logs/logs_relational_data_pipeline.txt')
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)

    # Add file handler to logger
    logger.addHandler(file_handler)

    return logger

# Create logger
logger = setup_logger()