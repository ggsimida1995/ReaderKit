import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// ReaderKit - 一个现代化的Swift电子书阅读器框架
///
/// 主要功能:
/// - 支持翻页阅读
/// - 主题定制
/// - 布局管理
/// - 阅读状态追踪
struct ReaderKit {
    /// 库的版本号
    static let version = "1.0.0"
    
    /// ReaderKit配置选项
    struct Configuration {
        /// 是否显示调试日志
        var isDebugMode: Bool
        /// 默认字体大小
        var defaultFontSize: CGFloat
        /// 默认主题
        var defaultTheme: ReaderTheme
        
        init(
            isDebugMode: Bool = false,
            defaultFontSize: CGFloat = 16,
            defaultTheme: ReaderTheme = .light
        ) {
            self.isDebugMode = isDebugMode
            self.defaultFontSize = defaultFontSize
            self.defaultTheme = defaultTheme
        }
    }
    
    /// 初始化ReaderKit
    /// - Parameter configuration: ReaderKit配置选项
    static func initialize(with configuration: Configuration = Configuration()) {
        ReaderConfig.shared.configure(with: configuration)
        if configuration.isDebugMode {
            print("ReaderKit \(version) 已初始化")
        }
    }
    
    /// 获取阅读器视图（使用自定义的阅读模型）
    /// - Parameter readModel: 自定义的阅读模型
    /// - Returns: 返回配置好的阅读器视图
    static func readerView(with readModel: RKReadModel) -> some View {
        RKReadControllerRepresentable(bookID: readModel.bookID, readModel: readModel)
    }
    
    /// 创建一个基本的阅读模型框架（第三方需要自行完善其内容）
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - bookName: 书籍名称
    ///   - chapterListModels: 章节列表模型数组
    /// - Returns: 返回基础的RKReadModel
    static func createReadModel(
        bookID: String,
        bookName: String,
        chapterListModels: [RKReadChapterListModel]
    ) -> RKReadModel {
        let readModel = RKReadModel()
        readModel.bookID = bookID
        readModel.bookName = bookName
        readModel.bookSourceType = .network
        readModel.chapterListModels = chapterListModels
        readModel.chapterCount = chapterListModels.count
        
        // 创建阅读记录
        let recordModel = RKReadRecordModel()
        recordModel.bookID = bookID
        
        // 注意：这里不再调用DefaultChapterContentService
        // 第三方使用时需要设置recordModel.chapterModel
        
        readModel.recordModel = recordModel
        
        return readModel
    }
}

/// 阅读器主题
enum ReaderTheme {
    case light
    case dark
    case sepia
}

/// 阅读器公共配置
class ReaderConfig {
    /// 单例实例
    static let shared = ReaderConfig()
    
    /// 是否显示书籍选择器
    var showBookSelector: Bool = true
    
    /// 当前配置
    private var configuration: ReaderKit.Configuration = .init()
    
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
    /// 配置ReaderKit
    /// - Parameter configuration: 配置选项
    internal func configure(with configuration: ReaderKit.Configuration) {
        self.configuration = configuration
    }
    
    /// 获取当前字体大小
    var fontSize: CGFloat {
        configuration.defaultFontSize
    }
    
    /// 获取当前主题
    var theme: ReaderTheme {
        configuration.defaultTheme
    }
}

/// 章节内容模型
struct ChapterContent: Codable {
    /// 章节ID
    let id: Int
    /// 章节标题
    let name: String
    /// 章节内容
    let content: String
    
    /// 初始化
    init(id: Int, name: String, content: String) {
        self.id = id
        self.name = name
        self.content = content
    }
} 
