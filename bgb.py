import requests as req
import pandas as pd
import os
import psycopg2 as ps
from sqlalchemy import create_engine

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
cur.execute("SELECT VERSION()").fetchall()