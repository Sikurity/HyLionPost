//
//  MainTabBarController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 27..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit
import FirebaseMessaging

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainTabBar viewDidLoad")
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        for groupid in appDelegate.dataManager.supportedBoards.keys{
            if let board = appDelegate.dataManager.supportedBoards[groupid] {
                if board.favorite {
                    FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) subscribed")
                } else {
                    FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) unsubscribed")
                }
                
                if board.count == -1 {
                    appDelegate.dataManager.getDefaultDataFromFirebase(groupid)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 하단 탭이 눌릴 때 마다 저장
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        appDelegate.dataManager.save()
    }
}
