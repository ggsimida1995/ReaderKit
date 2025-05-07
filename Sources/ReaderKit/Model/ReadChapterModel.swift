//
//  ReadChapterModel.swift
//
//  Created by ggsimida on 2025/5/6.
//  Copyright © 2025年 . All rights reserved.
//

import UIKit

class ReadChapterModel: NSObject, NSCoding {
    
    /// 小说ID
    var bookID: String = ""
    
    /// 章节ID
    var id: Int = 0
    
    /// 上一章ID
    var previousChapterID: Int = 0
    
    /// 下一章ID
    var nextChapterID: Int = 0
    
    /// 章节名称
    var name: String = ""
    
    /// 当前章节是否为空
    var isContentEmpty: Bool = false
    
    /// 内容
    /// 此处 content 是经过排版好且双空格开头的内容。
    /// 如果是网络数据需要确认是否处理好了,也就是在网络章节数据拿到之后, 使用排版接口进行排版并在开头加上双空格。(例如: _READ_PH_SPACE + 排版好的content )
    /// 排版内容搜索 contentTypesetting 方法
    var content: String = ""
    
    /// 优先级 (一般章节段落都带有排序的优先级 从0开始)
    var priority: Int = 0
    
    /// 本章有多少页
    var pageCount: Int = 0
    
    /// 分页数据
    var pageModels: [ReadPageModel] = []
    
    // MARK: 快捷获取
    
    /// 当前章节是否为第一个章节
    var isFirstChapter: Bool { previousChapterID == 0 }
    
    /// 当前章节是否为最后一个章节
    var isLastChapter: Bool { nextChapterID == 0 }
    
    /// 完整章节名称
    var fullName: String { "\n\(name)\n\n" }
    
    /// 完整富文本内容
    var fullContent: NSAttributedString!
    
    /// 分页总高 (上下滚动模式使用)
    var pageTotalHeight: CGFloat {
        pageModels.reduce(0) { $0 + ($1.contentSize.height + $1.headTypeHeight) }
    }
    
    // MARK: -- 更新字体
    
    /// 内容属性变化记录(我这里就只判断内容了字体属性变化了，标题也就跟着变化或者保存变化都无所谓了。如果有需求可以在加上比较标题属性变化)
    private var attributes: [NSAttributedString.Key: Any] = [:]
    
    /// 更新字体
    func updateFont() {
        let tempAttributes = ReaderLayoutManager.shared.attributes(isTitle: false, isPaging: true)
        
        if !NSDictionary(dictionary: attributes).isEqual(to: tempAttributes) {
            attributes = tempAttributes
            fullContent = fullContentAttrString()
            pageModels = ReadParser.pageing(attrString: fullContent, rect: CGRect(origin: .zero, size: DZM_READ_VIEW_RECT.size), isFirstChapter: isFirstChapter, isContentEmpty: isContentEmpty)
            pageCount = pageModels.count
            save()
        }
    }
    
    /// 完整内容排版
    private func fullContentAttrString() -> NSMutableAttributedString {
        let titleString = NSMutableAttributedString(string: fullName, attributes: ReaderLayoutManager.shared.attributes(isTitle: true))
        let contentString = NSMutableAttributedString(string: content, attributes: ReaderLayoutManager.shared.attributes(isTitle: false))
        titleString.append(contentString)
        return titleString
    }
    
    // MARK: 辅助功能
    
    /// 获取指定页码字符串
    func contentString(page: Int) -> String {
        return pageModels[page].content.string
    }

    /// 获取指定页码富文本
    func contentAttributedString(page: Int) -> NSAttributedString {
        return pageModels[page].showContent
    }
    
    /// 获取指定页开始坐标
    func locationFirst(page: Int) -> Int {
        return pageModels[page].range.location
    }
    
    /// 获取指定页码末尾坐标
    func locationLast(page: Int) -> Int {
        let range = pageModels[page].range
        return range.location + range.length
    }
    
    /// 获取指定页中间
    func locationCenter(page: Int) -> Int {
        let range = pageModels[page].range
        return (range.location + (range.location + range.length) / 2)
    }
    
    /// 获取存在指定坐标的页码
    func page(location: Int) -> Int {
        for (index, pageModel) in pageModels.enumerated() {
            let range = pageModel.range
            if location < (range.location + range.length) {
                return index
            }
        }
        return 0
    }
    
    /// 保存
    func save() {
        KeyedArchiver.archiver(folderName: bookID, fileName: id.description, object: self)
    }
    
    /// 是否存在章节内容
    class func isExist(bookID: String, chapterID: Int) -> Bool {
        return KeyedArchiver.isExist(folderName: bookID, fileName: chapterID.description)
    }
    
    // MARK: 构造
    
    /// 获取章节对象,如果则创建对象返回
    @objc class func model(bookID: String, chapterID: Int, isUpdateFont: Bool = true) -> ReadChapterModel {
        var chapterModel: ReadChapterModel!
        
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            chapterModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: chapterID.description) as? ReadChapterModel
            if isUpdateFont { chapterModel?.updateFont() }
        } else {
            chapterModel = ReadChapterModel()
            chapterModel.bookID = bookID
            chapterModel.id = chapterID
        }
        
        return chapterModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        id = aDecoder.decodeInteger(forKey: "id")
        previousChapterID = aDecoder.decodeInteger(forKey: "previousChapterID")
        nextChapterID = aDecoder.decodeInteger(forKey: "nextChapterID")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        priority = aDecoder.decodeInteger(forKey: "priority")
        content = aDecoder.decodeObject(forKey: "content") as? String ?? ""
        fullContent = aDecoder.decodeObject(forKey: "fullContent") as? NSAttributedString
        pageCount = aDecoder.decodeInteger(forKey: "pageCount")
        pageModels = aDecoder.decodeObject(forKey: "pageModels") as? [ReadPageModel] ?? []
        attributes = aDecoder.decodeObject(forKey: "attributes") as? [NSAttributedString.Key: Any] ?? [:]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(previousChapterID, forKey: "previousChapterID")
        aCoder.encode(nextChapterID, forKey: "nextChapterID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(priority, forKey: "priority")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(fullContent, forKey: "fullContent")
        aCoder.encode(pageCount, forKey: "pageCount")
        aCoder.encode(pageModels, forKey: "pageModels")
        aCoder.encode(attributes, forKey: "attributes")
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
