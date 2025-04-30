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