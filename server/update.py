import json
import requests

def lion_main(server_key, token, message_body):
    headers = {
        'Authorization': 'key= ' + server_key,
        'Content-Type': 'application/json',
    }
    
    data = {
        'to': token,
        'data': {
            'message_body': message_body,
        },
    }

    response = requests.post('https://fcm.googleapis.com/fcm/send', headers=headers, data=json.dumps(data))
    print(response)
