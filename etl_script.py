#Import all necessary python libraries
import requests as req
import pandas as pd
import os
import psycopg2 as ps
from sqlalchemy import create_engine


#get data from the source which is in a git repository
def get_data(file_name, columns):
    url = 'https://raw.githubusercontent.com/annexare/Countries/master/data/{}.json'.format(file_name)
    data = req.get(url).json()
    df = pd.DataFrame(list(data.items()),columns=columns)
    return df

def get_data_with_header(file_name):
    url = 'https://raw.githubusercontent.com/annexare/Countries/master/data/{}.json'.format(file_name)
    data = req.get(url).json()
    df= pd.DataFrame(data.values())
    df ['country_code'] = data.keys()
    return df

#save the data in a custom file path as csv into the staging environment
def save_staging_file(df):
    file_dir = os.path.abspath(os.getcwd()) +'/staging_output'
    file_staged = file_dir + '/staged_data.csv'
    if not os.path.exists(file_dir):
        os.makedirs(os.path.abspath(os.getcwd()) +'/staging_output')
    if os.path.exists(file_staged):
        print('Staging file found. \n Removing staging file: ' + file_staged)
        os.remove(file_staged)
    print('saving new staging file...')
    df.to_csv(file_staged, index=False)
    print('saved results to file: ' + file_staged)
    
    return file_staged

#Staging environment connection creds
def stage_monitoring_data(file_staged, staging_tbl):
    # connect to db
    host = 'localhost'
    username = 'postgres'
    database = 'postgres'
    password = 'postgres'

    
    conn = ps.connect(host=host,
                database = database,
                user=username,
                password =password,
                port=5438)
    
    cur = conn.cursor()
    engine = create_engine('postgresql://postgres:postgres@localhost:5438/postgres') #create engine for storing connection string
    
    my_df= pd.read_csv(file_staged)
    my_df.to_sql(staging_tbl, con=engine, if_exists='replace',index=None)
    conn.commit()
    
    
    cur.close()
    print("all records successfully pulled and stored in staging tables in the database") #confirmation that load is completed
    return my_df

#production environment connection credentials
def update_all():
    host = 'localhost'
    username = 'postgres'
    database = 'postgres'
    password = 'postgres'

    
    conn = ps.connect(host=host,
                database = database,
                user=username,
                password =password,
                port=5438)
    
    cur = conn.cursor()
    print(">>>>>>>>>>>>>>>>> connect to prod tables and upsert prod table and ensuring idempotence")
    cur.execute(open("update.sql", "r").read()) #Run all the MERGE queries in the update.sql file as stated in the README
    conn.commit()
    cur.close()
    print(">>>>>>>>>>>>>>>>> ETL complete and all records successfully pulled and updated") #confirmation that load is done
    

#specificaly load data without headers into the staging environment
def data_without_headers():
    table = {
        'continents':['continent_stg', ['continent_code','continent_full_name']],
        'countries.2to3':['country2to3_stg', ['country_code_2', 'country_code_3']],
        'countries.3to2':['country3to2_stg', ['country_code_3', 'country_code_2']]
    }
    for key, value in table.items():
        git_data = get_data(key, value[1])
        file_output = save_staging_file(git_data) 
        stage_monitoring_data(file_staged=file_output, staging_tbl=value[0])

#specificaly load data with headers into the staging environment
def data_with_headers():
    table = {
        'countries':'country_stg',
        'languages':'language_stg'
    }
    for key, value in table.items():
        git_data = get_data_with_header(key)
        file_output = save_staging_file(git_data) 
        stage_monitoring_data(file_staged=file_output, staging_tbl=value)

if __name__ == "__main__":
    data_without_headers()
    data_with_headers()
    update_all()
    
    