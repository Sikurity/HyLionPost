import os
import sys
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

# crawler and server connection part
def csck2notice_server():
    while True :
        try:
            csck2notice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
            data = codecs.open(crawl + 'csck2notice.json', 'r', encoding ='utf-8')
            new_datas = json.load(data)
            old_data = load_lionbase("csck2notice").val()
            filter_notify_func("csck2notice",new_datas,old_data)
            print('[CSCK2NOTICE] server waiting...\n')
            time.sleep(15)
        except JSONDecodeError as s :
            print('thread error')
            print(s)
            sys.exit()

def csjob_server():
    while True :
        csjob(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver')) 
        data = codecs.open(crawl + '/csjob.json', 'r', encoding ='utf-8')
        new_datas = json.load(data)
        old_data = load_lionbase("csjob").val()
        filter_notify_func("csjob",new_datas,old_data)
        print('[CSJOB] server waiting...\n')
        time.sleep(15)

def csgradu_server():
    while True :
        csgradu(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csgradu.json', 'r', encoding ='utf-8')
        new_datas = json.load(data)
        old_data = load_lionbase("csgradu").val()
        filter_notify_func("csgradu",new_datas, old_data)
        print('[CSGRADU]server waiting...')
        time.sleep(15)

def csnotice_server():
    while True :
        csnotice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csnotice.json', 'r', encoding ='utf-8')
        new_datas = json.load(data)
        old_data = load_lionbase("csnotice").val()
        filter_notify_func("csnotice",new_datas, old_data)
        print('[CSNOTICE] server waiting...')
        time.sleep(15)

def csstrk_server():
    while True :
        csstrk(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open(crawl + '/csstrk.json', 'r', encoding ='utf-8')
        new_datas = json.load(data)
        old_data = load_lionbase("csstrk").val()
        filter_notify_func("csstrk",new_datas, old_data)
        print('[CSSTRK] server waiting...')
        time.sleep(15)

# test crawler part
def demo_server():
    while True :
        demon(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open( crawl + '/demon.json', 'r', encoding = 'utf-8' )
        new_datas = json.load(data)
        old_data = load_lionbase("demon").val()
        filter_notify_func("demon",new_datas, old_data)
        print('[DEMON] server waiting...')
        time.sleep(15)

