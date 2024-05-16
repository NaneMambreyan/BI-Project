def choosing_input_dir(task_type):
    if task_type == "create_table":
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation'
    elif task_type == "update":
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\Pipeline_dimensional_data\\queries'
    return input_dir

sql_server_config = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation\\sql_server_config.cfg'
print('---------------DIMENSIONAL config.py done----------------------')