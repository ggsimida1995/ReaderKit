import Foundation

/// 章节内容服务协议
/// 定义获取章节内容的标准接口
internal protocol ChapterContentService {
    /// 根据书籍ID和章节ID获取章节模型
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - chapterID: 章节ID
    /// - Returns: 章节模型，如果获取失败则返回nil
    func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel?
}

/// 默认的章节内容服务实现
internal class DefaultChapterContentService: ChapterContentService {
    internal static let shared = DefaultChapterContentService()
    
    private init() {}
    
    internal func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel? {
        // 1. 查询数据库获取章节内容（此处用Mock数据模拟，实际项目请替换为数据库查询）
        // 你可以将此处替换为 DatabaseManager.shared.getChapterSync(bkId: Int(bookID)!, index: chapterID)
        guard let mockBook = MockReaderData.shared.books[bookID], chapterID > 0, chapterID <= mockBook.chapters.count else {
            return nil
        }
        let chapterData = mockBook.chapters[chapterID - 1]

        // 2. 创建章节模型
        let chapterModel = RKReadChapterModel()
        chapterModel.bookID = bookID
        chapterModel.id = chapterID
        chapterModel.name = "第\(chapterID)章 " + chapterData.name

        // 3. 设置内容并排版
        let rawContent = chapterData.content
        if !rawContent.isEmpty {
            chapterModel.content = RKReadParser.contentTypesetting(content: rawContent)
            chapterModel.isContentEmpty = false
        } else {
            chapterModel.content = RKReadParser.contentTypesetting(content: "正在加载中。。。")
            chapterModel.isContentEmpty = true
        }

        // 4. 设置优先级
        chapterModel.priority = chapterID

        // 5. 设置上一章和下一章ID
        chapterModel.previousChapterID = chapterID > 1 ? chapterID - 1 : 0
        chapterModel.nextChapterID = chapterID < mockBook.chapters.count ? chapterID + 1 : -1

        // 6. 分页和字体刷新
        chapterModel.updateFont()

        // 7. 保存章节
        chapterModel.save()

        return chapterModel
    }
}

// MARK: - 扩展 ReadController 以使用新的服务
extension RKReadController {
    /// 使用新的服务获取章节内容
    @objc func fetchChapterContent(bookID: String, chapterID: Int) {
        print("请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 使用新的服务获取章节内容
        if let chapterModel = DefaultChapterContentService.shared.getChapter(bookID: bookID, chapterID: chapterID) {
            // 保存章节
            chapterModel.save()
        }
    }
}

// MARK: - 扩展 ReadViewScrollController 以使用新的服务
extension RKReadViewScrollController {
    /// 使用新的服务获取章节内容
    @objc func fetchChapterContent(bookID: String, chapterID: Int) -> RKReadChapterModel? {
        print("滚动控制器请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 使用新的服务获取章节内容
        return DefaultChapterContentService.shared.getChapter(bookID: bookID, chapterID: chapterID)
    }
} 
