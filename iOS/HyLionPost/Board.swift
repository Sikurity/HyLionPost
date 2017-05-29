//
//  Board.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 19..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import Foundation

/**
 *  @author
 *      이영식
 *  @date
 *      17` 05. 19
 *  @brief
 *      게시판
 *  @discussion
 *      articles 삭제, 관심여부 변경 시
 *  @todo :
 *      - 클래스 아카이브 화
 *      - 필터값이 입력되면, 해당되는 게시물들만 반환
 *      - 설정을 통해 값 변경 시, Firebase에 반영
 */
class Board : NSObject, NSCoding{
    var name:String
    var groupid:String
    var url:String
    var interest:Bool
    var articles:[Article]
    
    init(name:String, groupid:String, url:String, interest:Bool)
    {
        self.name = name
        self.groupid = groupid
        self.url = url
        self.interest = interest
        self.articles = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.groupid = aDecoder.decodeObject(forKey:"groupid") as! String
        self.url = aDecoder.decodeObject(forKey:"url") as! String
        self.interest = aDecoder.decodeObject(forKey:"interest") as! Bool
        self.articles = aDecoder.decodeObject(forKey:"articles") as! [Article]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.groupid, forKey:"groupid")
        aCoder.encode(self.url, forKey:"url")
        aCoder.encode(self.interest, forKey:"interest")
        aCoder.encode(self.articles, forKey:"articles")
    }
    
    func addArticle(article:Article) -> Void
    {
        self.articles.append(article)
    }
    
    func deleteArticle(article:Article) -> Bool
    {
        if let idx = self.articles.index(where: {$0.title == article.title && $0.url == article.url && $0.date == article.date}) {
            self.articles.remove(at:idx)
            return true
        }
        
        return false
    }
}
