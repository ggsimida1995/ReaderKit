//
//  ReadModel.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class ReadModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    
    /// 小说名称
    var bookName:String!
    
    /// 小说来源类型
    var bookSourceType:BookSourceType! = .network
    
    /// 当前阅读记录
    var recordModel:ReadRecordModel!
    
    /// 书签列表
    var markModels:[ReadMarkModel]! = []
    
    /// 章节列表(如果是网络小说可以不需要放在这里记录,直接在目录视图里面加载接口或者读取本地数据库就好了。)
    /// 本地小说
    var chapterListModels:[ReadChapterListModel]! = []
    
    /// 本地小说章节总数或者网络小说总章节数
    var chapterCount: NSNumber!
    
    // MARK: 快速进入
    
    /// 本地小说全文
    var fullText:String!
    
    /// 章节内容范围数组 [章节ID:[章节优先级:章节内容Range]]
    var ranges:[String:[String:NSRange]]!
    
    
    // MARK: 辅助
    
    /// 保存
    func save() {
        
        recordModel.save()
        
        KeyedArchiver.archiver(folderName: bookID, fileName: DZM_READ_KEY_OBJECT, object: self)
    }
    
    /// 是否存在阅读对象
    class func isExist(bookID:String!) ->Bool {
        
        return KeyedArchiver.isExist(folderName: bookID, fileName: DZM_READ_KEY_OBJECT)
    }
    
    
    // MARK: 构造
    
    /// 获取阅读对象,如果则创建对象返回
    @objc class func model(bookID:String!) ->ReadModel {
        
        var readModel:ReadModel!
        
        if ReadModel.isExist(bookID: bookID) {
            
            readModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: DZM_READ_KEY_OBJECT) as? ReadModel
            
        }else{
            
            readModel = ReadModel()
            
            readModel.bookID = bookID
        }
        
        // 获取阅读记录
        readModel.recordModel = ReadRecordModel.model(bookID: bookID)
        
        return readModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        bookName = aDecoder.decodeObject(forKey: "bookName") as? String
        
        bookSourceType = BookSourceType(rawValue: (aDecoder.decodeObject(forKey: "bookSourceType") as! NSNumber).intValue)
        
        chapterListModels = aDecoder.decodeObject(forKey: "chapterListModels") as? [ReadChapterListModel]
        chapterCount = (aDecoder.decodeObject(forKey: "chapterCount") as! NSNumber)

        markModels = aDecoder.decodeObject(forKey: "markModels") as? [ReadMarkModel]
        
        fullText = aDecoder.decodeObject(forKey: "fullText") as? String
        
        ranges = aDecoder.decodeObject(forKey: "ranges") as? [String:[String:NSRange]]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(bookName, forKey: "bookName")
        
        aCoder.encode(NSNumber(value: bookSourceType.rawValue), forKey: "bookSourceType")
        
        aCoder.encode(chapterListModels, forKey: "chapterListModels")
        aCoder.encode(chapterCount, forKey: "chapterCount")
        
        aCoder.encode(markModels, forKey: "markModels")
        
        aCoder.encode(fullText, forKey: "fullText")
        
        aCoder.encode(ranges, forKey: "ranges")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
