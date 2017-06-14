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
        
        appLogoImageView.layer.cornerRadius = 20.0      // 앱로고 둥근 모서리 반경
        appLogoImageView.layer.masksToBounds = true     // 앱로고 둥근 모서리 추가
        
        gotoReceiveBoardSettingView.layer.borderWidth = 1   // 게시판 설정 탭 경계선 추가
        gotoDataSettingView.layer.borderWidth = 1           // 데이터 설정 탭 경계선 추가
        
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
        
        // 데이터 설정 탭을 누르면, 환경설정의 HyLionPost 앱 설정으로 이동시킴
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}
