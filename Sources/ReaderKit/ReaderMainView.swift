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

/// 阅读内容服务协议 - 提供获取章节内容的方法
protocol ReaderContentService {
    /// 根据书籍ID和章节ID获取章节模型
    func getChapter(bookID: String, chapterID: Int) -> ReadChapterModel?
}

/// 模拟数据工具类 - 参照DZMReadModel结构创建
class MockReaderData: ReaderContentService {
    static let shared = MockReaderData()
    
    // 保存已创建的章节模型的缓存
    private var chapterCache: [String: ReadChapterModel] = [:]
    
    // 生成模拟的DZMReadModel
    func createReadModel(bookID: String = "1001") -> ReadModel {
        // 创建阅读模型
        let readModel = ReadModel()
        readModel.bookID = bookID
        readModel.bookName = "山海经"
        readModel.bookSourceType = .network
        readModel.chapterCount = 10
        
        // 创建章节列表
        var chapterListModels: [ReadChapterListModel] = []
        for i in 1...10 {
            let chapterModel = ReadChapterListModel()
            chapterModel.id = i
            chapterModel.name = "第\(i)章 " + getChapterName(for: i)
            chapterListModels.append(chapterModel)
        }
        readModel.chapterListModels = chapterListModels
        
        // 创建书签列表
        readModel.markModels = []
        
        // 创建阅读记录
        let recordModel = ReadRecordModel()
        recordModel.bookID = bookID
        
        // 创建当前章节并设置内容
        let currentChapterID = 1 // 从第一章开始
        let chapterModel = createChapterModel(bookID: bookID, chapterID: currentChapterID)
        
        // 设置记录模型
        recordModel.chapterModel = chapterModel
        recordModel.page = 0 // 从第0页开始
        
        readModel.recordModel = recordModel
        
        return readModel
    }
    
    // 创建章节模型
    func createChapterModel(bookID: String, chapterID: Int) -> ReadChapterModel {
        // 检查缓存中是否已存在该章节
        let cacheKey = "\(bookID)_\(chapterID)"
        if let cachedChapter = chapterCache[cacheKey] {
            return cachedChapter
        }
        
        let chapterModel = ReadChapterModel()
        chapterModel.bookID = bookID
        chapterModel.id = chapterID
        
        chapterModel.name = "第\(chapterID)章 " + getChapterName(for: chapterID)
        
        // 设置上一章和下一章
        chapterModel.previousChapterID = chapterID > 1 ? chapterID - 1 : 0
        chapterModel.nextChapterID = chapterID < 10 ? chapterID + 1 : 0
        
        // 获取章节内容
        chapterModel.content = getChapterContent(for: chapterID)
        chapterModel.isContentEmpty = chapterModel.content.isEmpty
        
        // 更新字体和分页
        chapterModel.updateFont()
        
        // 缓存章节
        chapterCache[cacheKey] = chapterModel
        
        return chapterModel
    }
    
    // MARK: - ReaderContentService Protocol
    
    /// 根据书籍ID和章节ID获取章节模型
    func getChapter(bookID: String, chapterID: Int) -> ReadChapterModel? {
        // 检查章节ID是否有效
        if chapterID < 1 || chapterID > 10 {
            return nil
        }
        
        // 创建并返回章节模型
        return createChapterModel(bookID: bookID, chapterID: chapterID)
    }
    
    // 获取章节名称
    private func getChapterName(for id: Int) -> String {
        let names = [
            "开始",
            "冒险开始",
            "矛盾显现",
            "挑战",
            "高潮",
            "转折",
            "新阶段",
            "最终挑战",
            "即将结束",
            "结局"
        ]
        
        if id >= 1 && id <= names.count {
            return names[id - 1]
        }
        return "未知章节"
    }
    
    // 获取章节内容
    private func getChapterContent(for id: Int) -> String {
        let contents = [
            "这是第一章的内容。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第二章的内容。在这一章中，主角开始了他的冒险之旅。这是一段模拟的长文本内容。这一章包含了更多详细的描述和情节发展，帮助读者更好地理解故事背景和人物动机。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第三章的内容。故事情节开始变得紧张起来。各种矛盾和冲突逐渐显现。主角面临着重大抉择，这将决定故事的走向和他的命运。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第四章的内容。主角遇到了新的挑战和困难。这些挑战将测试主角的能力和决心，同时也推动故事情节向前发展。",
            "这是第五章的内容。故事发展到了一个新的高潮。主角的行动引发了一系列连锁反应，故事情节更加扣人心弦。",
            "这是第六章的内容。主角经历了重大的转折。故事出现了意想不到的变化，读者将看到全新的情节发展。",
            "这是第七章的内容。故事进入了一个新的阶段。主角的成长和变化开始显现，读者将看到更加复杂和深刻的人物塑造。",
            "这是第八章的内容。主角面临最终的挑战。这是整个故事中最困难的考验，也是决定成败的关键时刻。",
            "这是第九章的内容。故事即将迎来结局。所有的情节线索开始汇聚，读者将看到前面埋下的伏笔开始显现。",
            "这是第十章的内容。故事圆满结束。主角完成了他的旅程，所有问题得到解决，故事迎来了完美的结局。"
        ]
        
        if id >= 1 && id <= contents.count {
            return contents[id - 1]
        }
        return "无内容"
    }
}

// MARK: - 为DZMReadController扩展获取章节的方法

/// 用于设置阅读器内容服务的扩展类别
extension ReadController {
    /// 重写获取章节内容的方法（与原有queryChapterData方法逻辑对应，无返回值版本）
    @objc func queryChapterData(bookID: String, chapterID: Int) {
        print("请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 创建章节模型
        let chapterModel = ReadChapterModel.model(bookID: bookID, chapterID: chapterID)
        
        // 设置章节内容
        chapterModel.content = getChapterContent(for: chapterID)
        chapterModel.isContentEmpty = chapterModel.content.isEmpty
        
        // 设置章节名称
        chapterModel.name = "第\(chapterID)章 " + getChapterName(for: chapterID)
        
        // 设置优先级
        chapterModel.priority = chapterModel.id
        
        // 需要判断是否是第一章或者最后一章
        if chapterID == 1 {
            chapterModel.previousChapterID = 0 // DZM_READ_NO_MORE_CHAPTER
        } else {
            chapterModel.previousChapterID = chapterID - 1
        }
        
        // 总章节数
        let chapterCount = 10
        if chapterID == chapterCount {
            chapterModel.nextChapterID = 0 // DZM_READ_NO_MORE_CHAPTER
        } else {
            chapterModel.nextChapterID = chapterID + 1
        }
        
        // 刷新分页
        chapterModel.updateFont()
        
        // 保存
        chapterModel.save()
    }
    
    // 获取章节名称
    private func getChapterName(for id: Int) -> String {
        let names = [
            "开始",
            "冒险开始",
            "矛盾显现",
            "挑战",
            "高潮",
            "转折",
            "新阶段",
            "最终挑战",
            "即将结束",
            "结局"
        ]
        
        if id >= 1 && id <= names.count {
            return names[id - 1]
        }
        return "未知章节"
    }
    
    // 获取章节内容
    private func getChapterContent(for id: Int) -> String {
        let contents = [
            "这是第一章的内容。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第二章的内容。在这一章中，主角开始了他的冒险之旅。这是一段模拟的长文本内容。这一章包含了更多详细的描述和情节发展，帮助读者更好地理解故事背景和人物动机。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第三章的内容。故事情节开始变得紧张起来。各种矛盾和冲突逐渐显现。主角面临着重大抉择，这将决定故事的走向和他的命运。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第四章的内容。主角遇到了新的挑战和困难。这些挑战将测试主角的能力和决心，同时也推动故事情节向前发展。",
            "这是第五章的内容。故事发展到了一个新的高潮。主角的行动引发了一系列连锁反应，故事情节更加扣人心弦。",
            "这是第六章的内容。主角经历了重大的转折。故事出现了意想不到的变化，读者将看到全新的情节发展。",
            "这是第七章的内容。故事进入了一个新的阶段。主角的成长和变化开始显现，读者将看到更加复杂和深刻的人物塑造。",
            "这是第八章的内容。主角面临最终的挑战。这是整个故事中最困难的考验，也是决定成败的关键时刻。",
            "这是第九章的内容。故事即将迎来结局。所有的情节线索开始汇聚，读者将看到前面埋下的伏笔开始显现。",
            "这是第十章的内容。故事圆满结束。主角完成了他的旅程，所有问题得到解决，故事迎来了完美的结局。"
        ]
        
        if id >= 1 && id <= contents.count {
            return contents[id - 1]
        }
        return "无内容"
    }
}

/// 为DZMReadViewScrollController扩展获取章节的方法
extension ReadViewScrollController {
    /// 重写获取章节内容的方法（返回章节模型版本）
    @objc func queryChapterData(bookID: String, chapterID: Int) -> ReadChapterModel? {
        print("滚动控制器请求章节: bookID=\(bookID), chapterID=\(chapterID)")
        
        // 创建章节模型
        let chapterModel = ReadChapterModel.model(bookID: bookID, chapterID: chapterID)
        
        // 设置章节内容
        chapterModel.content = getChapterContent(for: chapterID)
        chapterModel.isContentEmpty = chapterModel.content.isEmpty
        
        // 设置章节名称
        chapterModel.name = "第\(chapterID)章 " + getChapterName(for: chapterID)
        
        // 需要判断是否是第一章或者最后一章
        if chapterID == 1 {
            chapterModel.previousChapterID = 0 // DZM_READ_NO_MORE_CHAPTER
        } else {
            chapterModel.previousChapterID = chapterID - 1
        }
        
        // 总章节数
        let chapterCount = 10
        if chapterID == chapterCount {
            chapterModel.nextChapterID = 0 // DZM_READ_NO_MORE_CHAPTER
        } else {
            chapterModel.nextChapterID = chapterID + 1
        }
        
        // 刷新分页
        chapterModel.updateFont()
        
        // 保存
        chapterModel.save()
        
        return chapterModel
    }
    
    // 获取章节名称
    private func getChapterName(for id: Int) -> String {
        let names = [
            "开始",
            "冒险开始",
            "矛盾显现",
            "挑战",
            "高潮",
            "转折",
            "新阶段",
            "最终挑战",
            "即将结束",
            "结局"
        ]
        
        if id >= 1 && id <= names.count {
            return names[id - 1]
        }
        return "未知章节"
    }
    
    // 获取章节内容
    private func getChapterContent(for id: Int) -> String {
        let contents = [
            "这是第一章的内容。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第二章的内容。在这一章中，主角开始了他的冒险之旅。这是一段模拟的长文本内容。这一章包含了更多详细的描述和情节发展，帮助读者更好地理解故事背景和人物动机。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第三章的内容。故事情节开始变得紧张起来。各种矛盾和冲突逐渐显现。主角面临着重大抉择，这将决定故事的走向和他的命运。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。",
            "这是第四章的内容。主角遇到了新的挑战和困难。这些挑战将测试主角的能力和决心，同时也推动故事情节向前发展。",
            "这是第五章的内容。故事发展到了一个新的高潮。主角的行动引发了一系列连锁反应，故事情节更加扣人心弦。",
            "这是第六章的内容。主角经历了重大的转折。故事出现了意想不到的变化，读者将看到全新的情节发展。",
            "这是第七章的内容。故事进入了一个新的阶段。主角的成长和变化开始显现，读者将看到更加复杂和深刻的人物塑造。",
            "这是第八章的内容。主角面临最终的挑战。这是整个故事中最困难的考验，也是决定成败的关键时刻。",
            "这是第九章的内容。故事即将迎来结局。所有的情节线索开始汇聚，读者将看到前面埋下的伏笔开始显现。",
            "这是第十章的内容。故事圆满结束。主角完成了他的旅程，所有问题得到解决，故事迎来了完美的结局。"
        ]
        
        if id >= 1 && id <= contents.count {
            return contents[id - 1]
        }
        return "无内容"
    }
}

/// DZMReadController 包装器
struct ReadControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ReadController
    
    // 可选参数：书籍ID
    var bookID: String
    
    init(bookID: String = "1001") {
        self.bookID = bookID
    }
    
    func makeUIViewController(context: Context) -> ReadController {
        let vc = ReadController()
        
        // 使用模拟数据创建阅读模型
        let readModel = MockReaderData.shared.createReadModel(bookID: bookID)
        
        // 设置阅读控制器的模型
        vc.readModel = readModel
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ReadController, context: Context) {
        // 如果需要更新配置，可以在这里处理
    }
    
    // 添加析构方法，确保旧控制器被清理
    static func dismantleUIViewController(_ uiViewController: ReadController, coordinator: ()) {
        uiViewController.view.removeFromSuperview()
        uiViewController.removeFromParent()
    }
}

/// 主阅读视图
struct ReaderMainView: View {
    @StateObject private var layoutManager = ReaderLayoutManager.shared
    
    // 可选参数：书籍ID
    var bookID: String
    
    init(bookID: String = "1001") {
        self.bookID = bookID
    }
    
    var body: some View {
        ZStack {
            ReadControllerRepresentable(bookID: bookID)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        .ignoresSafeArea()
        .onAppear {
            print("当前护眼状态: \(layoutManager.safeAreaInsets)")
            print("当前屏幕尺寸: \(UIScreen.main.bounds)")
        }
        .environmentObject(layoutManager)
    }
}
#endif
