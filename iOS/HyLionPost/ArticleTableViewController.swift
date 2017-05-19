//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController{
    var articles:[Article]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles != nil{
            return articles!.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
        
        if articles != nil{
            cell.articleForCell = articles![indexPath.row]
        }
        
        return cell
    }
}

class AritlceTableViewCell:UITableViewCell {
    //    @IBOutlet weak var profileImageView: UIImageView!
    //    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var quoteLabel: UILabel!
    //    @IBOutlet weak var timeLabel: UILabel!
    
    
    var articleForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    
    func setUpCell() {
        guard let article = articleForCell else {
            return
        }
        
        //        nameLabel.text = article.name
        //        quoteLabel.text = article.quote
        //        timeLabel.text = article.time
    }
}
