#firebase part 
import pyrebase
from controllers.lionbase import *

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
