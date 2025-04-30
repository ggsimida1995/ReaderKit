import SwiftUI

/// 书籍卡片预览
public struct BookCard: View {
    var title: String
    var author: String
    var description: String
    var color: Color
    var progress: Double
    
    public init(
        title: String,
        author: String,
        description: String,
        color: Color = .blue,
        progress: Double = 0
    ) {
        self.title = title
        self.author = author
        self.description = description 
        self.color = color
        self.progress = min(max(progress, 0), 1)
    }
    
    public var body: some View {
        NavigationLink {
            ReaderMainView()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // 封面
                Rectangle()
                    .fill(color)
                    .overlay {
                        Image(systemName: "book.closed")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                
                // 书籍信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    Text(author)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                    
                    // 阅读进度
                    VStack(alignment: .leading, spacing: 4) {
                        Text("阅读进度: \(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 4)
                                    .clipShape(Capsule())
                                
                                Rectangle()
                                    .fill(color)
                                    .frame(width: geometry.size.width * progress, height: 4)
                                    .clipShape(Capsule())
                            }
                        }
                        .frame(height: 4)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

/// 书架视图
public struct BookshelfView: View {
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    BookCard(
                        title: "山海经",
                        author: "佚名",
                        description: "中国古代神话传说集，记录了上古时期的地理、物产、神话、巫术、宗教、医药、民俗等内容。",
                        color: .blue,
                        progress: 0.35
                    )
                    
                    BookCard(
                        title: "聊斋志异",
                        author: "蒲松龄",
                        description: "中国清代著名小说集，收录了近五百个短篇故事，多描写神鬼狐仙和人间爱情。",
                        color: .purple,
                        progress: 0.65
                    )
                    
                    BookCard(
                        title: "西游记",
                        author: "吴承恩",
                        description: "中国古典四大名著之一，讲述了唐僧师徒四人前往西天取经，历经九九八十一难的故事。",
                        color: .red,
                        progress: 0.2
                    )
                    
                    BookCard(
                        title: "红楼梦",
                        author: "曹雪芹",
                        description: "中国古典小说巅峰之作，描写了贾、史、王、薛四大家族的兴衰故事，以及贾宝玉与林黛玉的爱情悲剧。",
                        color: .pink,
                        progress: 0.8
                    )
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("我的书架")
        }
    }
    
    public init() {}
}

// 预览
#if DEBUG
#Preview {
    BookshelfView()
}
#endif 
