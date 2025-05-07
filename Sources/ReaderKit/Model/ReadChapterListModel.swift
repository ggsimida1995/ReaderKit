//
//  ReadChapterListModel.swift
//  eBookRead
//
//  Created by ggsimida on 2025/5/6.
//  Copyright © 2025年 . All rights reserved.
//

import UIKit

class ReadChapterListModel: NSObject, NSCoding {
    
    /// 章节ID
    @objc var id: Int = 0

    /// 小说ID
    var bookID: String = ""
    
    /// 章节名称
    var name: String = ""
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
