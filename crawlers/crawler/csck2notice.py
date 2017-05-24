from selenium import webdriver
from bs4 import BeautifulSoup

#driver : chromedriver
def csck2notice(driver):
    driver.implicitly_wait(3)
    base_url = 'http://csck2.hanyang.ac.kr/'
    driver.get('http://csck2.hanyang.ac.kr/front/community/notice')
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')
    hrefs = soup.select('ul.board-default-list > li > a')
    notices = soup.select('ul.board-default-list > li > a > span.subject')
    dates = soup.select('ul.board-default-list > li > a > span.datetime')

    driver.close()

    # idx : PK
    # title : n.text.strip()
    # link : base_url + n['href']
    # TODO : make proper seperator
    for n,h,d in zip(notices,hrefs,dates):
        idx = int((str(h['href']).split("id=",1)[1]))
        print(idx)
        print((n.text)[3:].strip())
        print(base_url + h['href'])
        print(d.text.strip())