import os
import sys
import threading

from selenium import webdriver
from crawler.csck2notice import csck2notice
from crawler.csjob import csjob
from crawler.csgradu import csgradu
from crawler.csnotice import csnotice
from crawler.csstrk import csstrk
from crawler.demon import demon
from crawler.engrnotice import engrnotice
import codecs
import json
import time

# firebase db part
from dbconn import *
import pyrebase

# notification part
from pushnotify import *

server = os.path.abspath(os.path.join(os.path.dirname(__file__),".."))

UPDATETIME = 3600

# main proceed part

def lion_running (name):
    data = codecs.open(server + '/crawler/result/' + name +'.json', 'r', encoding ='utf-8')
    try :
        new_datas = json.load(data)
    except json.decoder.JSONDecodeError as e :
        print('[ '+ name.upper()  + ' HANDLING ] ')
        print(e)
        return 1
    old_data = load_lionbase(name).val()
    filter_notify_func(name,new_datas,old_data)
    print('[ ' + name.upper() +' ] Server waiting...\n')
    return 0

print(server + '/res/chromedriver')
# crawler and server connection part
def csck2notice_server():
    while True :
        csck2notice(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("csck2notice") :
            continue
        time.sleep(UPDATETIME)

def csjob_server():
    while True :
        csjob(webdriver.Chrome(server + '/res/chromedriver')) 
        if lion_running("csjob") :
            continue
        time.sleep(UPDATETIME)

def csgradu_server():
    while True :
        csgradu(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("csgradu") :
            continue
        time.sleep(UPDATETIME)

def csnotice_server():
    while True :
        csnotice(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("csnotice") :
            continue
        time.sleep(UPDATETIME)

def csstrk_server():
    while True :
        csstrk(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("csstrk") :
            continue
        time.sleep(UPDATETIME)

# test crawler part
def demo_server():
    while True :
        demon(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("demon") :
            continue
        time.sleep(UPDATETIME)


def engrnotice_server():
    while True :        
        engrnotice(webdriver.Chrome(server + '/res/chromedriver'))
        if lion_running("engrnotice") :
            continue
        time.sleep(UPDATETIME)
