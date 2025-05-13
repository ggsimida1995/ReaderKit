import Foundation

/// 公共书籍模型
public struct RKBook: Identifiable, Codable, Hashable {
    public var bkId: Int
    public var author: String
    public var bookName: String
    public var chapterCount: Int
    public var coverImage: String?
    public var detail: String?
    public var lastChapterName: String?
    public var lastUpdateTime: String?
    public var position: Int
    public var read: Int
    public var time: Int
    public var siteName: String?
    public var siteIdent: String?
    public var url: String?
    public var category: String?
    public var type: Int
    public var infoUrl: String
    public var bookSize: String
    public var statusName: String
    public var groupId: Int
    public var update: Int
    public var status: Int
    public var extend: String
    public var isTop: Int
    
    public var id: Int { bkId }
    
    /// 初始化方法
    public init(
        bkId: Int,
        author: String,
        bookName: String,
        chapterCount: Int,
        coverImage: String? = nil,
        detail: String? = nil,
        lastChapterName: String? = nil,
        lastUpdateTime: String? = nil,
        position: Int = 1,
        read: Int = 0,
        time: Int = 0,
        siteName: String? = nil,
        siteIdent: String? = nil,
        url: String? = nil,
        category: String? = nil,
        type: Int = 0,
        infoUrl: String = "",
        bookSize: String = "",
        statusName: String = "",
        groupId: Int = 0,
        update: Int = 0,
        status: Int = 0,
        extend: String = "",
        isTop: Int = 0
    ) {
        self.bkId = bkId
        self.author = author
        self.bookName = bookName
        self.chapterCount = chapterCount
        self.coverImage = coverImage
        self.detail = detail
        self.lastChapterName = lastChapterName
        self.lastUpdateTime = lastUpdateTime
        self.position = position
        self.read = read
        self.time = time
        self.siteName = siteName
        self.siteIdent = siteIdent
        self.url = url
        self.category = category
        self.type = type
        self.infoUrl = infoUrl
        self.bookSize = bookSize
        self.statusName = statusName
        self.groupId = groupId
        self.update = update
        self.status = status
        self.extend = extend
        self.isTop = isTop
    }
    
    // 实现 Hashable
    public static func == (lhs: RKBook, rhs: RKBook) -> Bool {
        lhs.bkId == rhs.bkId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bkId)
    }
} 