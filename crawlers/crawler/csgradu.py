from selenium import webdriver
from bs4 import BeautifulSoup

# TODO : change hardcoded path to relative path
driver = webdriver.Chrome('/Users/camelia/HyLionPost/crawlers/res/chromedriver')
driver.implicitly_wait(3)

base_url = 'http://cs.hanyang.ac.kr'
driver.get('http://cs.hanyang.ac.kr/board/gradu_board.php')
html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')
notices = soup.select('table.bbs_con > tbody > tr > td > a:nth-of-type(1)')
dates = soup.select('table.bbs_con > tbody > tr > td:nth-of-type(5)')

driver.close()

# idx : PK
# title : n.text.strip()
# link : base_url + n['href']
# TODO : make proper seperator
for n in notices:
    idx = int((str(n['href']).split("idx=",1)[1]).split("&page",1)[0])
    print(idx)
    print(n.text.strip())
    print(base_url + n['href'])