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
from controllers.generate import csck2notice_server, csjob_server, csgradu_server, csstrk_server, csnotice_server

#json parsing part
import json, codecs

#flask part
from flask import Flask, render_template, g, jsonify
import sqlite3
from contextlib import closing

#firebase part 
import pyrebase
from controllers.lionbase import *

#app init part
from header import *
from controllers.dbconn import *

# DB Firebase part
def connect_firebase():
    db = firebase.database()
    print("connected firebase!!")
    return db

def initial_firebase():
    db = connect_firebase()
    db.child("board_datas")

def push_lionbase(data,name):
    db = connect_firebase()
    db.child("board_datas").child(name).push(data)

# WARNING!!
# this part initial part
# so if you run this part, erase all data.... Be careful...
@app.route('/iNit_dOn_touCh_tHis_pArt')
def init_all() :
	init_db()
	print("initialize database!!")
	return ''

@app.route('/init_firebase')
def init_db() :
    initial_firebase()
    print("initalize firebase")
    return ''


# running part #

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

###########################
# data send part by website
###########################
    
@app.route('/csjob')
def give_csjob():
    data = csjob_server()
    push_lionbase(data,"csjob")
    return jsonify(data), 202

@app.route('/csck2notice')
def give_csck2():
    data = csck2notice_server()
    push_lionbase(data,"csck2")
    return jsonify(data), 202

@app.route('/csstrk')
def give_csstrk():
    data = csstrk_server()
    push_lionbase(data,"csstrk")
    return jsonify(data), 202

@app.route('/csnotice')
def give_csnotice():
    data = csnotice_server()
    push_lionbase(data,"csnotice")
    return jsonify(data), 202

@app.route('/csgradu')
def give_csgradu():
    data = csgradu_server()
    push_lionbase(data,"csgradu")
    return jsonify(data), 202


