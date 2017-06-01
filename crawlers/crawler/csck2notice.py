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
    # save as json format
    output_file = open("../crawlers/crawler/result/csck2notice.json", 'w')
    output_file.write("[")
    is_first = True
    for n,h,d in zip(notices,hrefs,dates):
        if is_first:
            output_file.write("{")
            is_first = False
        else :
            output_file.write(",{")
        idx = int((str(h['href']).split("id=",1)[1]))
        output_file.write("\"file_name\" : \"csck2notice.py\",\"inner_idx\" : \"")
        output_file.write(str(idx))
        output_file.write("\",\"title\": \"")
        output_file.write((n.text)[3:].strip())
        output_file.write("\",\"link\":\"")
        output_file.write(base_url + h['href'])
        output_file.write("\",\"datetime\":\"")
        output_file.write(d.text.strip())
        output_file.write("\"}")
    output_file.write("]")

csck2notice(webdriver.Chrome('/Users/camelia/HyLionPost/crawlers/res/chromedriver'))