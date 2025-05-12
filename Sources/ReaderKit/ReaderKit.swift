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
public struct ReaderKit {
    /// 库的版本号
    public static let version = "1.0.0"
    
    /// ReaderKit配置选项
    public struct Configuration {
        /// 是否显示调试日志
        public var isDebugMode: Bool
        /// 默认字体大小
        public var defaultFontSize: CGFloat
        /// 默认主题
        public var defaultTheme: ReaderTheme
        
        public init(
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
    public static func initialize(with configuration: Configuration = Configuration()) {
        ReaderConfig.shared.configure(with: configuration)
        if configuration.isDebugMode {
            print("ReaderKit \(version) 已初始化")
        }
    }
    
    /// 设置章节内容提供者
    /// - Parameter provider: 实现了ChapterProvider协议的对象
    public static func setChapterProvider(_ provider: ChapterProvider) {
        DefaultChapterContentService.externalProvider = provider
    }
    
    /// 获取阅读器视图
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - bookName: 书籍名称
    ///   - chapterCount: 章节总数
    /// - Returns: 返回配置好的阅读器视图
    public static func readerView(
        bookID: String,
        bookName: String,
        chapterCount: Int
    ) -> some View {
        // 直接使用RKReadControllerRepresentable的新初始化方法
        return RKReadControllerRepresentable(bookID: bookID, bookName: bookName, chapterCount: chapterCount)
    }
}

/// 阅读器主题
public enum ReaderTheme {
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
public struct ChapterContent: Codable {
    public var id: Int
    public var index: Int
    public var siteIdent: String
    public var chapterName: String?
    public var url: String?
    public var contents: [String]
    public var playUrl: String
    public var type: Int
    public let chapterCount: Int
    /// 初始化
    public init(id: Int, index: Int, siteIdent: String, chapterName: String?, url: String?, contents: [String], playUrl: String, type: Int, chapterCount: Int) {
        self.id = id
        self.index = index
        self.siteIdent = siteIdent
        self.chapterName = chapterName
        self.url = url
        self.contents = contents
        self.playUrl = playUrl
        self.type = type
        self.chapterCount = chapterCount
    }
} 
