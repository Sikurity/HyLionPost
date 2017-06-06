//
//  SettingViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 6. 3..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 뒤로가기 용
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func GoAppPreference(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}
