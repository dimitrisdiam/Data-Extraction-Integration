# -*- coding: utf-8 -*-
"""Assignment_1_G25.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1YemHmlq4nabfZ4En5d3DiiXbH669fouC
"""

import sqlite3
import pandas as pd
from sqlite3 import Error

def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)
    return conn

def run_query(conn, query):
    cur = conn.cursor()
    cur.execute(query)
    results = cur.fetchall()
    return results

def convert_db_table_to_DF(conn, table):
    # get the names of the attributes in the database table
    header_query = "SELECT name FROM pragma_table_info('" + table + "') ORDER BY cid;"
    cols_init = run_query(conn, header_query)
    cols = [cols_init[i][0] for i in range(len(cols_init))]
    # get the records of the table
    content_query = "Select * from " + table
    data = run_query(conn, content_query)
    df = pd.DataFrame(data, columns = cols)
    return df

def jaccard_similarity(set1, set2):
    intersection_size = len(set1.intersection(set2))
    union_size = len(set1.union(set2))
    return intersection_size / union_size if union_size != 0 else 0.0


# select the file of the database
database = "/content/Assignment_1.db"

# create a database connection
conn = create_connection(database)

# queries from task 2
query = [
    '''SELECT  AC_ID, customer_ID, balance, branch_Name, street, building_number FROM account ac LEFT JOIN branch br ON ac.branch_ID = br.branch_ID; ''',
    '''SELECT loan.branch_ID, branch_Name, AVG (amount) FROM loan JOIN branch ON loan.branch_ID = branch.branch_ID GROUP BY loan.branch_ID;''',
    '''SELECT customer_ID, balance FROM account WHERE balance = (Select max(balance) From account )'''
]
with conn:
    for q in range(len(query)):
        data = run_query(conn, query[q])
        print(f"Query {q + 1}: {data} \n")

# read customer table and convert it to a dataframe
with conn:
    inst_tab = 'customer'
    df_customer = convert_db_table_to_DF(conn, inst_tab)

display(df_customer)

# Create a list of every single row in df_customer.
records = [df_customer.iloc[row] for row in range(len(df_customer))]

for i in range(len(records)):
    r1 = set(records[i])
    # loop over the columns of the second table
    r2 = set()

    for j in range(i+1,len(records)):
        r2 = set(records[j])
        JSim = jaccard_similarity(r1, r2)

        # Display similarities that score more than 0.7.
        if JSim > 0.7 :
          print (f"Jacard similarity between Customer with IDs {records[i][0]} and {records[j][0]} = {round(JSim, 2)}")