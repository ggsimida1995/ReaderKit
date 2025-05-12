# ReaderKit

ReaderKit 是一个现代化的 Swift 电子书阅读器框架，提供完整的阅读体验，包括翻页、主题定制、布局管理和阅读状态追踪等功能。

## 功能

- 支持多种翻页模式
- 自定义主题（明亮/暗黑模式）
- 灵活的排版设置（字体、间距、边距等）
- 阅读进度追踪
- 章节管理
- 支持通过 JSON 接收数据

## 要求

- iOS 17.0+
- Swift 5.9+
- Xcode 15.0+

## 安装

### Swift Package Manager

在 Xcode 中，选择 File → Add Packages... 并添加仓库 URL:

```
https://github.com/yourusername/ReaderKit.git
```

或者在您的 `Package.swift` 文件中添加:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ReaderKit.git", from: "1.0.0")
]
```

## 快速开始

### 初始化

```swift
import ReaderKit
import SwiftUI

@main
struct YourApp: App {
    init() {
        // 初始化 ReaderKit
        ReaderKit.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 加载书籍和章节数据

ReaderKit 支持通过 JSON 字符串加载数据，使您能轻松地从网络服务或本地存储中获取数据：

```swift
// 加载书籍数据
let bookJson = """
{
    "bkId": 1001,
    "bookName": "测试小说",
    "position": 0,
    "chapterCount": 3
}
"""
ReaderKit.loadBook(jsonString: bookJson)

// 加载章节列表
let chaptersJson = """
[
    {
        "id": 1,
        "title": "第一章 序章",
        "isFree": true
    },
    {
        "id": 2,
        "title": "第二章 冒险开始",
        "isFree": true
    }
]
"""
ReaderKit.loadChapters(jsonString: chaptersJson)

// 加载单个章节内容
let contentJson = """
{
    "id": 1,
    "content": "这是第一章的内容，包含了许多精彩的故事情节。"
}
"""
ReaderKit.loadChapterContent(chapterId: 1, contentJson: contentJson)
```

### 使用阅读器视图

```swift
import ReaderKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ReaderKit.readerView()
        }
    }
}
```

### 配置阅读器

```swift
import ReaderKit
import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Button("设置深色模式") {
                ReaderConfig.shared.setTheme(.dark)
            }
            
            Button("设置字体大小") {
                ReaderConfig.shared.setFontSize(18)
            }
        }
    }
}
```

## 自定义

ReaderKit 提供多种方式进行自定义，包括主题、布局和交互方式等。详细配置请参考 API 文档。

## 许可证

此项目使用 MIT 许可证 - 详情请查看 LICENSE 文件。

# 章节内容服务说明

## DefaultChapterContentService

### 功能
提供标准的章节内容获取服务，支持通过书籍ID和章节ID获取完整的章节模型，自动处理内容排版、分页、章节名、前后章节ID等所有关键参数，保证翻页和阅读体验流畅。

### 方法说明

#### getChapter(bookID: String, chapterID: Int) -> ReadChapterModel?
- **参数**：
  - `bookID`：书籍唯一标识符（字符串）
  - `chapterID`：章节编号（从1开始，Int类型）
- **返回值**：
  - 返回完整的 `ReadChapterModel` 实例，包含所有章节元数据、内容、分页信息等。
  - 如果参数无效或章节不存在，返回 `nil`。

- **行为细节**：
  1. 查询数据库或模拟数据源，获取章节原始内容和章节名。
  2. 自动设置章节名、内容、是否为空、优先级、上一章ID、下一章ID。
  3. 内容自动排版，适配阅读器显示需求。
  4. 自动刷新分页和字体，保证内容显示正确。
  5. 自动保存章节模型，便于后续快速读取。

### 使用示例
```swift
if let chapter = DefaultChapterContentService.shared.getChapter(bookID: "1001", chapterID: 2) {
    // 章节内容已完整设置，可直接用于阅读器显示和翻页
    print(chapter.name)
    print(chapter.content)
    print("上一章ID: \(chapter.previousChapterID) 下一章ID: \(chapter.nextChapterID)")
}
```

### 扩展说明
- 如需对接真实数据库，只需将 `getChapter` 方法中的 Mock 数据替换为数据库查询逻辑，并保证所有参数设置完整。
- 所有章节模型参数请参考 `ReadChapterModel` 的定义。

---

如有疑问或需进一步扩展，请联系开发者或查阅 Apple 官方 [iOS开发文档](https://developer.apple.com/documentation/)。

## 作为扩展库使用

ReaderKit 可以作为独立的扩展库集成到您的项目中，并支持传入自定义的阅读模型。

### 配置和初始化

首先，使用自定义配置初始化 ReaderKit：

```swift
import ReaderKit
import SwiftUI

// 初始化ReaderKit并配置
ReaderKit.initialize(with: ReaderKit.Configuration(
    isDebugMode: true,
    defaultFontSize: 18,
    defaultTheme: .light
))
```

### 使用自定义阅读模型

ReaderKit 支持传入自定义的 `RKReadModel` 实例，以便与现有项目的数据模型无缝集成：

```swift
import ReaderKit
import SwiftUI

struct BookReaderView: View {
    // 您应用中的书籍数据
    let bookID: String
    let bookName: String
    let chapters: [ChapterInfo] // 您自己的章节信息结构
    
    var body: some View {
        // 创建阅读模型
        let readModel = createCustomReadModel()
        
        // 使用自定义阅读模型的阅读器视图
        return ReaderKit.readerView(with: readModel)
    }
    
    // 创建自定义阅读模型
    private func createCustomReadModel() -> RKReadModel {
        // 将您的章节信息转换为RKReadChapterListModel
        let chapterListModels = chapters.enumerated().map { index, chapter -> RKReadChapterListModel in
            let model = RKReadChapterListModel()
            model.id = index + 1
            model.name = chapter.title
            return model
        }
        
        // 使用ReaderKit提供的便捷方法创建阅读模型
        return ReaderKit.createReadModel(
            bookID: bookID,
            bookName: bookName,
            chapterListModels: chapterListModels
        )
    }
}
```

### 使用自定义章节内容服务

您可以实现自己的 `ChapterContentService`，以便从您的后端服务或本地数据库获取章节内容：

```swift
import ReaderKit

class MyCustomChapterService: ChapterContentService {
    static let shared = MyCustomChapterService()
    
    private init() {}
    
    func getChapter(bookID: String, chapterID: Int) -> RKReadChapterModel? {
        // 1. 从您的API或数据库获取章节内容
        let chapterContent = fetchChapterFromDatabase(bookID: bookID, chapterID: chapterID)
        
        // 2. 创建章节模型
        let chapterModel = RKReadChapterModel()
        chapterModel.bookID = bookID
        chapterModel.id = chapterID
        chapterModel.name = chapterContent.title
        
        // 3. 设置内容并排版
        chapterModel.content = RKReadParser.contentTypesetting(content: chapterContent.text)
        chapterModel.isContentEmpty = chapterContent.text.isEmpty
        
        // 4. 设置其他必要参数
        chapterModel.priority = chapterID
        chapterModel.previousChapterID = chapterID > 1 ? chapterID - 1 : 0
        chapterModel.nextChapterID = (chapterID < totalChapterCount) ? chapterID + 1 : -1
        
        // 5. 分页和字体刷新
        chapterModel.updateFont()
        
        return chapterModel
    }
    
    // 从您的数据来源获取章节内容的方法
    private func fetchChapterFromDatabase(bookID: String, chapterID: Int) -> (title: String, text: String) {
        // 实现您的数据获取逻辑
        // ...
        return ("章节标题", "章节内容")
    }
}
```

### 在您的应用中展示阅读器

```swift
import SwiftUI
import ReaderKit

struct YourBookDetailView: View {
    let book: YourBookModel
    
    var body: some View {
        VStack {
            // 书籍信息展示
            Text(book.title).font(.title)
            Text(book.author).font(.subheadline)
            
            // 打开阅读器按钮
            Button("开始阅读") {
                // 获取章节数据
                let chapters = fetchChapters(for: book.id)
                
                // 创建阅读模型
                let readModel = ReaderKit.createReadModel(
                    bookID: book.id,
                    bookName: book.title,
                    chapterListModels: chapters
                )
                
                // 打开阅读器视图
                showReader(with: readModel)
            }
        }
    }
    
    // 打开阅读器视图的方法
    private func showReader(with readModel: RKReadModel) {
        let readerView = ReaderKit.readerView(with: readModel)
        // 使用您应用的导航机制展示readerView
    }
}
``` 