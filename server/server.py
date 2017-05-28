#crawler part
import os
import sys
sys.path.insert(0,'/Users/Jungsunwook/HyLionPost/crawlers')
from selenium import webdriver

from crawler.csck2notice import csck2notice
from crawler.csjob import csjob
from crawler.csgradu import csgradu
from crawler.csnotice import csnotice
from crawler.csstrk import csstrk
#from crawler.csstu import csstu

#json parsing part
import json, codecs

#flask part
from flask import Flask, render_template, g, jsonify
import sqlite3
from contextlib import closing
from flask_socketio import SocketIO

#firebase part
import lionbase



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

#crawler default
crawler_list = ['csck2notice','csgradu','csjob','csnotice','csstrk']

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

# DB Firebase part
def build_db():
    db = firebase.database()
    db.child("data")

# crawler and server connection part
def crawling():
    # crawling all datas from 6 websites
    csck2notice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    csgradu(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    csjob(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    csnotice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    csstrk(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    #csstu(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))

def get_json_data():
    data = []
    for name in crawler_list :
        print(name)
        crawler_file = codecs.open('./'+ name +'.json', 'r', encoding='utf-8')
        data.append(json.load(crawler_file))
        crawler_file = []
        print(data)

# WARNING!!
# this part is setting sql query and clean all data at database
# so if you run this part, erase all data.... Be careful...
@app.route('/iNit_dOn_touCh_tHis_pArt')
def init_all() :
	init_db()
	print("initialize database!!")
	return ''

@app.route('/')
@app.route('/inputdata')
def input_data ():
	with open('../crawlers/crawler/settings.json') as data_file :
		data = json.load(data_file)
	db = get_db()
	for datas in data :
		ex = db.execute('SELECT EXISTS (SELECT title from entries  where url = ? )',[data[datas]['link_url']]).fetchone()
		if (ex[0] == 0 ) :
			db.execute('INSERT into entries (filename,title,url, datetime) values (?,?,?,?)',[data[datas]['file_name'],data[datas]['title'] ,data[datas]['link_url'],0])
	db.commit()
	print("inserted all script in database!!\n")
	return ''

@app.route('/givedata')
def give_data():
    crawling()
    get_json_data()
    return ''

if __name__ == '__main__':
    socketio.run(app)
