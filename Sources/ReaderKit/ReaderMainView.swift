import SwiftUI
#if canImport(UIKit)
import UIKit

/// 阅读器主视图
struct ReaderMainView: View {
    // MARK: - Properties
    @State private var isPresented = false
    @State private var selectedBookID = "1001"
    
    // MARK: - Body
    var body: some View {
        VStack {
            // 阅读器视图
            RKReadControllerRepresentable(bookID: selectedBookID)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // 初始化时调用getChapter方法
                    if let chapter = DefaultChapterContentService.shared.getChapter(bookID: selectedBookID, chapterID: 1) {
                        print("章节名称: \(chapter.name)")
                        print("章节内容: \(chapter.content)")
                    }
                }
            
            // 底部按钮
            HStack {
                Button("山海经") {
                    selectedBookID = "1001"
                }
                .padding()
                
                Button("西游记") {
                    selectedBookID = "1002"
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview
struct ReaderMainView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderMainView()
    }
}
#endif
