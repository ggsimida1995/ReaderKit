import Foundation

/// 模拟数据工具类 - 参照DZMReadModel结构创建
class MockReaderData: ChapterContentService {
    static let shared = MockReaderData()
    
    // 保存已创建的章节模型的缓存
    private var chapterCache: [String: RKReadChapterModel] = [:]
    
    // 书籍信息
    let books: [String: (name: String, chapters: [(name: String, content: String)])] = [
        "1001": (
            name: "山海经",
            chapters: [
                ("开始", "这是山海经第一章的内容。远古时期，天地初开，万物生长。山川河流，草木虫鱼，各具特色。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("冒险开始", "这是山海经第二章的内容。主角开始了他的冒险之旅，探索神秘的山海世界。这是一段模拟的长文本内容。这一章包含了更多详细的描述和情节发展，帮助读者更好地理解故事背景和人物动机。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("矛盾显现", "这是山海经第三章的内容。故事情节开始变得紧张起来。各种矛盾和冲突逐渐显现。主角面临着重大抉择，这将决定故事的走向和他的命运。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("挑战", "这是山海经第四章的内容。主角遇到了新的挑战和困难。这些挑战将测试主角的能力和决心，同时也推动故事情节向前发展。"),
                ("高潮", "这是山海经第五章的内容。故事发展到了一个新的高潮。主角的行动引发了一系列连锁反应，故事情节更加扣人心弦。"),
                ("转折", "这是山海经第六章的内容。主角经历了重大的转折。故事出现了意想不到的变化，读者将看到全新的情节发展。"),
                ("新阶段", "这是山海经第七章的内容。故事进入了一个新的阶段。主角的成长和变化开始显现，读者将看到更加复杂和深刻的人物塑造。"),
                ("最终挑战", "这是山海经第八章的内容。主角面临最终的挑战。这是整个故事中最困难的考验，也是决定成败的关键时刻。"),
                ("即将结束", "这是山海经第九章的内容。故事即将迎来结局。所有的情节线索开始汇聚，读者将看到前面埋下的伏笔开始显现。"),
                ("结局", "这是山海经第十章的内容。故事圆满结束。主角完成了他的旅程，所有问题得到解决，故事迎来了完美的结局。")
            ]
        ),
        "1002": (
            name: "西游记",
            chapters: [
                ("石猴出世", "这是西游记第一章的内容。花果山上，一块仙石孕育了五百年，终于诞生了一只石猴。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("拜师学艺", "这是西游记第二章的内容。石猴来到灵台方寸山，拜菩提祖师为师，学习七十二变和筋斗云。这是一段模拟的长文本内容。这一章包含了更多详细的描述和情节发展，帮助读者更好地理解故事背景和人物动机。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("大闹天宫", "这是西游记第三章的内容。孙悟空大闹天宫，与天兵天将展开激烈战斗。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。这是测试内容，模拟小说阅读器的显示效果。这里可以放入更多的文字来测试分页和排版功能。"),
                ("被压五行山", "这是西游记第四章的内容。如来佛祖出手，将孙悟空压在五行山下。"),
                ("唐僧取经", "这是西游记第五章的内容。唐僧受命前往西天取经，开始了他的旅程。"),
                ("收服徒弟", "这是西游记第六章的内容。唐僧先后收服了孙悟空、猪八戒和沙僧为徒。"),
                ("三打白骨精", "这是西游记第七章的内容。孙悟空三打白骨精，展现了师徒之间的信任与矛盾。"),
                ("火焰山", "这是西游记第八章的内容。师徒四人来到火焰山，与铁扇公主斗智斗勇。"),
                ("真假美猴王", "这是西游记第九章的内容。六耳猕猴冒充孙悟空，引发了一场真假美猴王的大战。"),
                ("取得真经", "这是西游记第十章的内容。历经九九八十一难，唐僧终于取得真经，功德圆满。")
            ]
        )
    ]
    
    // 生成模拟的DZMReadModel
    func createReadModel(bookID: String = "1001") -> RKReadModel {
        // 创建阅读模型
        let readModel = RKReadModel()
        readModel.bookID = bookID
        readModel.bookName = books[bookID]?.name ?? "未知书籍"
        readModel.bookSourceType = .network
        readModel.chapterCount = 10
        
        // 创建章节列表
        var chapterListModels: [RKReadChapterListModel] = []
        if let book = books[bookID] {
            for (index, chapter) in book.chapters.enumerated() {
                let chapterModel = RKReadChapterListModel()
                chapterModel.id = index + 1
                chapterModel.name = "第\(index + 1)章 " + chapter.name
                chapterListModels.append(chapterModel)
            }
        }
        readModel.chapterListModels = chapterListModels
        
        // 创建书签列表
        readModel.markModels = []
        
        // 创建阅读记录
        let recordModel = RKReadRecordModel()
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
    func createChapterModel(bookID: String, chapterID: Int) -> RKReadChapterModel {
        // 检查缓存中是否已存在该章节
        let cacheKey = "\(bookID)_\(chapterID)"
        if let cachedChapter = chapterCache[cacheKey] {
            return cachedChapter
        }
        
        let chapterModel = RKReadChapterModel()
        chapterModel.bookID = bookID
        chapterModel.id = chapterID
        
        if let book = books[bookID], chapterID > 0 && chapterID <= book.chapters.count {
            let chapter = book.chapters[chapterID - 1]
            chapterModel.name = "第\(chapterID)章 " + chapter.name
            chapterModel.content = chapter.content
        } else {
            chapterModel.name = "第\(chapterID)章 未知章节"
            chapterModel.content = "无内容"
        }
        
        chapterModel.isContentEmpty = chapterModel.content.isEmpty
        
        // 设置上一章和下一章
        chapterModel.previousChapterID = chapterID > 1 ? chapterID - 1 : 0
        chapterModel.nextChapterID = chapterID < 10 ? chapterID + 1 : 0
        
        // 更新字体和分页
        chapterModel.updateFont()
        
        // 缓存章节
        chapterCache[cacheKey] = chapterModel
        
        return chapterModel
    }
    
    // MARK: - ReaderContentService Protocol
    
    /// 根据书籍ID和章节ID获取章节模型
    func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel? {
        // 检查章节ID是否有效
        if chapterID < 1 || chapterID > 10 {
            return nil
        }
        
        // 创建并返回章节模型
        return createChapterModel(bookID: bookID, chapterID: chapterID)
    }
} 
