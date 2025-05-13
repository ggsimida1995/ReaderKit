import SwiftUI

/// 阅读器视图，用于SwiftUI中展示小说阅读器
public struct RKReaderView: View {
    // 书籍模型
    private let book: RKBook
    
    /// 初始化方法
    /// - Parameter book: 书籍模型
    public init(book: RKBook) {
        self.book = book
    }
    
    public var body: some View {
        RKReadControllerRepresentable(book: book)
            .edgesIgnoringSafeArea(.all)
    }
} 