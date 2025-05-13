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
    
    // 书籍模型
    var rkBook: RKBook
    
    /// 使用RKBook初始化
    /// - Parameter book: 书籍模型
    init(book: RKBook) {
        self.rkBook = book
        print("rkBook: \(rkBook.bkId) \(rkBook.bookName) \(rkBook.chapterCount) \(rkBook.position)")
        
        // 检查是否设置了ChapterProvider，如果没有，输出警告
        if DefaultChapterContentService.externalProvider == nil {
            print("警告: 在创建阅读器视图前必须设置ChapterProvider！请先调用ReaderKit.setChapterProvider(_:)")
        }
    }
    
    func makeUIViewController(context: Context) -> RKReadController {
        let vc = RKReadController()
        
        let bookID = String(rkBook.bkId)
        print("bookID: \(bookID)")
        let readModel = RKReadModel.model(bookID: bookID)
  
        readModel.bookName = rkBook.bookName
        readModel.chapterCount = rkBook.chapterCount
        // 记录章节列表
//        readModel.chapterListModels = readerManager.chapterListModels
        // controller.readModel.bookName = book.bookName
        let chapterID = rkBook.position
        // 检查是否当前将要阅读的章节是否等于阅读记录
        if chapterID != readModel.recordModel.chapterModel?.id {
            print("进来 1 不等于阅读记录")
            // 如果不一致则需要检查本地是否有没有,没有则下载,并修改阅读记录为该章节。
            
            // 检查马上要阅读章节是否本地存在
            if RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) { // 存在
                print("进来 1存在")
                // 如果存在则修改阅读记录
                readModel.recordModel.modify(chapterID: chapterID, location: 0)
                
                //                    let vc  = DZMReadController()
                
                vc.readModel = readModel
                
                
            }else{ // 如果不存在则需要加载网络数据
                
                print("进来 2不存在")

                vc.fetchChapterContent(bookID: bookID, chapterID: Int(chapterID))
                // 如果存在则修改阅读记录
                readModel.recordModel.modify(chapterID: chapterID, location: 0)
                
                //                    let vc  = DZMReadController()
                
                vc.readModel = readModel
                
            }
        }else{
            print("进来 2 等于阅读记录")
            //  readModel.recordModel.modify(chapterID: chapterID, location: 0)
            
            vc.readModel = readModel
        }
        return vc
        
        
    }
    
    func updateUIViewController(_ uiViewController: RKReadController, context: Context) {
        // 当readModel发生变化时更新控制器
    }
    
    // 添加析构方法，确保旧控制器被清理
    static func dismantleUIViewController(_ uiViewController: RKReadController, coordinator: ()) {
        uiViewController.view.removeFromSuperview()
        uiViewController.removeFromParent()
    }
}
#endif
