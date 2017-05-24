from selenium import webdriver
from bs4 import BeautifulSoup

def csstrk(driver):
    driver.implicitly_wait(3)

    base_url = 'http://cs.hanyang.ac.kr'
    driver.get('http://cs.hanyang.ac.kr/board/trk_board.php')
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')
    notices = soup.select('table.bbs_con > tbody > tr > td > a:nth-of-type(1)')
    dates = soup.select('table.bbs_con > tbody > tr > td:nth-of-type(5)')

    driver.close()

    # idx : PK
    # title : n.text.strip()
    # link : base_url + n['href']
    # save as json format

    output_file = open("csstrk.json",'w')
    output_file.write("[")
    is_first = True
    for n,d in zip(notices,dates):
        if is_first:
            output_file.write("{")
            is_first = False
        else :
            output_file.write(",{")
        idx = int((str(n['href']).split("idx=",1)[1]).split("&page",1)[0])
        output_file.write("\"file_name\" : \"csstrk.py\",\"inner_idx\" : \"")
        output_file.write(str(idx))
        output_file.write("\",\"title\": \"")
        output_file.write(n.text.strip())
        output_file.write("\",\"link\":\"")
        output_file.write(base_url + n['href'])
        output_file.write("\",\"datetime\":\"")
        output_file.write(d.text.strip())
        output_file.write("\"}")
    output_file.write("]")

csstrk(webdriver.Chrome('/Users/camelia/HyLionPost/crawlers/res/chromedriver'))