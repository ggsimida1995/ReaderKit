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
    
    /// 初始化ReaderKit
    public static func initialize() {
        // 初始化代码...
        print("ReaderKit \(version) 已初始化")
    }
    
    /// 获取主阅读器视图
    /// - Returns: 返回配置好的阅读器视图
    public static func readerView() -> some View {
        ReaderMainView()
    }
    
}

/// 阅读器公共配置
public struct ReaderConfig {
    /// 单例实例
    public static let shared = ReaderConfig()
    
    /// 私有初始化方法，防止外部创建实例
    private init() {}
    
}

/// 章节内容模型
public struct ChapterContent: Codable {
    /// 章节ID
    public let id: Int
    /// 章节内容
    public let content: String
    
    /// 初始化
    public init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
} 
