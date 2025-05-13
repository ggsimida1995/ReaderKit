//
//  Content.swift
//  ReaderKit
//
//  Created by 冯大象 on 2025/5/13.
//
import SwiftUI

struct ContentView: View {
    @State private var isReaderInitialized = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if isReaderInitialized {
                demoReaderView()
            } else {
                setupView()
            }
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("确定", role: .cancel) { }
        }
    }
    
    // 阅读器设置视图
    private func setupView() -> some View {
        VStack(spacing: 20) {
            Text("ReaderKit 示例应用")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("版本 \(ReaderKit.version)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                initializeReaderKit()
            }) {
                Text("初始化阅读器")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    // 示例阅读器视图
    private func demoReaderView() -> some View {
        VStack {
            // 创建示例书籍
            let demoBook = RKBook(
                bkId: 1001,
                author: "示例作者",
                bookName: "示例小说",
                chapterCount: 5,
                position: 1,
                read: 0,
                time: 0,
                type: 0,
                infoUrl: "",
                bookSize: "",
                statusName: "",
                groupId: 0,
                update: 0,
                status: 0,
                extend: "",
                isTop: 0
            )
            
            // 使用 ReaderKit 的 readerView 方法显示阅读器界面
            ReaderKit.readerView(book: demoBook)
        }
    }
    
    // 初始化 ReaderKit
    private func initializeReaderKit() {
        // 初始化 ReaderKit
        ReaderKit.initialize(with: ReaderKit.Configuration(
            isDebugMode: true,
            defaultFontSize: 18,
            defaultTheme: .light
        ))
        
        // 创建示例章节提供者
        let demoProvider = DemoChapterProvider()
        
        // 设置章节提供者
        ReaderKit.setChapterProvider(demoProvider)
        
        // 标记初始化完成
        isReaderInitialized = true
    }
}

// 示例章节提供者
class DemoChapterProvider: ChapterProvider {
    func getChapterContent(bookID: String, chapterID: Int) -> ChapterContent? {
        // 创建测试内容
        let chapterTitle: String
        let chapterContent: [String]
        
        switch chapterID {
        case 1:
            chapterTitle = "第一章 序章"
            chapterContent = [
                "这是一个示例小说的第一章内容。",
                "在这个章节中，我们将介绍主角的背景故事。",
                "故事发生在一个遥远的星系，主角是一名年轻的冒险家。",
                "他即将踏上一段不可思议的旅程。"
            ]
        case 2:
            chapterTitle = "第二章 冒险开始"
            chapterContent = [
                "主角离开了家乡，踏上了冒险之旅。",
                "在旅途中，他遇到了许多有趣的人物。",
                "他们一起克服了各种困难和挑战。",
                "每一次经历都让主角变得更加坚强。"
            ]
        case 3:
            chapterTitle = "第三章 危机四伏"
            chapterContent = [
                "冒险的道路上充满了危险。",
                "主角和他的伙伴们遇到了一个强大的敌人。",
                "他们必须团结一致才能战胜这个敌人。",
                "这是对他们友谊的考验。"
            ]
        case 4:
            chapterTitle = "第四章 胜利的希望"
            chapterContent = [
                "经过艰苦的战斗，主角终于看到了胜利的希望。",
                "他发现了敌人的弱点。",
                "利用这个弱点，他们有可能击败敌人。",
                "但这需要付出巨大的牺牲。"
            ]
        case 5:
            chapterTitle = "第五章 新的开始"
            chapterContent = [
                "战斗终于结束了，主角和他的伙伴们取得了胜利。",
                "他们回到了家乡，受到了人们的欢迎。",
                "这次冒险让主角明白了生命的意义。",
                "现在，一个新的冒险正在等待着他。"
            ]
        default:
            return nil
        }
        
        return ChapterContent(
            id: chapterID,
            index: chapterID,
            siteIdent: "demo",
            chapterName: chapterTitle,
            url: nil,
            contents: chapterContent,
            playUrl: "",
            type: 0,
            chapterCount: 5
        )
    }
}

#Preview {
    ContentView()
}
