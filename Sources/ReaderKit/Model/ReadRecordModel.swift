//
//  ReadRecordModel.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

/// 记录当前章节阅读到的坐标
var _READ_RECORD_CURRENT_CHAPTER_LOCATION: Int = 0

class ReadRecordModel: NSObject, NSCoding {

    /// 小说ID
    var bookID: String = ""
    
    /// 当前记录的阅读章节
    var chapterModel: ReadChapterModel!
    
    /// 阅读到的页码(上传阅读记录到服务器时传当前页面的 location 上去,从服务器拿回来 location 在转成页码。精准回到上次阅读位置)
    var page: Int = 0
    
    // MARK: 快捷获取
    
    /// 当前记录分页模型
    var pageModel: ReadPageModel { chapterModel.pageModels[page] }
    
    /// 当前记录起始坐标
    var locationFirst: Int { chapterModel.locationFirst(page: page) }
    
    /// 当前记录末尾坐标
    var locationLast: Int { chapterModel.locationLast(page: page) }
    
    /// 当前记录是否为第一个章节
    var isFirstChapter: Bool { chapterModel.isFirstChapter }
    
    /// 当前记录是否为最后一个章节
    var isLastChapter: Bool { chapterModel.isLastChapter }
    
    /// 当前记录是否为第一页
    var isFirstPage: Bool { page == 0 }
    
    /// 当前记录是否为最后一页
    var isLastPage: Bool { page == (chapterModel.pageCount - 1) }
    
    /// 当前记录页码字符串
    var contentString: String { chapterModel.contentString(page: page) }
    
    /// 当前记录页码富文本
    var contentAttributedString: NSAttributedString { chapterModel.contentAttributedString(page: page) }
    
    /// 当前记录切到上一页
    func previousPage() { page = max(page - 1, 0) }
    
    /// 当前记录切到下一页
    func nextPage() { page = min(page + 1, chapterModel.pageCount - 1) }
    
    /// 当前记录切到第一页
    func firstPage() { page = 0 }
    
    /// 当前记录切到最后一页
    func lastPage() { page = chapterModel.pageCount - 1 }
    
    // MARK: 辅助
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterModel: ReadChapterModel, page: Int, isSave: Bool = true) {
        self.chapterModel = chapterModel
        self.page = page
        if isSave { save() }
    }
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterID: Int, location: Int, isSave: Bool = true) {
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            chapterModel = ReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            page = chapterModel.page(location: location)
            if isSave { save() }
        }
    }
    
    /// 修改阅读记录为指定章节页码 (toPage == _READ_LAST_PAGE 为当前章节最后一页)
    func modify(chapterID: Int, toPage: Int, isSave: Bool = true) {
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            chapterModel = ReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            if toPage == DZM_READ_LAST_PAGE {
                lastPage()
            } else {
                page = toPage
            }
            if isSave { save() }
        }
    }
    
    /// 更新字体
    func updateFont(isSave: Bool = true) {
        if chapterModel != nil {
            chapterModel.updateFont()
            page = chapterModel.page(location: _READ_RECORD_CURRENT_CHAPTER_LOCATION)
            if isSave { save() }
        }
    }
    
    /// 拷贝阅读记录
    func copyModel() -> ReadRecordModel {
        let recordModel = ReadRecordModel()
        recordModel.bookID = bookID
        recordModel.chapterModel = chapterModel
        recordModel.page = page
        return recordModel
    }
    
    /// 保存记录
    func save() {
        KeyedArchiver.archiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD, object: self)
    }
    
    /// 是否存在阅读记录
    class func isExist(_ bookID: String) -> Bool {
        return KeyedArchiver.isExist(folderName: bookID, fileName: DZM_READ_KEY_RECORD)
    }
    
    // MARK: 构造
    
    /// 获取阅读记录对象,如果则创建对象返回
    @objc class func model(bookID: String) -> ReadRecordModel {
        var recordModel: ReadRecordModel!
        
        if ReadRecordModel.isExist(bookID) {
            recordModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD) as? ReadRecordModel
            recordModel.chapterModel.updateFont()
        } else {
            recordModel = ReadRecordModel()
            recordModel.bookID = bookID
        }
        
        return recordModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        chapterModel = aDecoder.decodeObject(forKey: "chapterModel") as? ReadChapterModel
        page = aDecoder.decodeInteger(forKey: "page")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(chapterModel, forKey: "chapterModel")
        aCoder.encode(page, forKey: "page")
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
