def choosing_input_dir(task_type):
    if task_type in ["create_table", "add_constraint"]:
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation'
    elif task_type == "insert_data":
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\pipeline_relational_data\\queries'
    return input_dir

sql_server_config = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation\\sql_server_config.cfg'
print('---------------config.py done----------------------')