import json
from flask import Flask, render_template, g
import os
import sqlite3
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
		with app.open_resource('schema.sql') as f:
			db.cursor().executescript(f.read())
		db.commit()

def get_db():
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db

def close_db(error):
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


#def input_postdata(filename,id,title,url):



@app.route('/givedata')
def give_data ():
	with open('settings.json') as data_file :
		data = json.load(data_file)
	db = get_db()
	#db.execute('insert into entries (file,)')
	pprint(data['csgradu'])
	return 'helloworld'



if __name__ == '__main__':
    socketio.run(app)
