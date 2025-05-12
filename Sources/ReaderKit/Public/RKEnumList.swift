import UIKit

/// 书籍来源类型
enum RKBookSourceType: Int, CaseIterable {
    /// 网络小说
    case network
    /// 本地小说
    case local

    var description: String {
        switch self {
        case .network:
            return "网络小说"
        case .local:
            return "本地小说"
        }
    }
}

/// 阅读翻页类型
enum RKEffectType: Int, CaseIterable {
    /// 仿真
    case simulation
    /// 覆盖
    case cover
    /// 左右平移
    case hTranslation
    /// 上下平移
    case vTranslation
    /// 滚动
    case scroll
    /// 无效果
    case no

    var description: String {
        switch self {
        case .simulation:
            return "仿真"
        case .cover:
            return "覆盖"
        case .hTranslation:
            return "左右平移"
        case .vTranslation:
            return "上下平移"
        case .scroll:
            return "滚动"
        case .no:
            return "无效果"
        }
    }
}

/// 阅读字体类型
enum RKFontType: Int, CaseIterable {
    /// 系统
    case system
    /// 黑体
    case one
    /// 楷体
    case two
    /// 宋体
    case three

    var description: String {
        switch self {
        case .system:
            return "系统"
        case .one:
            return "黑体"
        case .two:
            return "楷体"
        case .three:
            return "宋体"
        }
    }
}
// 标题位置
enum RKTitlePositionType: Int, CaseIterable {
    /// 居中
    case center
    /// 居左
    case left
    /// 居右
    case right

    var description: String {
        switch self {
        case .center:
            return "居中"
        case .left:
            return "居左"
        case .right:
            return "居右"
        }
    }
}

/// 阅读内容间距类型
enum RKSpacingType: Int, CaseIterable {
    /// 大间距
    case big
    /// 适中间距
    case middle
    /// 小间距
    case small

    var description: String {
        switch self {
        case .big:
            return "大间距"
        case .middle:
            return "适中间距"
        case .small:
            return "小间距"
        }
    }
}

/// 阅读进度类型
enum RKProgressType: Int, CaseIterable {
    /// 总进度
    case total
    /// 分页进度
    case page

    var description: String {
        switch self {
        case .total:
            return "总进度"
        case .page:
            return "分页进度"
        }
    }
}

/// 分页内容是以什么开头
enum RKPageHeadType: Int, CaseIterable {
    /// 章节名
    case chapterName
    /// 段落
    case paragraph
    /// 行内容
    case line

    var description: String {
        switch self {
        case .chapterName:
            return "章节名"
        case .paragraph:
            return "段落"
        case .line:
            return "行内容"
        }
    }
}
