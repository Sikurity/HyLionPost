#firebase part 
import pyrebase
from controllers.lionbase import *
from pushnotify import *

# DB Firebase part
def connect_firebase():
    db = firebase.database()
    print("connected firebase!!")
    return db

def initial_firebase():
    db = connect_firebase()
    db.child("board_datas")

def push_lionbase(data,name):
    db = connect_firebase()
    db.child("board_datas").child(name).set(data)

def load_lionbase(name):
    db = connect_firebase()
    data = db.child("board_datas").child(name).get()
    #print (data)
    return data

def update_firebase(data,name):
    db = connect_firebase()
    db.child("board_datas").child(name).update(data)


# data filter part
    
def filter_notify_func(name, new_datas, old_data) :
    if old_data :
        new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
        print('[',name.upper(),'] In db, There are ',len(old_data), ' messages')
        update_data = old_data[len(old_data)-1]['inner_idx']
        last_data = old_data[len(old_data)-1]
        for board in new_datas :
            if board['inner_idx'] != old_data[len(old_data)-1]['inner_idx'] :
                continue
            else :
                if last_data['inner_idx'] == new_datas[len(new_datas)-1]['inner_idx'] :
                    print('[',name.upper(),'] No post update!!')
                    break
                else :
                    print(update_data)
                    for x in range(len(old_data),len(new_datas)) :
                        value = {}
                        value[str(x)] = new_datas[x]
                        print('[',name.upper(),'] New data was update')
                        update_firebase(value,name)
                        print('[',name.upper(),'] New data updated in db')
                        result = pyfcm_notify(name,new_datas[x]['title'])
                        if result == 0 :
                            print('push notifitcation error')
                            sys.exit()
                        else :
                            print('notification success')
                    break
    else:
        new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
        print('first input!!')
        push_lionbase(new_datas, name)



