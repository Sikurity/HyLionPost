from selenium import webdriver
from bs4 import BeautifulSoup

def demon(driver):
    driver.implicitly_wait(3)

    base_url = 'https://cameliaovo.github.io/'
    driver.get('https://cameliaovo.github.io/')
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')
    notices = soup.select('div.all-posts > a.post-list-item')
    titles = soup.select('div.all-posts > a.post-list-item > h2')
    dates = soup.select('div.all-posts > a.post-list-item > span')

    driver.close()

#print(notices)


    # idx : PK
    # title : n.text.strip()
    # link : base_url + n['href']
    # save as json format
    output_file = open("crawler/result/demon.json",'w')
    output_file.write("[")
    is_first = True
    for n,t,d in zip(notices,titles, dates):
# print(n)
#        print(t)
#        print(d)
        if is_first:
            output_file.write("{")
            is_first = False
        else :
            output_file.write(",{")
        idx = int((str(n['href']).split("idx_",1)[1]).split("/",1)[0])
        output_file.write("\"file_name\" : \"demon.py\",\"inner_idx\" : \"")
        output_file.write(str(idx))
        output_file.write("\",\"title\": \"")
        output_file.write(t.text.strip().replace("\"", "'"))
        output_file.write("\",\"link\":\"")
        output_file.write(base_url + n['href'])
        output_file.write("\",\"datetime\":\"")
        output_file.write(d.text.strip())
        output_file.write("\"}")
    output_file.write("]")
