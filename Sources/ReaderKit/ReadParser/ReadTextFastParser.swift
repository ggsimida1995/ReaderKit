//
//  DZMReadTextFastParser.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/5/15.
//  Copyright © 2019 DZM. All rights reserved.
//

import UIKit

class ReadTextFastParser: NSObject {
    
    /// 异步解析本地链接
    ///
    /// - Parameters:
    ///   - url: 本地文件地址
    ///   - completion: 解析完成
    @objc class func parser(url: URL, completion: @escaping DZMParserCompletion) {
        DispatchQueue.global().async {
            let readModel = parser(url: url)
            DispatchQueue.main.async {
                completion(readModel)
            }
        }
    }
    
    /// 解析本地链接
    ///
    /// - Parameter url: 本地文件地址
    /// - Returns: 阅读对象
    private class func parser(url: URL) -> ReadModel? {
        // 链接不为空且是本地文件路径
        if url.absoluteString.isEmpty || !url.isFileURL { return nil }
        
        // 获取文件后缀名作为 bookName
        let bookName = url.absoluteString.removingPercentEncoding?.lastPathComponent.deletingPathExtension ?? ""
        
        // bookName 作为 bookID
        let bookID = bookName
        
        // bookID 为空
        if bookID.isEmpty { return nil }
        
        if !ReadModel.isExist(bookID: bookID) { // 不存在
            // 解析数据
            let content = ReadParser.encode(url: url)
            
            // 解析失败
            if content.isEmpty { return nil }
            
            // 阅读模型
            let readModel = ReadModel.model(bookID: bookID)
            
            // 书籍类型
            readModel.bookSourceType = .local
            
            // 小说名称
            readModel.bookName = bookName
            
            // 解析内容并获得章节列表
            parser(readModel: readModel, content: content)
            
            // 解析内容失败
            if readModel.chapterListModels.isEmpty { return nil }
            
            // 首章
            let chapterListModel = readModel.chapterListModels.first!
            
            // 加载首章
            _ = parser(readModel: readModel, chapterID: chapterListModel.id)
            
            // 设置第一个章节为阅读记录
            readModel.recordModel.modify(chapterID: chapterListModel.id, toPage: 0)
            
            // 保存
            readModel.save()
            
            return readModel
        } else { // 存在
            return ReadModel.model(bookID: bookID)
        }
    }
    
    /// 解析整本小说
    ///
    /// - Parameters:
    ///   - readModel: readModel
    ///   - content: 小说内容
    private class func parser(readModel: ReadModel, content: String) {
        // 章节列表
        var chapterListModels: [ReadChapterListModel] = []
        
        // 章节范围列表 [章节ID:[章节优先级:章节内容Range]]
        var ranges: [String: [String: NSRange]] = [:]
        
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        // 排版
        let content = ReadParser.contentTypesetting(content: content)
        
        // 正则匹配结果
        var results: [NSTextCheckingResult] = []
        
        // 开始匹配
        do {
            let regularExpression: NSRegularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            results = regularExpression.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.length))
        } catch {
            return
        }
        
        // 解析匹配结果
        if !results.isEmpty {
            // 章节数量
            let count = results.count
            
            // 记录最后一个Range
            var lastRange: NSRange!
            
            // 有前言
            var isHavePreface: Bool = true
            
            // 遍历
            for i in 0...count {
                // 章节数量分析:
                // count + 1  = 匹配到的章节数量 + 最后一个章节
                // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
                DZMLog("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
                
                var range = NSMakeRange(0, 0)
                var location = 0
                
                if i < count {
                    range = results[i].range
                    location = range.location
                }
                
                // 章节列表
                let chapterListModel = ReadChapterListModel()
                
                // 书ID
                chapterListModel.bookID = readModel.bookID
                
                // 章节ID
                chapterListModel.id = i + (isHavePreface ? 1 : 0)
                
                // 优先级
                let priority = i - (!isHavePreface ? 1 : 0)
                
                if i == 0 { // 前言
                    // 章节名
                    chapterListModel.name = "开始"
                    
                    // 内容Range
                    ranges[String(chapterListModel.id)] = [String(priority): NSMakeRange(0, location)]
                    
                    // 内容
                    let content = content.substring(NSMakeRange(0, location))
                    
                    // 记录
                    lastRange = range
                    
                    // 没有内容则不需要添加列表
                    if content.isEmpty {
                        isHavePreface = false
                        continue
                    }
                    
                } else if i == count { // 结尾
                    // 章节名
                    chapterListModel.name = content.substring(lastRange)
                    
                    // 内容Range
                    ranges[String(chapterListModel.id)] = [String(priority): NSMakeRange(lastRange.location + lastRange.length, content.length - lastRange.location - lastRange.length)]
                    
                } else { // 中间章节
                    // 章节名
                    chapterListModel.name = content.substring(lastRange)
                    
                    // 内容Range
                    ranges[String(chapterListModel.id)] = [String(priority): NSMakeRange(lastRange.location + lastRange.length, location - lastRange.location - lastRange.length)]
                }
                
                // 记录
                lastRange = range
                
                // 通过章节内容生成章节列表
                chapterListModels.append(chapterListModel)
            }
            
        } else {
            // 章节列表
            let chapterListModel = ReadChapterListModel()
            
            // 章节名
            chapterListModel.name = "开始"
            
            // 书ID
            chapterListModel.bookID = readModel.bookID
            
            // 章节ID
            chapterListModel.id = 1
            
            // 优先级
            let priority = 0
            
            // 内容Range
            ranges[String(chapterListModel.id)] = [String(priority): NSMakeRange(0, content.length)]
            
            // 添加章节列表模型
            chapterListModels.append(chapterListModel)
        }
        
        // 小说全文
        readModel.fullText = content
        
        // 章节列表
        readModel.chapterListModels = chapterListModels
        
        // 章节内容范围
        readModel.ranges = ranges
    }
    
    /// 获取单个指定章节
    class func parser(readModel: ReadModel, chapterID: Int, isUpdateFont: Bool = true) -> ReadChapterModel? {
        // 检查是否存在章节内容
        let isExist = ReadChapterModel.isExist(bookID: readModel.bookID, chapterID: chapterID)
        
        // 存在 || 不存在(但是为本地阅读)
        if isExist || readModel.bookSourceType == .local {
            // 获取章节数据
            if !isExist {
                // 章节还没从全文里面解析出来，需要解析出来使用
                let chapterModel = ReadChapterModel()
                
                // 书ID
                chapterModel.bookID = readModel.bookID
                
                // 章节ID
                chapterModel.id = chapterID
                
                // 章节名
                chapterModel.name = readModel.chapterListModels.first(where: { $0.id == chapterID })?.name ?? ""
                
                // 优先级
                chapterModel.priority = readModel.chapterListModels.first(where: { $0.id == chapterID })?.id ?? 0
                
                // 内容
                if let range = readModel.ranges[String(chapterID)]?.values.first {
                    chapterModel.content = readModel.fullText.substring(range)
                }
                
                // 设置上一个章节ID
                chapterModel.previousChapterID = readModel.chapterListModels.first(where: { $0.id == chapterID - 1 })?.id ?? 0
                
                // 设置下一个章节ID
                chapterModel.nextChapterID = readModel.chapterListModels.first(where: { $0.id == chapterID + 1 })?.id ?? 0
                
                // 保存
                chapterModel.save()
                
                // 更新字体
                if isUpdateFont { chapterModel.updateFont() }
                
                return chapterModel
            } else {
                // 本地存在章节，取出来使用
                return ReadChapterModel.model(bookID: readModel.bookID, chapterID: chapterID)
            }
        }
        
        return nil
    }
}
