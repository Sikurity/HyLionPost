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
 *  @todo :
 *      - 아카이브 데이터 불러오기/저장하기
 *      - 푸시알림이 포어그라운드/백그라운드 에서 발생할 경우 각각 처리
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"  // firebase로 부터 전달된 메시지의 id값 확인을 위한 key
    
    var window: UIWindow?
    var dataManager = DataManager()
    
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
        
        // 토큰이 생성되기 전에 연결을 시도하면, 연결에 실패하게 됨
        connectToFcm()
    }
    
    /// 앱이 시작할 준비를 마치고 실행되기 전 실행되는 함수
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Firebase App 준비
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10, display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            // * < iOS 10, display notification (sent via APNS)
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // Remote Notification 사용 등록
        application.registerForRemoteNotifications()
        
        /// 토큰 값의 변경 관찰자 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        // 토큰 연결 확인
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            connectToFcm()
        }
        
        // Top Layout Guide 색상
        let red:Double = 0.0
        let green:Double = 118.0
        let blue:Double = 255.0
        
        // Top Layout Guide 색상 적용
        if let mainTBC = self.window?.rootViewController as? MainTabBarController {
            if let mainNC = mainTBC.viewControllers as? [UINavigationController]{
                let topBackgroundColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)

                // StatusBar 색상을 흰색으로 적용
                // Info.plist - [View controller-based status bar appearance] - No
                UIApplication.shared.statusBarStyle = .lightContent
                
                // Top Layout Guide 색상을 변경, 글자색은 흰색
                mainNC[0].navigationBar.tintColor = UIColor.white
                mainNC[0].navigationBar.barTintColor = topBackgroundColor
                mainNC[0].navigationBar.backgroundColor = topBackgroundColor
                mainNC[0].navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                
                // Top Layout Guide 색상을 변경, 글자색은 흰색
                mainNC[1].navigationBar.tintColor = UIColor.white
                mainNC[1].navigationBar.barTintColor = topBackgroundColor
                mainNC[1].navigationBar.backgroundColor = topBackgroundColor
                mainNC[1].navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                
                // Top Layout Guide 색상을 변경, 글자색은 흰색
                mainNC[2].navigationBar.tintColor = UIColor.white
                mainNC[2].navigationBar.barTintColor = topBackgroundColor
                mainNC[2].navigationBar.backgroundColor = topBackgroundColor
                mainNC[2].navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            }
        }
        
        self.updateDefaultData()    // 기본 데이터 불러오기, 앱이 설치된 후 처음 실행 됐다면 유의미
        self.dataManager.save()
        self.updateBadgeCount()     // AppIcon, TabBar에 Badge 달기
        
        return true
    }
    
    /// @brief
    ///     iOS 10 버전 미만에서 앱이 푸시 알림이 오는 경우 실행
    /// @Todo
    ///     - 공통                   알림 메시지 띄우기
    ///     - Active(Foreground)    메인 게시글 테이블의 상단에 데이터를 추가(애니메이션과 함께)
    ///     - Inactive(Foreground)  게시글 배열에 새 게시글 내용 추가
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if (application.applicationState == UIApplicationState.active ||    // At Foreground active - Firebaes로 부터 전달된 데이터 콘솔 출력
            application.applicationState == UIApplicationState.inactive) {  // At Foreground inactive - Firebaes로 부터 전달된 데이터 콘솔 출력
            print("userNotificationCenter foreground") // FOR DEBUG
            
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            FIRMessaging.messaging().appDidReceiveMessage(userInfo)
            
            print("USERINFO FOREGROUND:")
            print(userInfo)
            
            // Change this to your preferred presentation option
            completionHandler(UIBackgroundFetchResult.noData)
        }
            
        else if (application.applicationState == UIApplicationState.background) {   // At Background - Firebaes로 부터 전달된 데이터 콘솔 출력
            print("userNotificationCenter background") // FOR DEBUG
            
            
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            FIRMessaging.messaging().appDidReceiveMessage(userInfo)
            
            // Firebaes로 부터 전달된 유저정보 출력
            print("USERINFO BACKGROUND:")
            print(userInfo)
            
            // Change this to your preferred presentation option
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    /// 토큰 등록이 성공한 경우 실행되는 함수, 생성된 토큰 값을 전달해준다
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        
        print("Successful registration. Token is:\(deviceToken)")
        
        // 앱을 처음 실행했거나, 종료했다 다시 켰을 때 Firebase에 구독 요청
        for groupid in self.dataManager.supportedBoards.keys{
            if let board = self.dataManager.supportedBoards[groupid] {
                if board.favorite {
                    FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) subscribed")
                } else {
                    FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) unsubscribed")
                }
            }
        }
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
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        
        // 편집 모드에서 Background로 진입할 시, 재시작 되었을 때 BottomLayoutGuide가 사라지지 않도록 TabBar를 보이게 변경
        if let mainTBC = self.window?.rootViewController as? MainTabBarController,
            let mainNC = mainTBC.viewControllers?[0] as? UINavigationController,
            let articleVC = mainNC.viewControllers[0] as? ArticleViewController {
            
            if articleVC.tabBarController != nil {
                articleVC.tabBarController!.tabBar.isHidden = false
            }
        }
        
        self.dataManager.save() // Background로 진입하기 전에 데이터 저장
    }
    
    /// 앱이 종료되기 직전에 실행되는 함수
    func applicationWillTerminate(_ application: UIApplication)
    {
        self.dataManager.save() // 종료되기 전에 데이터 저장
    }
    
    /// @brief
    ///     앱이 백그라운드에서 포어그라운드로 전환될 때 실행되는 함수
    /// @discussion
    ///     아카이브 된 후, 백그라운드 상태에서 전달된 정보들
    /// @Todo
    ///     아카이브로 부터 데이터들을 다시 불러와 저장해야 함
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground") // FOR DEBUG
        
        self.dataManager = DataManager() // Foreground로 진입하기 전에 데이터 복구
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive") // FOR DEBUG
        
        // 편집 모드에서 Background로 진입할 시, 재시작 되었을 때 TabBar가 보이지 않도록 강제
        if let mainTBC = self.window?.rootViewController as? MainTabBarController,
            let mainNC = mainTBC.viewControllers?[0] as? UINavigationController,
            let articleVC = mainNC.viewControllers[0] as? ArticleViewController {
            
            if articleVC.tabBarController != nil {
                articleVC.tabBarController!.tabBar.isHidden = articleVC.isEditMode
            }
        }
        
        connectToFcm()
        
        FIRMessaging.messaging().connect { error in
            print(error as Any)
        }
        
        self.changeEndDateToday()   // 앱을 켠 후 날짜가 바뀐 후 수시된 게시글이 보이지 않는 것을 방지
    }
    
    func changeEndDateToday() {
        if let mainTBC = self.window?.rootViewController as? MainTabBarController,
            let mainNC = mainTBC.viewControllers?[1] as? UINavigationController,
            let filterTypeVC = mainNC.viewControllers[0] as? FilterTypeViewController {
            
            if filterTypeVC.endDatePicker != nil && filterTypeVC.boardTable != nil{
                self.dataManager.endDate = Date()
                filterTypeVC.endDatePickerChanged(self)
            }
        }
    }
    
    /// Firebase로 부터 게시판에서 최근 10개 게시글을 불러온다
    func getDefaultDataFromFirebase(where groupid:String){
        let DBref = FIRDatabase.database().reference()      // Firebase Singletone DB 참조
        
        // board_datas -> BOARD_GROUP_ID 에서 10개 데이터를 한 번만 불러옴
        DBref.child("board_datas").child(groupid).queryLimited(toLast: 10).observeSingleEvent(
            of:.value, with: { (snapshot) in
                if let values = snapshot.value as? NSDictionary {   // 데이터가 Dictionary 형태로 저장된 게시판인 경우
                    // inner_idx로 오름차순 정렬
                    let datas = values.sorted(by: { (lValue:(key: Any, value: Any), rValue:(key: Any, value: Any)) -> Bool in
                        
                        guard let val1 = lValue.value as? NSDictionary,
                            let val2 = rValue.value as? NSDictionary,
                            let idxStr1 = val1["inner_idx"] as? String,
                            let idxStr2 = val2["inner_idx"] as? String,
                            let idx1 = Int(idxStr1),
                            let idx2 = Int(idxStr2) else {
                                return true
                        }
                        
                        return idx1 < idx2
                    })
                    
                    // 게시글 목록에 추가
                    for data in datas {
                        if let article = data.value as? NSDictionary,
                            let datetime = article["datetime"] as? String,
                            let fileName = article["file_name"] as? String,
                            let key = article["inner_idx"] as? String,
                            let link = article["link"] as? String,
                            let title = article["title"] as? String {
                            
                            let groupId = fileName.components(separatedBy: ".")[0]
                            print("\(groupId)::\(key) - \(title)")
                            self.dataManager.supportedBoards[groupId]?.articles[key] = Article(title: title, groupid: groupId, key: key, url: link, date: datetime, archived: false)
                        } else {
                            print("Invalid data")
                            print(data.value)
                        }
                    }
                } else if let values = snapshot.value as? [Any] {   // 데이터가 Object Array 형태로 저장된 게시판인 경우
                    // inner_idx로 오름차순 정렬
                    let datas = values.sorted(by: { (lValue:Any, rValue:Any) -> Bool in
                        
                        guard let val1 = lValue as? NSDictionary,
                            let val2 = rValue as? NSDictionary,
                            let idxStr1 = val1["inner_idx"] as? String,
                            let idxStr2 = val2["inner_idx"] as? String,
                            let idx1 = Int(idxStr1),
                            let idx2 = Int(idxStr2) else {
                                return true
                        }
                        
                        return idx1 < idx2
                    })
                    
                    // 게시글 목록에 추가
                    for data in datas {
                        if let article = data as? NSDictionary,
                            let datetime = article["datetime"] as? String,
                            let fileName = article["file_name"] as? String,
                            let key = article["inner_idx"] as? String,
                            let link = article["link"] as? String,
                            let title = article["title"] as? String {
                            
                            let groupId = fileName.components(separatedBy: ".")[0]
                            print("\(groupId)::\(key) - \(title)")
                            self.dataManager.supportedBoards[groupId]?.articles[key] = Article(title: title, groupid: groupId, key: key, url: link, date: datetime, archived: false)
                        } else {
                            print("Invalid data")
                            print(data)
                        }
                    }
                } else {
                    // 변환 실패
                    print("Convert Snapshot Failed...")
                }
                
                // Firebase로 부터 한 번 불러왔다는 것을 표시하기 위해 -1 값을 0 이상의 값으로 변경
                if let count = self.dataManager.supportedBoards[groupid]?.articles.count {
                    self.dataManager.supportedBoards[groupid]?.count = count
                }
                
                // 추가된 게시물 반영
                self.updateArticleTable()
                self.updateBoardTable()
                self.updateBadgeCount()
                
                self.dataManager.save()
                
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /// 구독 중인 게시판들 중, 기본 데이터가 없는 경우 Firebase DB로 부터 불러오기
    func updateDefaultData(){
        for board in self.dataManager.supportedBoards.values {
            if board.favorite && board.count == -1 {
                self.getDefaultDataFromFirebase(where: board.groupid)
            }
        }
    }
    
    /// 읽지 않은 게시글 개수를 AppIcon에 badge로, Tab1에 badge에는 탭1에서 읽지 않은 게시글 개수를, Tab2 badge에는 필터링 됐지만 읽지 않은 게시글 개수 표시
    func updateBadgeCount(){
        // 읽지 않은 게시글 개수를 AppIcon에 badge
        UIApplication.shared.applicationIconBadgeNumber = self.dataManager.calculateAllNewsCount()
        
        if let mainTBC = self.window?.rootViewController as? MainTabBarController {
            // 탭1에서 읽지 않은 게시글 개수
            if let tab1st = mainTBC.tabBar.items?[0] {
                let count = self.dataManager.calculateAllNewsCount(filtered: false)
                tab1st.badgeValue = count > 0 ? "\(count)" : nil
            }
            
            // 필터링 됐지만 읽지 않은 게시글 개수 표시
            if let tab2nd = mainTBC.tabBar.items?[1] {
                let count = self.dataManager.calculateAllNewsCount(filtered: true)
                tab2nd.badgeValue = count > 0 ? "\(count)" : nil
            }
        }
    }
    
    // Tab1 게시글 테이블 갱신
    func updateArticleTable(){
        if let mainTBC = self.window?.rootViewController as? MainTabBarController,
            let mainNC = mainTBC.viewControllers?[0] as? UINavigationController,
            let articleVC = mainNC.viewControllers[0] as? ArticleViewController {
            
            if articleVC.articleTable != nil {
                articleVC.filterArticles()
                articleVC.articleTable.reloadData()
            }
        }
    }

    // Tab2 게시글 테이블 갱신
    func updateBoardTable(){
        if let mainTBC = self.window?.rootViewController as? MainTabBarController,
            let mainNC = mainTBC.viewControllers?[1] as? UINavigationController,
            let filterTypeVC = mainNC.viewControllers[0] as? FilterTypeViewController {
            
            if filterTypeVC.boardTable != nil {
                filterTypeVC.boardTable.reloadData()
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 앱이 Foreground에서 실행되고 있을 때 푸시 알림이 온 경우 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter willPresent") // FOR DEBUG
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let fileName = userInfo["file_name"] as? String, let key = userInfo["inner_idx"] as? String{
            let groupId = fileName.components(separatedBy: ".")[0]
            
            if let title = userInfo["title"] as? String, let link = userInfo["link"] as? String, let datetime = userInfo["datetime"] as? String {
                self.dataManager.supportedBoards[groupId]?.articles[key] = Article(title: title, groupid: groupId, key: key, url: link, date: datetime, archived: false)
            }
            
            self.dataManager.save()
            
            self.updateArticleTable()
            self.updateBoardTable()
            self.updateBadgeCount()
        }
        
        // Print full message.
        print(userInfo) 
        
        completionHandler([.alert,.badge,.sound])
    }
    
    // 앱이 Background에서 실행되고 있거나 종료되어 있을 때 푸시 알림이 온 경우 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter didReceive") // FOR DEBUG
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let fileName = userInfo["file_name"] as? String, let key = userInfo["inner_idx"] as? String{
            let groupId = fileName.components(separatedBy: ".")[0]
            
            if let title = userInfo["title"] as? String, let link = userInfo["link"] as? String, let datetime = userInfo["datetime"] as? String {
                self.dataManager.supportedBoards[groupId]?.articles[key] = Article(title: title, groupid: groupId, key: key, url: link, date: datetime, archived: false)
            }
            
            self.dataManager.save()
            
            self.updateArticleTable()
            self.updateBoardTable()
            self.updateBadgeCount()
            
            self.changeEndDateToday()   // 앱을 켠 후 날짜가 바뀐 후 수시된 게시글이 보이지 않는 것을 방지
        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("applicationReceivedRemoteMessage") // FOR DEBUG
        
        print(remoteMessage.appData)
    }
}
