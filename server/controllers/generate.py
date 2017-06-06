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

crawl = '../crawlers/crawler/result/'

# crawler and server connection part
def csck2notice_server(): 
    csck2notice(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
    data = codecs.open(crawl + 'csck2notice.json', 'r', encoding ='utf-8')
    datas = json.load(data)
    old_data = load_lionbase("csjob")
    print (old_data.key())
    push_lionbase(datas,"csck2notice")
    return datas
def csjob_server():
    while True :
        csjob(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver')) 
        data = codecs.open(crawl + '/csjob.json', 'r', encoding ='utf-8')
        datas = json.load(data)
        old_data = load_lionbase("csjob").val()
        if old_data :
            first_dat = old_data[0]
            for board in old_data :
                if board['inner_idx'] == datas[0]['inner_idx'] :
                    if first_dat['inner_idx'] == board['inner_idx'] :
                        print('[CSJOB] No board lists are not updated...')
                        break
                    else :
                        print('[CSJOB] New posts updated!!')
                        print(board)
        else:
            print('first input!!\n')
            push_lionbase(datas,"csjob")
        print('server waiting...\n')
        time.sleep(5)

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

# test crawler part
def demo_server():
    while True :
        demon(webdriver.Chrome('/Users/Jungsunwook/HyLionPost/crawlers/res/chromedriver'))
        data = codecs.open( crawl + '/demon.json', 'r', encoding = 'utf-8' )
        new_datas = json.load(data)
        old_data = load_lionbase("demon").val()
        if old_data :
            new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
            print(len(old_data))
            update_data = old_data[len(old_data)-1]['inner_idx']
            last_data = old_data[len(old_data)-1]
            for board in new_datas :
                if board['inner_idx'] != old_data[len(old_data)-1]['inner_idx'] :
                    continue
                else :
                    if last_data['inner_idx'] == new_datas[len(new_datas)-1]['inner_idx'] :
                        print('[DEMO] No post update!!')
                        break
                    else :
                        print(update_data)
                        for x in range(len(old_data),len(new_datas)) :
                            value = {}
                            value[str(x)] = new_datas[x]
                            print('[DEMO] New data was update')
                            update_firebase(value,"demon")
                            print('[DEMO] New data updated in db')
                        break
        else:
            new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
            print('first input!!')
            push_lionbase(new_datas,"demon")
        print('server waiting...')
        time.sleep(10)

