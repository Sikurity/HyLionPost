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
    var favorite:Bool
    var filtered:Bool
    var articles:[String:Article]
    var count:Int
    
    init(name:String, groupid:String, url:String, favorite:Bool)
    {
        self.name = name
        self.groupid = groupid
        self.url = url
        self.favorite = favorite
        self.filtered = false
        self.articles = [:]
        self.count = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.groupid = aDecoder.decodeObject(forKey:"groupid") as! String
        self.url = aDecoder.decodeObject(forKey:"url") as! String
        self.favorite = aDecoder.decodeBool(forKey: "favorite") as Bool
        self.filtered = aDecoder.decodeBool(forKey:"filtered") as Bool
        self.articles = aDecoder.decodeObject(forKey:"articles") as! [String:Article]
        self.count = aDecoder.decodeInteger(forKey: "count") as Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.groupid, forKey:"groupid")
        aCoder.encode(self.url, forKey:"url")
        aCoder.encode(self.favorite, forKey:"favorite")
        aCoder.encode(self.filtered, forKey:"filtered")
        aCoder.encode(self.articles, forKey:"articles")
        aCoder.encode(self.count, forKey:"count")
    }
}
