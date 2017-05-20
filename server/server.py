import json
from flask import Flask, render_template, g
import os
import sqlite3
from contextlib import closing
from flask_socketio import SocketIO
from pprint import pprint


# Make app & configuration
app = Flask(__name__)
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, './db/postlist.db'),
    DEBUG=True,
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='default'
))
socketio = SocketIO(app)


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

# WARNING!!
# this part is setting sql query and clean all data
# so if you run this part, erase all data.... Be careful...
@app.route('/iNit_dOn_touCh_tHis_pArt')
def init_all() :
	init_db()
	print("initialize database!!")
	return ''


@app.route('/givedata')
def give_data ():
	with open('../crawlers/crawler/settings.json') as data_file :
		data = json.load(data_file)
	#init_db()
	#print("initialize database!!")
	db = get_db()
	for datas in data :
		ex = db.execute('SELECT EXISTS (SELECT title from entries  where url = ? )',[data[datas]['link_url']]).fetchone()
		if (ex[0] == 0 ) :
			db.execute('INSERT into entries (filename,title,url, datetime) values (?,?,?,?)',[data[datas]['file_name'],data[datas]['title'] ,data[datas]['link_url'],0])
		#pprint(data[datas]['file_name'])
	db.commit()
	print("inserted all script in database!!\n")
	return ''



if __name__ == '__main__':
    socketio.run(app)
