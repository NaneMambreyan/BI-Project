def choosing_input_dir(task_type):
<<<<<<< HEAD
    if task_type == "create_table":
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation'
    elif task_type == "update":
        input_dir = 'C:\\Users\\USER\\Desktop\\BI-Project\\Pipeline_dimensional_data\\queries'
    return input_dir

sql_server_config = 'C:\\Users\\USER\\Desktop\\BI-Project\\infrastructure_initiation\\sql_server_config.cfg'
print('---------------DIMENSIONAL config.py done----------------------')
=======
    if task_type in ["create_table"]:
        input_dir = "C:\\Users\\Areg\\Desktop\\BI-Project\\BI-Project\\infrastructure_initiation"
    elif task_type == "insert_data":
        input_dir = "C:\\Users\\Areg\\Desktop\\BI-Project\\BI-Project\\Pipeline_dimentional_data\\queries"
    return input_dir

sql_server_config = "C:\\Users\\Areg\\Desktop\\BI-Project\\BI-Project\\infrastructure_initiation\\sql_server_config.cfg"
print('---------------config.py done----------------------')
>>>>>>> b2fdc68c70a3950b3d2ffbe80a39928843e4f5a4
