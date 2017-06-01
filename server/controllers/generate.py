import os
import sys
sys.path.insert(0,'/Users/Jungsunwook/HyLionPost/crawlers')

from selenium import webdriver
from crawler.csck2notice import csck2notice
from crawler.csjob import csjob
from crawler.csgradu import csgradu
from crawler.csnotice import csnotice
from crawler.csstrk import csstrk
import codecs
import json

crawl = '../crawlers/crawler/result/'

# crawler and server connection part
def csck2notice_server(): 
    csck2notice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    data = codecs.open(crawl + 'csck2notice.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    return datas
def csjob_server():
    csjob(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver')) 
    data = codecs.open(crawl + '/csjob.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    return datas

def csgradu_server():
    csgradu(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    data = codecs.open(crawl + '/csgradu.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    return datas

def csnotice_server():
    csnotice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    data = codecs.open(crawl + '/csnotice.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    return datas

def csstrk_server():
    csstrk(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    data = codecs.open(crawl + '/csstrk.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    return datas
