# you probably have to install mysql-connector-python w/ pip or conda
import mysql.connector
import pandas as pd
import os

db_name = 'College'

# be sure to change this to your password before running
mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    passwd='your pw here',
    auth_plugin='mysql_native_password',
    database=db_name
)

cursor = mydb.cursor()

cursor.execute("SHOW TABLES;")
print(f'Tables in Database "{db_name}":')
print('--------------------------------------------')
for table in cursor:
    print(table)
print('\n')

query_ex = '''SELECT unit_id, inst_name, adm_rate
FROM Universities;'''
cursor.execute(query_ex)
df = pd.DataFrame(cursor,columns=['Unit ID', 'Name', 'Admit Rate'])
print(df.head())

cursor.close()
mydb.close()