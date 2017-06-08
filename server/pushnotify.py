from pyfcm import FCMNotification

push_service = FCMNotification(api_key="AAAATOrYicU:APA91bH-PF80BE5eneYLq4j_S1oOrowvQMJkLkwJigHFkBZ76Fi6DaLnUuBcH__LaEfzo-f6T4eDFwjkyjPlKaWoa86Ql67rS1kuYe1jnDUS_FEt72N-Kq5vOp8SqX7s88fTQfET0xwC")

def pyfcm_notify(name,message):
    message_body = '['+ name.upper() +'] ' + message['title']
    data_message = message
    result = push_service.notify_topic_subscribers(topic_name=name, message_body=message_body,data_message=data_message)
    return result['success']
