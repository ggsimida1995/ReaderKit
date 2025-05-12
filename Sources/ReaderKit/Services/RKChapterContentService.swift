import Foundation

/// 章节内容服务协议
/// 定义获取章节内容的标准接口
public protocol ChapterContentService {
    /// 根据书籍ID和章节ID获取章节模型
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - chapterID: 章节ID
    /// - Returns: 章节模型，如果获取失败则返回nil
    func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel?
}

/// 默认的章节内容服务实现
/// 注意：这是一个空实现，实际使用时需要在第三方项目中实现自己的ChapterContentService
public class DefaultChapterContentService: ChapterContentService {
    public static let shared = DefaultChapterContentService()
    
    private init() {}
    
    public func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel? {
        // 这是一个空实现，实际使用时需要在调用项目中提供自己的实现
        print("警告：DefaultChapterContentService是一个空实现。您需要在您的项目中实现ChapterContentService协议并使用您的实现。")
        print("获取章节请求: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 返回nil，表示无法获取章节
        return nil
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
