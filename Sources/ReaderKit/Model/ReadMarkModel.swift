//
//  ReadMarkModel.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class ReadMarkModel: NSObject, NSCoding {

    /// 小说ID
    var bookID: String = ""
    
    /// 章节ID
    var chapterID: Int = 0
    
    /// 章节名称
    var name: String = ""
    
    /// 内容
    var content: String = ""
    
    /// 时间戳
    var time: TimeInterval = 0
    
    /// 位置
    var location: Int = 0
    
    // MARK: -- 构造
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        chapterID = aDecoder.decodeInteger(forKey: "chapterID")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        content = aDecoder.decodeObject(forKey: "content") as? String ?? ""
        time = aDecoder.decodeDouble(forKey: "time")
        location = aDecoder.decodeInteger(forKey: "location")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(chapterID, forKey: "chapterID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(location, forKey: "location")
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
