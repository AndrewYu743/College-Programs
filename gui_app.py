# you probably have to install mysql-connector-python w/ pip or conda
import mysql.connector
import pandas as pd
import os

mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    passwd='your password here',
    auth_plugin='mysql_native_password',
    database='IMDb'
)

cursor = mydb.cursor()

cursor.execute("SHOW TABLES;")
print('Tables in Database:')
print('--------------------------------------------')
for table in cursor:
    print(table)