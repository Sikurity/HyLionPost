//
//  FavoritesTableViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 27..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController, UITabBarControllerDelegate {
    var favorites:[Article]? = [
        Article(title:"창의융합교육원 2017학년도 2학기 교양교육 설명회 안내", group:"컴퓨터소프트웨어학부 특성화사업단 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.24", favorite:false),
        Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.23", favorite:false),
        Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.22", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        Article(title:"2017-2학기 교내장학 신청 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("FavoritesTableViewController++")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class FavoriteTableViewCell:UITableViewCell {
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var favoriteForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    
    func setUpCell() {
        guard let article = favoriteForCell else {
            return
        }
        
        boardLabel.text = article.group
        dateLabel.text = article.date
        titleLabel.text = article.title
    }
}
