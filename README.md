# etl-python-task

## Language and Script
1. Python
2. SQL

## Databases 
1. Source DB: JSON data provided for the assessment directly from a Git Repository
2. Staging DB: Locally hosted PostgreSQL DB created with Docker
3. Warehouse (OLAP): Locally hosted PostgreSQL DB created with Docker

## Tools and Technology Used
1. Pandas on Python, for reading data from source, loading data into destination
2. Docker

## Architecture
![etl-task drawio](https://user-images.githubusercontent.com/62335314/184490004-001f4248-4fb1-4622-9da2-f30b34a673af.png)


## Approach
##### The below shows a step-step of how this prject was started and ended
This task is considered to be a full-on ETL task involving moving data from the source to a staging environment and finally to a production database (warehouse). 

For the sake of this task, we will first be getting the data from the Github directly via an API which we then read using Pandas DataFrame. This will read all the tables the way they are without doing any form of change or transaformation.

## SOURCE TO STAGING
I considered working with the data in CSV instead of the .json format in came with. Hence, I moved the data from the original .json source to a STAGING environment (.stg, _stg extensions in the code base).
Note that, at this stage, I noticed some of the tables do not have headers which were tricky at this point. So I manually assigned headers to this data as at the point of moving from source to staging. Hence in my approach I two functions to cater for such

 a. def data_without_header (for continents, countries.3to2, countries.2to3)
 b. def data_with_header (for all other tables)

In moving the data from source to staging, the following were considered:
 1. I want the data the way it is without any transformation or changes at this point 
 2. The only change done was the file format: json to csv which allowed for easily manipulation for the data without column headers
 3. I implemented a "TRUNCATE TABLE" query to always empty the table first before loading whenever the ETL pipeline runs (FULL REPLICATION)

## STAGING TO WAREHOUSE
At this point and at every pipeline run, we already have data stored in our staging database which truncates and gets loaded with "all data" from the source. But for the warehouse, we will not be "TRUNCATING", instead we will at first instance load all the data from staging once but subsequent runs will from staging to the warehouse will be INCREMENTAL (i.e checking for new rows of data)
To do this, a MERGE query (which can be found in update.sql file) which will first check if there are differences between the two systems. If there is a no difference, nothing happens. But if there is, an update will the new records will be addded to the warehouse.

This approach was used for all tables except "CURRENCY". This is because there it doesn't primarily have a source table, hence I looked at the data in COUNTRIES table, then used an SQL INSERT INTO SELECT to get data into our new CURRENCY table having two columns (name - country and currency, name will serve as a FK). However, the same process of updating and load is still been followed using the MERGE implementation.

## RECOMMENDATIONS AND TO-DO
 1. To make this more efficient and to eleiminate plenty of manual runs, we can use a scheduler like Airflow to run the peipelines where each functions in our implementations will be run as different tasks
 2. The data contains a NULL data across different tables, hence results from queries might not be efficient at first sight. To curb this, a dictionary should be provided first on all tables and also business decisions should be made on how to treat the data

## HOW TO RUN THE CODES AND SEE RESULT INDEPENDENTLY
 1. Firstly, have docker installed on your machine
 2. cd into the folder of this task, preferrably using integrated terminal in VS Code
 3. Install all necessary requirements needed for this by running "pip install -r requirements.txt" on your terminal
 4. Afer installing docker and making sure you are in the folder of this task in your VS Code, run "docker-compose up". This will create empty tables (both staging and production). To see these tables, open a GUI (preferrably DBeaver to login in to a PostgreSQL instance using port 5438, user: postgres, password: postgres, host: localhost)
 5. After confirming with no errors that the table has been created, go back to VS Code and on the terminal, run "python etl_script_py"


### SCREENSHOTS - TASK RESULTS

![Screenshot (9)](https://user-images.githubusercontent.com/62335314/184510995-5842bc92-4971-4a60-a7e3-ed50d3584fba.png)
![Screenshot (10)](https://user-images.githubusercontent.com/62335314/184511005-14441fc3-495a-4faa-8a9c-e1e00a27d636.png)
![Screenshot (11)](https://user-images.githubusercontent.com/62335314/184511010-a91418e3-6244-406c-aecd-57e51213385b.png)


  
