//
//  MainTabBarController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 27..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        print("MainTabBar viewDidLoad")
        
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0] as NSString
        let dataFilePath:String? = docsDir.appendingPathComponent("boards.archive")
        
        if let path = dataFilePath {
            if( fileMgr.fileExists(atPath: path) == false )
            {
                self.selectedIndex = 2
                print("파일 없음 : \(self.selectedIndex)")
            }
            else
            {
                print("파일 있음")
            }
        }
        else{
            print("경로 문자열 이상")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if let title = viewController.title{
            print("Title is \(title)")
        } else {
            print("Title is nil")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
