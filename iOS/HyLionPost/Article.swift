//
//  Article.swift
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
 */
class Article : NSObject, NSCoding {
    var title:String    // 게시물 제목
    var groupid:String  // 소속 게시판
    var key:String      // 게시글 키값
    var url:String      // 게시물 링크
    var date:String     // 게시된 날짜
    var archived:Bool   // 글보관 여부
    var unopened:Bool   // 읽음/읽지않음
    
    init(title:String, groupid:String, key:String, url:String, date:String, archived:Bool){
        self.title = title
        self.groupid = groupid
        self.key = key
        self.url = url
        self.date = date
        self.archived = archived
        self.unopened = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey:"title") as! String
        self.groupid = aDecoder.decodeObject(forKey:"groupid") as! String
        self.key = aDecoder.decodeObject(forKey:"key") as! String
        self.url = aDecoder.decodeObject(forKey:"url") as! String
        self.date = aDecoder.decodeObject(forKey:"date") as! String
        self.archived = aDecoder.decodeBool(forKey: "archived") as Bool
        self.unopened = aDecoder.decodeBool(forKey:"unopened") as Bool
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey:"title")
        aCoder.encode(self.groupid, forKey:"groupid")
        aCoder.encode(self.key, forKey:"key")
        aCoder.encode(self.url, forKey:"url")
        aCoder.encode(self.date, forKey:"date")
        aCoder.encode(self.archived, forKey:"archived")
        aCoder.encode(self.unopened, forKey:"unopened")
    }
}
