
://fcm.googleapis.com/fcm/send'
body = {  
    "data":{  
           "title":"mytitle",
              "body":"mybody",
                "url":"myurl"
    },
    "notification":{  
          "title":"My web app name",
            "body":"message",
              "content_available": "true"
    },
     "to":"device_id_here"
          }


headers = {"Content-Type":"application/json",
            "Authorization": "key=api_key_here"}
            requests.post(url, data=json.dumps(body), headers=headers)egistration_id = "dTfzXeKOHPQ:APA91bHitIQChHEY_8KuQzIRi7RASliO735jogX7X1lFa5xUuG7fFMFsBFVFfXSBbVhxUljx-EHgs0bh30dh32yWzx7zC623ZYjqe4aDCyn-acTue_pzgYYrKOLJkAod5ttOt75FQTLN"
