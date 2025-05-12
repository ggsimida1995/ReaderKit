import SwiftUI
#if canImport(UIKit)
import UIKit

/// 翻页控制器协议
protocol PageTurnController: UIViewController {
    // MARK: - Properties
   
    // MARK: - Initialization
    init()
}

/// SwiftUI 包装器
struct PageTurnControllerRepresentable<Controller: PageTurnController>: UIViewControllerRepresentable {
    typealias UIViewControllerType = Controller
    
    func makeUIViewController(context: Context) -> Controller {
        let controller = Controller()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: Controller, context: Context) {
        // 如果需要更新配置，可以在这里处理
    }
    
    // 添加析构方法，确保旧控制器被清理
    static func dismantleUIViewController(_ uiViewController: Controller, coordinator: ()) {
        uiViewController.view.removeFromSuperview()
        uiViewController.removeFromParent()
    }
}

/// RKReadController 包装器
 struct RKReadControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RKReadController
    
    // 书籍ID
    var bookID: String
    
    // 阅读模型，必须提供
    var readModel: RKReadModel
    
    /// 初始化方法
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - readModel: 阅读模型（必须提供）
    public init(bookID: String, readModel: RKReadModel) {
        self.bookID = bookID
        self.readModel = readModel
    }
    
    public func makeUIViewController(context: Context) -> RKReadController {
        let vc = RKReadController()
        
        // 设置阅读控制器的模型
        vc.readModel = readModel
        
        // 使用新的方法获取章节内容
        vc.fetchChapterContent(bookID: bookID, chapterID: 1)
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: RKReadController, context: Context) {
        // 当readModel发生变化时更新控制器
        if readModel.bookID != uiViewController.readModel.bookID {
            uiViewController.readModel = readModel
            uiViewController.fetchChapterContent(bookID: readModel.bookID, chapterID: 1)
        }
    }
    
    // 添加析构方法，确保旧控制器被清理
    public static func dismantleUIViewController(_ uiViewController: RKReadController, coordinator: ()) {
        uiViewController.view.removeFromSuperview()
        uiViewController.removeFromParent()
    }
}
#endif 
