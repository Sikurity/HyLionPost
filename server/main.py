import sys
from threading import Thread
from dbconn import *
from controllers.generate import *

def running():
    print("running server...")
    threadsLists = []

    threadObj1 = Thread(target=csck2notice_server)
    threadsLists.append(threadObj1)
    threadObj1.start()
        
    threadObj2 = Thread(target=csjob_server)
    threadsLists.append(threadObj2)
    threadObj2.start()
 
    threadObj3 = Thread(target=csgradu_server)
    threadsLists.append(threadObj3)
    threadObj3.start()

    threadObj4 = Thread(target=csnotice_server)
    threadsLists.append(threadObj4)
    threadObj4.start()

    threadObj5 = Thread(target=csstrk_server)
    threadsLists.append(threadObj5)
    threadObj5.start()

    threadObj6 = Thread(target=demo_server)
    threadsLists.append(threadObj6)
    threadObj6.start()

    for thread in threadsLists :
        thread.join()
    '''
    thread = Thread(target=demo_server)
    thread.start()
    thread.join()
    '''

if __name__ == '__main__' :
    print('server start..')
    running()
    
    

