#flask part
from flask import Flask, render_template, g, jsonify
import sqlite3
from contextlib import closing

#app init part
from header import *

#DB connection function 
def connect_db():
	print("connected!")
	return sqlite3.connect(app.config['DATABASE'])

#initialize DB
def init_db():
	with closing(connect_db()) as db:
		with app.open_resource('./db/schema.sql',mode='r') as f:
			db.cursor().executescript(f.read())
		db.commit()

def get_db():
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db

def close_db(error):
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()
