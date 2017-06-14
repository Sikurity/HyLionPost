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
    return data

def update_firebase(data,name):
    db = connect_firebase()
    db.child("board_datas").child(name).update(data)


# data filter part

def find_index(json_data,update_data):
    for Index, Obj in enumerate(json_data):
        if Obj['inner_idx'] == update_data :
            return Index
    return -1

def Update_push_data (name, new_datas, newLength, oldLength, indexNum):
    for x in range(oldLength, oldLength + newLength - indexNum - 1) :
        value = {}
        insertIndex = x - oldLength + indexNum + 1
        value[str(x)] = new_datas[insertIndex]
        print('[ ',name.upper(),' ] New data was update')
        update_firebase(value,name)
        print('[ ',name.upper(),' ] New data updated in db')
        result = pyfcm_notify(name,new_datas[insertIndex])
    return result

def filter_notify_func(name, new_datas, old_data) :
    NAME = name.upper()
    # check DB is empty
    if old_data :
        # sorting Ascending
        new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
        print('[',name.upper(),'] In db, There are ',len(old_data), ' messages')
        
        # define check value
        last_data = old_data[len(old_data)-1]
        update_data = old_data[len(old_data)-1]['inner_idx'] 

        # filtering part
        for board in new_datas :
            # Check last board post
            if board['inner_idx'] == update_data :
                # There is no update data, FINISH 'for' statement
                if update_data == new_datas[len(new_datas)-1]['inner_idx'] :
                    print('[',NAME,'] No post update!!')
                    break
                else :
                    # FIND index number of Update point of json data
                    IndexNum = find_index(new_datas, update_data)
                    if IndexNum == -1 :
                        print('Error Finding.. Restart!!')
                        break

                    # UPDATE and PUSH NEW data in firebase and client
                    if Update_push_data(name, new_datas,len(new_datas),len(old_data),IndexNum) == 0 :
                        print('[ ',NAME,' ] Push Notify Error')
                    else :
                        print('[ ',NAME,' ] Notification Success')
                    break
            else :
                # if all data update posts, insert all posts which is newly crawled data
                if board['inner_idx'] == new_datas[len(new_datas)-1]['inner_idx'] :
                    print('[ ' + name.upper() + ' ] All posts New!!')
                    
                    # UPDATE and PUSH ALL data in firebase and client
                    if Update_push_data(name, new_datas, len(new_datas), len(old_data), 0) == 0 :
                        print('[ ',NAME,' ] Push Notify Error')
                    else :
                        print('[ ',NAME,' ] Notification Success')
                else :
                    continue
    else:
        # No datas which newly crawled insert in db
        new_datas = sorted(new_datas, key=lambda tmp : int(tmp['inner_idx']))
        print('first input!!')
        push_lionbase(new_datas, name)



