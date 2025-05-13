//
//  DZMReadRecordModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 记录当前章节阅读到的坐标
var RK_READ_RECORD_CURRENT_CHAPTER_LOCATION: Int = 0

class RKReadRecordModel: NSObject, NSCoding {

    /// 小说ID
    var bookID: String = ""
    
    /// 当前记录的阅读章节
    var chapterModel: RKReadChapterModel?
    
    /// 阅读到的页码(上传阅读记录到服务器时传当前页面的 location 上去,从服务器拿回来 location 在转成页码。精准回到上次阅读位置)
    var page: Int = 0
    
    
    // MARK: 快捷获取
    
    /// 当前记录分页模型
    var pageModel: RKReadPageModel? { 
        guard let chapterModel = chapterModel else { return nil }
        return chapterModel.pageModels[page] 
    }
    
    /// 当前记录起始坐标
    var locationFirst: Int? { 
        return chapterModel?.locationFirst(page: page) 
    }
    
    /// 当前记录末尾坐标
    var locationLast: Int? { 
        return chapterModel?.locationLast(page: page) 
    }
    
    /// 当前记录是否为第一个章节
    var isFirstChapter: Bool { 
        return chapterModel?.isFirstChapter ?? false 
    }
    
    /// 当前记录是否为最后一个章节
    var isLastChapter: Bool { 
        return chapterModel?.isLastChapter ?? false 
    }
    
    /// 当前记录是否为第一页
    var isFirstPage: Bool { 
        return page == 0 
    }
    
    /// 当前记录是否为最后一页
    var isLastPage: Bool { 
        return page == (chapterModel?.pageCount ?? 1) - 1 
    }
    
    /// 当前记录页码字符串
    var contentString: String? { 
        return chapterModel?.contentString(page: page) 
    }
    
    /// 当前记录页码富文本
    var contentAttributedString: NSAttributedString? { 
        return chapterModel?.contentAttributedString(page: page) 
    }
    
    /// 当前记录切到上一页
    func previousPage() { 
        page = max(page - 1, 0) 
    }
    
    /// 当前记录切到下一页
    func nextPage() { 
        if let pageCount = chapterModel?.pageCount {
            page = min(page + 1, pageCount - 1)
        }
    }
    
    /// 当前记录切到第一页
    func firstPage() { 
        page = 0 
    }
    
    /// 当前记录切到最后一页
    func lastPage() { 
        if let pageCount = chapterModel?.pageCount {
            page = pageCount - 1
        }
    }
    
    
    // MARK: 辅助
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterModel: RKReadChapterModel, page: Int, isSave: Bool = true) {
        self.chapterModel = chapterModel
        self.page = page
        
        if isSave { save() }
    }
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterID: Int, location: Int, isSave: Bool = true) {
        guard !bookID.isEmpty else { return }
        
        if RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            chapterModel = RKReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            
            if let chapterModel = chapterModel {
                page = chapterModel.page(location: location)
            }
            
            if isSave { save() }
        }
    }
    
    /// 修改阅读记录为指定章节页码 (toPage == DZM_READ_LAST_PAGE 为当前章节最后一页)
    func modify(chapterID: Int, toPage: Int, isSave: Bool = true) {
        guard !bookID.isEmpty else { return }
        
        if RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            chapterModel = RKReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            
            if (toPage == DZM_READ_LAST_PAGE) { 
                lastPage()
            } else { 
                page = toPage 
            }
            
            if isSave { save() }
        }
    }
    
    /// 更新字体
    func updateFont(isSave: Bool = true) {
        if let chapterModel = chapterModel {
            chapterModel.updateFont()
            page = chapterModel.page(location: RK_READ_RECORD_CURRENT_CHAPTER_LOCATION)
            
            if isSave { save() }
        }
    }
    
    /// 拷贝阅读记录
    func copyModel() -> RKReadRecordModel {
        let recordModel = RKReadRecordModel()
        recordModel.bookID = bookID
        recordModel.chapterModel = chapterModel
        recordModel.page = page
        
        return recordModel
    }
    
    /// 保存记录
    func save() {
        guard !bookID.isEmpty else { return }
        RKKeyedArchiver.archiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD, object: self)
    }
    
    /// 是否存在阅读记录
    class func isExist(_ bookID: String) -> Bool {
        guard !bookID.isEmpty else { return false }
        return RKKeyedArchiver.isExist(folderName: bookID, fileName: DZM_READ_KEY_RECORD)
    }
    
    
    // MARK: 构造
    
    /// 获取阅读记录对象,如果则创建对象返回
    @objc class func model(bookID: String) -> RKReadRecordModel {
        guard !bookID.isEmpty else { return RKReadRecordModel() }
        
        var recordModel: RKReadRecordModel
        
        if RKReadRecordModel.isExist(bookID) {
            if let model = RKKeyedArchiver.unarchiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD) as? RKReadRecordModel {
                recordModel = model
                recordModel.chapterModel?.updateFont()
            } else {
                recordModel = RKReadRecordModel()
                recordModel.bookID = bookID
            }
        } else {
            recordModel = RKReadRecordModel()
            recordModel.bookID = bookID
        }
        
        return recordModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let bookID = aDecoder.decodeObject(forKey: "bookID") as? String {
            self.bookID = bookID
        }
        
        chapterModel = aDecoder.decodeObject(forKey: "chapterModel") as? RKReadChapterModel
        
        if let pageNumber = aDecoder.decodeObject(forKey: "page") as? NSNumber {
            page = pageNumber.intValue
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(chapterModel, forKey: "chapterModel")
        aCoder.encode(NSNumber(value: page), forKey: "page")
    }
    
    override init() {
        super.init()
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
