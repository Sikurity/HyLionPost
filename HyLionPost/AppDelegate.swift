import UIKit
import CoreData
import CoreLocation
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

/**
 *  @author
 *      이영식
 *  @date
 *      17` 05. 19
 *  @brief
 *      어플리케이션 Delegate
 *  @discussion
 *
 *  @Todo :
 *      - 아카이브 데이터 불러오기/저장하기
 *      - 푸시알림이 포어그라운드/백그라운드 에서 발생할 경우 각각 처리
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    /// Firebase에 연결
    func connectToFcm() {
        // 토큰 생성이 되지 않을 경우 return
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // 만약 이전 연결이 존재 하는 경우 끊고 다시 연결
        FIRMessaging.messaging().disconnect()
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    /// 토큰 값 변경 관찰자가 수행할 함수
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    /// 앱이 시작할 준비를 마치고 실행되기 전 실행되는 함수
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// @Todo App이 새로 작동되면, 현재 사용자의 Board, Article, 환경설정 등을 Archive로 부터 불러들여야 함
        
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        /// 토큰 값의 변경 관찰자 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            connectToFcm()
        }
        
        return true
    }
    
    /// @brief
    ///     포어그라운드 상태에서 푸시알림이 온 경우 실행
    /// @discussion
    ///     만약 앱이 백그라운드 상태에서 푸시알림이 온 경우라면 아래 함수는 실행되지 않음에 유의
    /// @Todo
    ///     메인 게시글 테이블의 상단에 데이터를 추가(애니메이션과 함께)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // Firebaes로 부터 전달된 데이터 콘솔 출력
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Firebaes로 부터 전달된 유저정보 출력
        print(userInfo)
    }
    
    /// 토큰 등록이 성공한 경우 실행되는 함수, 생성된 토큰 값을 전달해준다
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        print("Successful registration. Token is:\(deviceToken)")
    }
    
    
    /// 토큰 등록이 실패한 경우 실행되는 함수, 실패 정보를 갖는 에러를 전달해준다
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    /// @brief
    ///     앱이 백그라운드 상태로 진입할 때 실행되는 함수
    /// @discussion
    ///     백그라운드 상태를 지원하지 않는 다면 실행되지 않고, applicationWillTerminate가 곧바로 실행 됨에 유의
    /// @Todo
    ///     현재 데이터들을 아카이브화 시켜 저장해야 함
    func applicationDidEnterBackground(_ application: UIApplication) {
        // FIRMessaging.messaging().disconnect()
        // print("Disconnected from FCM.")
    }
    
    /// @brief
    ///     앱이 백그라운드에서 포어그라운드로 전환될 때 실행되는 함수
    /// @discussion
    ///     아카이브 된 후, 백그라운드 상태에서 전달된 정보들
    /// @Todo
    ///     아카이브로 부터 데이터들을 다시 불러와 저장해야 함
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    /// 앱이 종료되기 직전에 실행되는 함수
    func applicationWillTerminate(application: UIApplication)
    {
        /// @Todo 현재 데이터들을 아카이브화 시켜 저장해야 함
    }

    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        connectToFcm()
        
        FIRMessaging.messaging().connect { error in
            print(error as Any)
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
        print(remoteMessage.appData)
    }
}
