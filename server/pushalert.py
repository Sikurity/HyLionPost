from pyfcm import FCMNotification

push_service = FCMNotification(api_key="AAAATOrYicU:APA91bH-PF80BE5eneYLq4j_S1oOrowvQMJkLkwJigHFkBZ76Fi6DaLnUuBcH__LaEfzo-f6T4eDFwjkyjPlKaWoa86Ql67rS1kuYe1jnDUS_FEt72N-Kq5vOp8SqX7s88fTQfET0xwC")

#url = "https://android.googleapis.com/gcm/notification"
registration_id = "cic-HalZiF4:APA91bGgUaOCC-l_sIeDkNIBEJ-PHCdzK0REd5D30-_ALeMoKwE27z3SimasokzFnB0buaVmFJdjhMGBViUEIotqWhMsN4qTlvNk-0gsZcI5n5xvYFiT2TIkt7h1Cp31_DzE3MMpBN9G"
message_title = "message Update"
message_body = "hello world!"

result = push_service.notify_single_device(registration_id=registration_id, message_title=message_title, message_body=message_body)
print (result)
