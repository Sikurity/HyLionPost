## HyLionPost Backend Server Part

한양 스팸 팀의  **HyLionPost** 서버 파트

#### Used Language

- Python 3.6.1

#### Running the application locally

Before running server, you must download `python3` from [python webpage](https://www.python.org/) :

~~~
~$ cd HyLionPost/server/
~$ python3 main.py // running server
~~~

And also before you running server, you must download these python packages :

~~~
~$ pip3 install selenium
~$ pip3 install pyrebase
~$ pip3 install pyfcm
~~~

#### Used Library & License

- **selenium**
  - Purpose of Use : A browser automation framework and ecosystem. In this crwalling part, We use Chrome Webdriver
  - License : Apache License 2.0
  - Github Link for [this package](https://github.com/SeleniumHQ/selenium)

- **pyrebase**
  - Purpose of Use :  python 서버가 Google Firebase에 생성한 Database에 접근하기 위해 사용하는 패키지 입니다. 이 패키지에서 만들어 놓은 함수를 이용해 DB에 접근하고 값을 불러오거나 데이터를 넘겨주고, 기존 데이터를 업데이트 할수 있는 API들이 만들어져 있습니다. 이를 이용해 크롤러에서 긁어온 데이터를 저장하는 기능을 주로 담당하였습니다. This package make python server to access Google Firebase Database part. Functions which created in this package makes us store, load, update Json Datas which crawled from notice webpages in Firebase DB.
  - License : MIT License 
  - Github Link for [this package]()
- **pyfcm**
  - Purpose of Use  : Firebase 클라우드 메세징을 하기 위해 서버에서 따로 데이터를 생성하여 request를 보낼 필요 없이, firebase 키 값과 앱 토큰만 설정하면, API를 이용해 보낼 메세지나 데이터를 함수에만 입력하면 바로 푸시 알림을 Front단으로 보내주는 패키지 입니다. 이 앱 서버에서는 키워드 구독자에게만 보내도록 설정하였습니다. This package is For Front-end Client push message, which manage at Backend Server. And Give message to Firebase Cloud Server, And This Cloud server gives Push Notify to iOS HyLionPost Application. For this application server, We use notify_topic_subscr function to send push Notify for keyword subscriber.
  - License : MIT License
  - Github Link for [this package](https://github.com/olucurious/PyFCM)

#### How it works 

서버 작동 및 데이터 변환/전송 방식

- 크롤링 파트 Crawling Part

- 데이터 변환 Data Change

  크롤링 파트에서 제공한 .json 파일과 데이터를 각 함수에서 import시켜 이를 Json.loads를 통해 데이터를 변환하였습니다.  오류가 나는 Json.decoder.JSONDecodeError는 이에 대해 오류가 발생할 경우 예외를 로그로 출력하고, 다시 while 문을 실행하여 헤당 쓰레드가 죽지 않도록 하였습니다. 헤당 에러는 일반적으로 decoding이 잘 되는 상황에서 발생하는 상황이라 크롤러가 제대로 긁어오지 못하는 상황이라 판단하여 재시작 하도록 하였습니다. 


- 데이터 베이스 연결 및 데이터 전송 DataBase connection & Data Send

   firebase에서 제공하는 database에 데이터를 전송하기 위해  pyrebase라는 패키지에서 제공하는 API들을 이용해서 데이터 베이스에 연결, 데이터 전송, 업데이트, 접근 및 데이터 가져오기 등이 가능하도록 하였습니다. 이들에 대해서는 개별적으로 개별 파이선 파일에 함수로 선언 해놓았습니다. 지속적으로 크롤러가 작동하므로, 업데이트된 데이터를 지속적으로 가져올 수 있도록 하였습니다. 


- 데이터 필터링 및 푸시 알림 Data Filtering & Push Nontification

  데이터 필터링은 필터링 알고리즘 작성 초기에는 json 데이터가 firebase database에 저장되는 과정에서, 데이터들의 순서(오름차순, 내림차순)에 대한 문제가 발생하여 난항을 겪었습니다. 새로운 공지글이 올라오면 헤당 데이터만 추출하여 DB에 저장하는데, 이 과정에서 위의 문제가 발생하였습니다. 이에 대한 알고리즘을 작성하여 문제를 해결하였고 개별 함수로 선언하여 6개의 Webpage별 함수에서 사용할 수 있도록 만들었습니다. 푸시 알림은 Client Frontend에서 요구하는 데이터 형식을 제공하여 pyfcm에서 제공하는 notify_topic_subscr 함수를 이용해 푸시 알림을 제공해주었습니다. 이 부분 또한 개별 파일로 만들어 사용하기 쉽게 하였습니다.


- 서버 구동 Server Running

  각 웹페이지 별로 함수를 생성하고 이를 동시에 업데이드 하기 위해 스레드를 사용하였습니다. 따라서 현재 테스트 페이지를 포함하여 6개의 페이지를 가져오므로 6개의 스레드를 동시에 작동시켜 일정 시간마다 데이터 베이스를 업데이트하고, 변경사항을 푸시 알림 보내도록 하였습니다. 각 쓰레드에서 나는 오류는 예외 처리를 통해서 다시 while문을 돌게 하여 쓰레드가 죽지 않도록 하였습니다. 이 프로젝트에서는 각 데이터가 업데이트 되는 시간을 15분 (900초) 로 설정하였습니다.

