//
//  FavoritesTableViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 27..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    var favorites:[Article] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let mainTBC = self.tabBarController as! MainTabBarController
        
        favorites = []
    
        if let news = mainTBC.articles {
            for article in news
            {
                if article.favorite {
                    favorites.append(article)
                }
            }
        }
        
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.favoriteForCell = favorites[indexPath.row]
        cell.setUpBoardName(getBoardName(favorites[indexPath.row].groupid))
        
        return cell
    }
    
    func getBoardName(_ groupid:String) -> String
    {
        let mainTBC = self.tabBarController as! MainTabBarController
        
        for board in mainTBC.supportedBoards{
            if board.groupid == groupid{
                return board.name
            }
        }
        
        return "unknown"
    }
    
    /// 마지막 게시글이 탭바에 가려져 선택하기 힘든 것을 해결하기 위해 탭바 높이 만큼의 Footer를 추가
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tabBarController!.tabBar.frame.height
    }
    
    /// 마지막 게시글이 탭바에 가려져 선택하기 힘든 것을 해결하기 위해 빈 탭바 추가
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
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
    
    func setUpBoardName(_ boardName:String){
        boardLabel.text = boardName
    }
    
    func setUpCell() {
        guard let article = favoriteForCell else {
            return
        }
        
        boardLabel.text = ""
        dateLabel.text = article.date
        titleLabel.text = article.title
    }
}
