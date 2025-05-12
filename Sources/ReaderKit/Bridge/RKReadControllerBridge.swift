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

/// DZMReadController 包装器
struct RKReadControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RKReadController
    
    // 可选参数：书籍ID
    var bookID: String
    
    init(bookID: String = "1001") {
        self.bookID = bookID
    }
    
    func makeUIViewController(context: Context) -> RKReadController {
        let vc = RKReadController()
        
        // 使用模拟数据创建阅读模型
        let readModel = MockReaderData.shared.createReadModel(bookID: bookID)
        
        // 设置阅读控制器的模型
        vc.readModel = readModel
        
        // 使用新的方法获取章节内容
        vc.fetchChapterContent(bookID: bookID, chapterID: 1)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: RKReadController, context: Context) {
        // 如果需要更新配置，可以在这里处理
    }
    
    // 添加析构方法，确保旧控制器被清理
    static func dismantleUIViewController(_ uiViewController: RKReadController, coordinator: ()) {
        uiViewController.view.removeFromSuperview()
        uiViewController.removeFromParent()
    }
}
#endif 
