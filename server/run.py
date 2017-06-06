from threading import Thread
from dbconn import *
from controllers.generate import *

def running():
    print("running server...")
    #Thread(target=csjob_server).start()
    Thread(target=demo_server).start()


if __name__ == '__main__':
    print('server start..')
    running()
    
    

