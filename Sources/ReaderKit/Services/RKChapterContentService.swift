import Foundation

/// 章节内容服务协议
/// 定义获取章节内容的标准接口
protocol ChapterContentService {
    /// 根据书籍ID和章节ID获取章节模型
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - chapterID: 章节ID
    /// - Returns: 章节模型，如果获取失败则返回nil
    func getChapter(bookID: String, chapterID: Int) -> DZMReadChapterModel?
}

/// 公共章节提供者协议
/// 此协议用于外部项目实现，提供章节内容
public protocol ChapterProvider {
    /// 根据书籍ID和章节ID获取章节内容
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - chapterID: 章节ID
    /// - Returns: 章节内容，包含ID、标题和正文
    func getChapterContent(bookID: String, chapterID: Int) -> ChapterContent?
}

/// 默认的章节内容服务实现
/// 注意：这是一个空实现，实际使用时需要在第三方项目中实现自己的ChapterContentService
class DefaultChapterContentService: ChapterContentService {
    static let shared = DefaultChapterContentService()
    
    /// 外部提供的章节内容提供者
    public static var externalProvider: ChapterProvider?
    
    private init() {}
    
     func getChapter(bookID: String, chapterID: Int) -> DZMReadChapterModel? {
        // 如果有外部提供者，使用外部提供者获取内容
        if let provider = DefaultChapterContentService.externalProvider,
           let content = provider.getChapterContent(bookID: bookID, chapterID: chapterID) {
            // 创建章节模型
            let chapterModel = DZMReadChapterModel()
            
            let chapterID = NSNumber(value: chapterID)
            // 设置基本信息
            chapterModel.bookID = bookID
            chapterModel.id = chapterID
            chapterModel.name = content.chapterName ?? ""
            
            // 章节内容排版处理
            if content.contents.count > 0 {
                // 章节类容需要进行排版一篇
                chapterModel.content = DZMReadParser.contentTypesetting(content: content.contents.joined(separator: "\n"))
            } else {
                chapterModel.isContentEmpty = true
                chapterModel.content = DZMReadParser.contentTypesetting(content: "正在加载中。。。")
            }
            // 优先级
            chapterModel.priority = chapterModel.id
            
            // 设置上下章节关系（默认值，可能需要外部提供者补充更多信息）
            if chapterID == 0 {
                chapterModel.previousChapterID = DZM_READ_NO_MORE_CHAPTER
            } else {
                chapterModel.previousChapterID = NSNumber(value: chapterID as! Int - 1)
            }
            let chapterCount =  content.chapterCount - 1
            
            if chapterID == NSNumber(value: chapterCount) {
                chapterModel.nextChapterID = DZM_READ_NO_MORE_CHAPTER
            } else {
                chapterModel.nextChapterID = NSNumber(value: chapterID as! Int + 1)
            }
            // 更新字体和分页
            chapterModel.updateFont()
            
            chapterModel.save()

            return chapterModel
        }
        
        // 无外部提供者或获取失败
        print("警告：DefaultChapterContentService无法获取章节内容。请设置externalProvider")
        print("获取章节请求: bookID=\(bookID), chapterID=\(chapterID)")
        
        return nil
    }
}

// MARK: - 扩展 ReadController 以使用新的服务
extension DZMReadController {
    /// 使用新的服务获取章节内容
    @objc func fetchChapterContent(bookID: String, chapterID: Int) {
        print("请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 使用新的服务获取章节内容
        if let chapterModel = DefaultChapterContentService.shared.getChapter(bookID: bookID, chapterID: chapterID) {
            // 保存章节
            // chapterModel.save()
        }
    }
}

// MARK: - 扩展 ReadViewScrollController 以使用新的服务
extension DZMReadViewScrollController {
    /// 使用新的服务获取章节内容
    @objc func fetchChapterContent(bookID: String, chapterID: Int) -> DZMReadChapterModel? {
        print("滚动控制器请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 使用新的服务获取章节内容
        return DefaultChapterContentService.shared.getChapter(bookID: bookID, chapterID: chapterID)
    }
} 
