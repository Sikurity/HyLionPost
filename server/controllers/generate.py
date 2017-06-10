import os
import sys
import threading
sys.path.insert(0,'/Users/Jungsunwook/HyLionPost/crawlers')

from selenium import webdriver
from crawler.csck2notice import csck2notice
from crawler.csjob import csjob
from crawler.csgradu import csgradu
from crawler.csnotice import csnotice
from crawler.csstrk import csstrk
from crawler.demon import demon
import codecs
import json
import time

# firebase db part
from dbconn import *
import pyrebase

# notification part
from pushnotify import *

crawl = '../crawlers/crawler/result/'
lock = threading.Lock()

# crawler and server connection part
def csck2notice_server():
    while True :
        #lock.acquire()
        csck2notice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + 'csck2notice.json', 'r', encoding ='utf-8')
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("csck2notice").val()
        filter_notify_func("csck2notice",new_datas,old_data)
        print('[ CSCK2NOTICE ] Server waiting...\n')
        #lock.release()
        time.sleep(15)

def csjob_server():
    while True :
        #lock.acquire()
        csjob(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver')) 
        data = codecs.open(crawl + '/csjob.json', 'r', encoding ='utf-8')
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("csjob").val()
        filter_notify_func("csjob",new_datas,old_data)
        print('[ CSJOB ] Server waiting...\n')
        #lock.acquire()
        time.sleep(15)

def csgradu_server():
    while True :
        #lock.acquire()
        csgradu(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csgradu.json', 'r', encoding ='utf-8')
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("csgradu").val()
        filter_notify_func("csgradu",new_datas, old_data)
        print('[ CSGRADU ] Server waiting...')
        #lock.release()
        time.sleep(15)

def csnotice_server():
    while True :
        #lock.acquire()
        csnotice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csnotice.json', 'r', encoding ='utf-8')
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("csnotice").val()
        filter_notify_func("csnotice",new_datas, old_data)
        print('[ CSNOTICE ] Server waiting...')
        #lock.release()
        time.sleep(15)

def csstrk_server():
    while True :
        #lock.acquire()
        csstrk(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csstrk.json', 'r', encoding ='utf-8')
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("csstrk").val()
        filter_notify_func("csstrk",new_datas, old_data)
        print('[ CSSTRK ] Server waiting...')
        #lock.release()
        time.sleep(15)

# test crawler part
def demo_server():
    while True :
        #lock.acquire()
        demon(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open( crawl + '/demon.json', 'r', encoding = 'utf-8' )
        try :
            new_datas = json.load(data)
        except json.decoder.JSONDecodeError as e :
            print('error occur..')
            print(e)
            continue
        old_data = load_lionbase("demon").val()
        filter_notify_func("demon",new_datas, old_data)
        print('[ DEMON ] Server waiting...')
        #lock.release()
        time.sleep(15)

