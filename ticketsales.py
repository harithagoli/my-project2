##setting up the connection to My Sql Workbench
def get_db_connection():
   connection = None
   try:
    connection = mysql.connector.connect(user='root',      password='12345678',host='127.0.0.1',port='3306',database='ticket_sales') 
   except Exception as error:
    print("Error while connecting to database for job tracker", error)
   return connection
#2.Load CSV to table
import csv
import mysql.connector  
connection = mysql.connector.connect(user='root',
       password='12345678',
host='127.0.0.1',
port='3306',
database='ticket_sales')  
cursor = connection.cursor()
try:
    with open('third_party_sales_1.csv','r') as csvfile:
        datareader = csv.reader(csvfile,delimiter = ',')
        for row in datareader:  
            insert_sql = "insert into sales (ticket_id,trans_date,event_id,event_name,event_date,event_type,event_city,customer_id,price,num_tickets)   VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            cursor.execute(insert_sql,row)
            print(cursor.rowcount,"was inserted")
            connection.commit()
finally:
      connection.close()          
import mysql.connector  
#dislay statitical information and recommending popular event in the past months
connection = mysql.connector.connect(user='root',
       password='12345678',
host='127.0.0.1',
port='3306',
database='ticket_sales')  
cursor = connection.cursor()
# Get the most popular ticket in the past month
sql_statement = "SELECT   event_name ,sum(num_tickets)  as totaltickets from  ticket_sales.sales where    month(event_date)  < (select month(max(event_date))   from ticket_sales.sales) group by event_name"
cursor = connection.cursor()
cursor.execute(sql_statement)
records = cursor.fetchall()
print(records)
print('Here are the most popular tickets in the past month:')
for i in records:
  print('-{}'.format(i[0]))
truncate_statement = "truncate  ticket_sales.sales"
cursor = connection.cursor()
cursor.execute(truncate_statement)  
cursor.close()
