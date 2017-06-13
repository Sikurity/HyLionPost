//
//  SettingViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 6. 3..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var appLogoImageView: UIImageView!

    @IBOutlet weak var gotoReceiveBoardSettingView: UIButton!
    @IBOutlet weak var gotoDataSettingView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appLogoImageView.layer.cornerRadius = 20.0
        appLogoImageView.layer.masksToBounds = true
        
        gotoReceiveBoardSettingView.layer.borderWidth = 1
        gotoDataSettingView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 뒤로가기 처리용
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
