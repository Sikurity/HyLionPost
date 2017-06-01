import pyrebase
global config, firebase
config = {
    "apiKey": "AIzaSyCZVFT4NRD-FQ8_kSDlmq084bs8YxbduDM",
    "authDomain" : "",
    "databaseURL": "https://hylionpost-2d3f7.firebaseio.com",
    "storageBucket": "hylionpost-2d3f7.appspot.com",
    "serviceAccount": "./db/hylionpost-2d3f7-firebase-adminsdk-3973o-4a35dbbfc1.json"
}

firebase = pyrebase.initialize_app(config)
