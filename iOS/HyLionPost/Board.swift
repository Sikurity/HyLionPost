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
    var name:String                 // 게시판 이름
    var groupid:String              // 게시판 ID
    var url:String                  // 게시판 링크
    var favorite:Bool               // 게시판 구독여부
    var filtered:Bool               // 게시판 필터여부
    var articles:[String:Article]   // 게시판 내 게시글들
    var count:Int                   // 보관 게시글 개수
    var format:String               // 게시판 날짜 형식
    
    init(name:String, groupid:String, url:String, favorite:Bool, format:String)
    {
        self.name = name
        self.groupid = groupid
        self.url = url
        self.favorite = favorite
        self.filtered = false
        self.articles = [:]
        self.count = -1
        self.format = format
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.groupid = aDecoder.decodeObject(forKey:"groupid") as! String
        self.url = aDecoder.decodeObject(forKey:"url") as! String
        self.favorite = aDecoder.decodeBool(forKey: "favorite") as Bool
        self.filtered = aDecoder.decodeBool(forKey:"filtered") as Bool
        self.articles = aDecoder.decodeObject(forKey:"articles") as! [String:Article]
        self.count = aDecoder.decodeInteger(forKey: "count") as Int
        self.format = aDecoder.decodeObject(forKey: "format") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.groupid, forKey:"groupid")
        aCoder.encode(self.url, forKey:"url")
        aCoder.encode(self.favorite, forKey:"favorite")
        aCoder.encode(self.filtered, forKey:"filtered")
        aCoder.encode(self.articles, forKey:"articles")
        aCoder.encode(self.count, forKey:"count")
        aCoder.encode(self.format, forKey:"format")
    }
}
