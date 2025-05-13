import SwiftUI

// MARK: - UIFont.Weight 的 Codable 扩展
extension UIFont.Weight: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(CGFloat.self)
        self = UIFont.Weight(rawValue: rawValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

// MARK: - 通知名称扩展
extension Notification.Name {
    static let readerLayoutDidChange = Notification.Name("ReaderLayoutDidChange")
    static let readerNeedRepaginate = Notification.Name("ReaderNeedRepaginate")
}

// MARK: - 排版相关常量
struct LayoutConstants {
    static let defaultFontSize: CGFloat = 22
    static let defaultTitleFontSize: CGFloat = 26
    static let defaultLineSpacing: CGFloat = 8
    static let defaultParagraphSpacing: CGFloat = 15
    static let defaultLetterSpacing: CGFloat = 0
    static let defaultFirstLineHeadIndent: CGFloat = defaultFontSize * 2
    static let defaultPageInsetHorizontal: CGFloat = 20
    static let defaultPageInsetVertical: CGFloat = 10
    static let defaultHeaderHeight: CGFloat = 49
    static let defaultFooterHeight: CGFloat = 20
    static let defaultTitleContentSpacing: CGFloat = 35
}

// MARK: - 排版设置结构体
struct ReaderLayoutSettings: Codable {
    var fontSize: CGFloat
    var titleFontSize: CGFloat
    var lineSpacing: CGFloat
    var paragraphSpacing: CGFloat
    var letterSpacing: CGFloat
    var firstLineHeadIndent: CGFloat
    var fontWeight: UIFont.Weight = .regular
    var titleContentSpacing: CGFloat
    var pageInsetLeft: CGFloat
    var pageInsetRight: CGFloat
    var pageInsetTop: CGFloat
    var pageInsetBottom: CGFloat
    var headerHeight: CGFloat
    var footerHeight: CGFloat
    var contentWidth: CGFloat
    var contentHeight: CGFloat
    var effectIndex:Int
    var openLongPress:Bool
    var progressIndex:Int
    var titlePositionIndex:Int
    var selectedFont: Int
    
    // MARK: - 基本设置
    /// 是否启用翻页动画
    var pageAnimationEnabled: Bool = true
    /// 是否跟随系统深色模式
    var followSystemDarkMode: Bool = false
    /// 是否启用深色模式
    var darkModeEnabled: Bool = false
    /// 是否保持屏幕常亮
    var keepScreenOn: Bool = false
    /// 是否继续上次阅读
    var continueLastRead: Bool = false
    /// 是否启用音量键翻页
    var volumePageTurn: Bool = false
    
    // MARK: - 菜单设置
    /// 导航菜单样式选项索引
    var navigationMenuOption: Int = 0
    /// 底部菜单滑动条选项索引
    var bottomBarOption: Int = 0
    /// 退出动画选项索引
    var exitAnimationOption: Int = 0
    /// 底部小横条选项索引
    var bottomStripOption: Int = 0
    /// 滑动退出选项索引
    var slideToExitOption: Int = 0
    // MARK: - 附加设置
    /// 是否同步上下组件字体
    var fontSync: Bool = false
    /// 是否显示状态栏
    var showStatusBar: Bool = false
    /// 是否启用长按手势
    var longPressGesture: Bool = false
    
    // MARK: - 护眼模式设置
    /// 是否启用护眼模式
    var eyeProtectionEnabled: Bool = false
    /// 有害光线过滤强度（0-100）
    var harmfulLightFilter: Int = 30
    /// 背光减弱强度（0-100）
    var backLightReduction: Int = 5
    
    // MARK: - 组件设置
    /// 页眉组件选择（按位置存储选中的组件索引）
    var headerComponents: [Set<String>] = [Set<String>(), Set<String>(), Set<String>()] // [左边, 中间, 右边]
    /// 页脚组件选择（按位置存储选中的组件索引）
    var footerComponents: [Set<String>] = [Set<String>(), Set<String>(), Set<String>()] // [左边, 中间, 右边]
    
    static let `default` = ReaderLayoutSettings(
        fontSize: LayoutConstants.defaultFontSize,
        titleFontSize: LayoutConstants.defaultTitleFontSize,
        lineSpacing: LayoutConstants.defaultLineSpacing,
        paragraphSpacing: LayoutConstants.defaultParagraphSpacing,
        letterSpacing: LayoutConstants.defaultLetterSpacing,
        firstLineHeadIndent: LayoutConstants.defaultFirstLineHeadIndent,
        fontWeight: .regular,
        titleContentSpacing: LayoutConstants.defaultTitleContentSpacing,
        pageInsetLeft: LayoutConstants.defaultPageInsetHorizontal,
        pageInsetRight: LayoutConstants.defaultPageInsetHorizontal,
        pageInsetTop: LayoutConstants.defaultPageInsetVertical,
        pageInsetBottom: LayoutConstants.defaultPageInsetVertical,
        headerHeight: LayoutConstants.defaultHeaderHeight,
        footerHeight: LayoutConstants.defaultFooterHeight,
        contentWidth: UIScreen.main.bounds.width - LayoutConstants.defaultPageInsetHorizontal * 2,
        contentHeight: UIScreen.main.bounds.height - LayoutConstants.defaultPageInsetVertical * 2 - LayoutConstants.defaultHeaderHeight - LayoutConstants.defaultFooterHeight,
        effectIndex:  1,
        openLongPress: true,
        progressIndex: 1,
        titlePositionIndex: 0,
        selectedFont: 0,
        // 基本设置
        pageAnimationEnabled: true,
        followSystemDarkMode: false,
        darkModeEnabled: false,
        keepScreenOn: false,
        continueLastRead: false,
        volumePageTurn: false,
        // 菜单设置
        navigationMenuOption: 0,
        bottomBarOption: 0,
        exitAnimationOption: 0,
        bottomStripOption: 0,
        slideToExitOption: 0,
        // 附加设置
        fontSync: false,
        showStatusBar: false,
        longPressGesture: false,
        // 护眼模式设置
        eyeProtectionEnabled: false,
        harmfulLightFilter: 30,
        backLightReduction: 5,
        // 组件设置
        headerComponents: [Set<String>(), Set<String>(), Set<String>()],
        footerComponents: [Set<String>(), Set<String>(), Set<String>()]
    )
    
    // var textAttributes: [NSAttributedString.Key: Any] {
    //     let paragraphStyle = NSMutableParagraphStyle()
    //     paragraphStyle.lineSpacing = lineSpacing
    //     paragraphStyle.paragraphSpacing = paragraphSpacing
    //     paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
    //     paragraphStyle.alignment = .justified
    //     paragraphStyle.lineBreakMode = .byWordWrapping
    
    //     return [
    //         .font: currentFont,
    //         .paragraphStyle: paragraphStyle,
    //         .kern: letterSpacing
    //     ]
    // }
    
    mutating func updateInsets(_ insets: UIEdgeInsets) {
        pageInsetTop = insets.top
        pageInsetBottom = insets.bottom
        pageInsetLeft = insets.left
        pageInsetRight = insets.right
        NotificationCenter.default.post(name: .readerNeedRepaginate, object: nil)
    }
    
    var insets: UIEdgeInsets {
        UIEdgeInsets(
            top: pageInsetTop,
            left: pageInsetLeft,
            bottom: pageInsetBottom,
            right: pageInsetRight
        )
    }
    
    // var paragraphStyle: NSMutableParagraphStyle {
    //     let style = NSMutableParagraphStyle()
    //     style.lineSpacing = lineSpacing
    //     style.paragraphSpacing = paragraphSpacing
    //     style.firstLineHeadIndent = firstLineHeadIndent
    //     style.lineBreakMode = .byWordWrapping
    //     return style
    // }
    
    var currentFont: UIFont {
        return .systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    var currentTitleFont: UIFont {
        return .systemFont(ofSize:  titleFontSize, weight: fontWeight)
    }
    
    // var currentLineSpacing: CGFloat {
    //     return lineSpacing
    // }
    
    // var currentParagraphSpacing: CGFloat {
    //     return paragraphSpacing
    // }
}

// MARK: - 排版管理器
final class ReaderLayoutManager: ObservableObject {
    public static let shared = ReaderLayoutManager()
    
    private enum Keys {
        static let prefix = "reader.layout."
        static func key(_ name: String) -> String { "\(prefix)\(name)" }
        static let layoutSettings = key("settings")
    }
    
    // MARK: - 组件数据
    /// 页眉页脚可选组件
    static let components: [String: (String, String, String)] = [
        "chapterName": ("Title", "章节名", "text.alignleft"),
        "bookName": ("doc.text", "书名", "doc.text"),
        "pageNumber": ("number", "页码", "number"),
        "chapterProgress": ("percent", "章节进度", "percent"),
        "time": ("clock", "时间", "clock"),
        "battery": ("battery.100", "电量", "battery.100")
    ]
    
    @Published private(set) var settings: ReaderLayoutSettings {
        didSet {
            saveSettings()
            notifyChanges()
        }
    }
    
    /// 安全区域边距
    // @Published var safeAreaInsets = UIApplication.shared.connectedScenes
    //     .compactMap { $0 as? UIWindowScene }
    //     .flatMap { $0.windows }
    //     .first
    /// 开启长按菜单功能 (滚动模式是不支持长按功能的)
    @Published var openLongPress:Bool = true
    
    private init() {
        self.settings = .default
        
        if let layoutData = UserDefaults.standard.data(forKey: Keys.layoutSettings),
           let layout = try? JSONDecoder().decode(ReaderLayoutSettings.self, from: layoutData) {
            self.settings = layout
        }
        updateSettingsToMatchDefaults()
    }
    
    
    
    func resetToDefaults() {
        settings = .default
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: Keys.layoutSettings)
        }
    }
    
    private func notifyChanges() {
        NotificationCenter.default.post(
            name: .readerLayoutDidChange,
            object: nil,
            userInfo: ["settings": settings]
        )
        NotificationCenter.default.post(name: .readerNeedRepaginate, object: nil)
    }
    
    private func updateSettingsToMatchDefaults() {
        var newSettings = settings
        newSettings.pageInsetTop = LayoutConstants.defaultPageInsetVertical
        newSettings.pageInsetBottom = LayoutConstants.defaultPageInsetVertical
        newSettings.pageInsetLeft = LayoutConstants.defaultPageInsetHorizontal
        newSettings.pageInsetRight = LayoutConstants.defaultPageInsetHorizontal
        settings = newSettings
    }
    
    
    // MARK: - 常量
    /// 字体选项列表
    let fontOptions = ["原文", "简体", "繁体"]
    /// 滑动退出选项列表
    let slideOptions = ["关闭", "左滑", "右滑"]
    /// 导航菜单样式选项列表
    let navigationMenuOptions = ["极简", "显示章节信息"]
    /// 底部菜单滑动条选项列表
    let bottomBarOptions = ["按章节", "按页码", "按章节和页码"]
    /// 退出动画选项列表
    let exitAnimationOptions = ["大红块儿", "弹出提示"]
    /// 底部小横条选项列表
    let bottomStripOptions = ["常规", "自动隐藏", "防止误触"]
    
    
}

// MARK: - 扩展：便捷访问和属性方法
extension ReaderLayoutManager {
    var fontSize: CGFloat { settings.fontSize }
    var titleFontSize: CGFloat { settings.titleFontSize }
    var lineSpacing: CGFloat { settings.lineSpacing }
    var paragraphSpacing: CGFloat { settings.paragraphSpacing }
    var letterSpacing: CGFloat { settings.letterSpacing }
    var firstLineHeadIndent: CGFloat { settings.firstLineHeadIndent }
    var fontWeight: UIFont.Weight { settings.fontWeight }
    var titleContentSpacing: CGFloat { settings.titleContentSpacing }
    var pageInsets: UIEdgeInsets { settings.insets }
    var headerHeight: CGFloat { settings.headerHeight }
    var footerHeight: CGFloat { settings.footerHeight }
    var contentWidth: CGFloat { settings.contentWidth }
    var contentHeight: CGFloat { settings.contentHeight }
    var effectIndex: Int { settings.effectIndex }
    var progressIndex: Int { settings.progressIndex }
    var titlePositionIndex: Int { settings.titlePositionIndex }
    
    /// 更新间距类型
    func updateSpacingType(_ type: DZMSpacingType) {
        var newLineSpacing: CGFloat = 5
        var newParagraphSpacing: CGFloat = 10
        
        switch type {
        case .big:
            newLineSpacing = 10
            newParagraphSpacing = 20
        case .middle:
            newLineSpacing = 7
            newParagraphSpacing = 15
        case .small:
            newLineSpacing = 5
            newParagraphSpacing = 10
        }
        
        updateSettings(
            lineSpacing: newLineSpacing,
            paragraphSpacing: newParagraphSpacing
        )
    }
    
    /// 翻页类型
    var effectType: DZMEffectType {return DZMEffectType(rawValue: settings.effectIndex) ?? .cover}
    
    /// 阅读进度类型
    /// - Note:
    ///   - 支持分页进度和总文章进度（网络文章也适用）
    ///   - 使用总文章进度时，需要提供整本书的章节总数，以及当前章节从0开始的索引
    ///   - 如需在拖动底部进度条时显示章节名，需要提供章节列表数据，并修改 RMProgressView 中 ASValueTrackingSliderDataSource 的返回值为章节名
    var progressType: DZMProgressType {
        return DZMProgressType(rawValue: settings.progressIndex) ?? .page  // 提供默认值
    }
    
    var titlePositionType: DZMTitlePositionType {
        return DZMTitlePositionType(rawValue: settings.titlePositionIndex) ?? .center
    }
    
    
    /// 获取文本属性
    /// - Parameters:
    ///   - isTitle: 是否为标题
    ///   - isPaging: 为true时只返回分页相关属性（不包含UIColor等无法比较的属性）
    /// - Returns: 文本属性字典
    func attributes(isTitle: Bool, isPaging: Bool = false) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.0
        
        if isTitle {
            paragraphStyle.lineSpacing = 0
            paragraphStyle.paragraphSpacing = settings.titleContentSpacing
            paragraphStyle.alignment = settings.titlePositionIndex == 0 ? .left : settings.titlePositionIndex == 1 ? .center : .right
        } else {
            paragraphStyle.lineSpacing = settings.lineSpacing
            paragraphStyle.lineBreakMode = .byCharWrapping
            paragraphStyle.paragraphSpacing = settings.paragraphSpacing
            // paragraphStyle.firstLineHeadIndent = settings.firstLineHeadIndent
            paragraphStyle.alignment = .justified
        }
        
        let font = isTitle ? settings.currentTitleFont : settings.currentFont
        
        if isPaging {
            return [
                .font: font,
                .kern: letterSpacing,
                .paragraphStyle: paragraphStyle
            ]
        } else {
            return [
                .font: font,
                .kern: letterSpacing,
                .paragraphStyle: paragraphStyle
            ]
        }
    }
    
    // MARK: - 基本设置访问属性
    /// 是否启用翻页动画
    var pageAnimationEnabled: Bool { settings.pageAnimationEnabled }
    /// 是否跟随系统深色模式
    var followSystemDarkMode: Bool { settings.followSystemDarkMode }
    /// 是否启用深色模式
    var darkModeEnabled: Bool { settings.darkModeEnabled }
    /// 是否保持屏幕常亮
    var keepScreenOn: Bool { settings.keepScreenOn }
    /// 是否继续上次阅读
    var continueLastRead: Bool { settings.continueLastRead }
    /// 是否启用音量键翻页
    var volumePageTurn: Bool { settings.volumePageTurn }
    /// 字体选择（0: 原文, 1: 简体, 2: 繁体）
    var selectedFont: Int { settings.selectedFont }
    
    // MARK: - 菜单设置访问属性
    /// 导航菜单样式选项索引
    var navigationMenuOption: Int { settings.navigationMenuOption }
    /// 底部菜单滑动条选项索引
    var bottomBarOption: Int { settings.bottomBarOption }
    /// 退出动画选项索引
    var exitAnimationOption: Int { settings.exitAnimationOption }
    /// 底部小横条选项索引
    var bottomStripOption: Int { settings.bottomStripOption }
    /// 滑动退出选项索引
    var slideToExitOption: Int { settings.slideToExitOption }
    // MARK: - 附加设置访问属性
    /// 是否同步上下组件字体
    var fontSync: Bool { settings.fontSync }
    /// 是否显示状态栏
    var showStatusBar: Bool { settings.showStatusBar }
    /// 是否启用长按手势
    var longPressGesture: Bool { settings.longPressGesture }
    
    /// 安全区域边距
    var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first?.safeAreaInsets ?? .zero
    }
    /// 更新阅读设置
    /// - Parameters:
    ///   - pageAnimationEnabled: 是否启用翻页动画
    ///   - followSystemDarkMode: 是否跟随系统深色模式
    ///   - darkModeEnabled: 是否启用深色模式
    ///   - keepScreenOn: 是否保持屏幕常亮
    ///   - continueLastRead: 是否继续上次阅读
    ///   - volumePageTurn: 是否启用音量键翻页
    ///   - selectedFont: 字体选择（0: 原文, 1: 简体, 2: 繁体）
    ///   - navigationMenuOption: 导航菜单样式选项索引
    ///   - bottomBarOption: 底部菜单滑动条选项索引
    ///   - exitAnimationOption: 退出动画选项索引
    ///   - bottomStripOption: 底部小横条选项索引
    ///   - slideToExitOption: 滑动退出选项索引
    ///   - fontSync: 是否同步上下组件字体
    ///   - showStatusBar: 是否显示状态栏
    ///   - longPressGesture: 是否启用长按手势
    func updateReaderSettings(
        pageAnimationEnabled: Bool? = nil,
        followSystemDarkMode: Bool? = nil,
        darkModeEnabled: Bool? = nil,
        keepScreenOn: Bool? = nil,
        continueLastRead: Bool? = nil,
        volumePageTurn: Bool? = nil,
        selectedFont: Int? = nil,
        navigationMenuOption: Int? = nil,
        bottomBarOption: Int? = nil,
        exitAnimationOption: Int? = nil,
        bottomStripOption: Int? = nil,
        slideToExitOption: Int? = nil,
        fontSync: Bool? = nil,
        showStatusBar: Bool? = nil,
        longPressGesture: Bool? = nil
    ) {
        var newSettings = settings
        
        // 基本设置
        if let pageAnimationEnabled = pageAnimationEnabled {
            newSettings.pageAnimationEnabled = pageAnimationEnabled
        }
        if let followSystemDarkMode = followSystemDarkMode {
            newSettings.followSystemDarkMode = followSystemDarkMode
        }
        if let darkModeEnabled = darkModeEnabled {
            newSettings.darkModeEnabled = darkModeEnabled
        }
        if let keepScreenOn = keepScreenOn {
            newSettings.keepScreenOn = keepScreenOn
        }
        if let continueLastRead = continueLastRead {
            newSettings.continueLastRead = continueLastRead
        }
        if let volumePageTurn = volumePageTurn {
            newSettings.volumePageTurn = volumePageTurn
        }
        if let selectedFont = selectedFont {
            newSettings.selectedFont = selectedFont
        }
        
        // 菜单设置
        if let navigationMenuOption = navigationMenuOption {
            newSettings.navigationMenuOption = navigationMenuOption
        }
        if let bottomBarOption = bottomBarOption {
            newSettings.bottomBarOption = bottomBarOption
        }
        if let exitAnimationOption = exitAnimationOption {
            newSettings.exitAnimationOption = exitAnimationOption
        }
        if let bottomStripOption = bottomStripOption {
            newSettings.bottomStripOption = bottomStripOption
        }
        if let slideToExitOption = slideToExitOption {
            newSettings.slideToExitOption = slideToExitOption
        }
        
        // 附加设置
        if let fontSync = fontSync {
            newSettings.fontSync = fontSync
        }
        if let showStatusBar = showStatusBar {
            newSettings.showStatusBar = showStatusBar
        }
        if let longPressGesture = longPressGesture {
            newSettings.longPressGesture = longPressGesture
        }
        
        settings = newSettings
    }
    
    
    func updateSettings(
        fontSize: CGFloat? = nil,
        titleFontSize: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        fontWeight: UIFont.Weight? = nil,
        letterSpacing: CGFloat? = nil,
        firstLineHeadIndent: CGFloat? = nil,
        pageInsets: UIEdgeInsets? = nil,
        headerHeight: CGFloat? = nil,
        footerHeight: CGFloat? = nil,
        titleContentSpacing: CGFloat? = nil,
        effectIndex: Int? = nil,
        progressIndex: Int? = nil,
        titlePositionIndex: Int? = nil
    ) {
        var newSettings = settings
        
        if let fontSize = fontSize {
            newSettings.fontSize = fontSize
        }
        if let titleFontSize = titleFontSize {
            newSettings.titleFontSize = titleFontSize
        }
        if let lineSpacing = lineSpacing {
            newSettings.lineSpacing = lineSpacing
        }
        if let paragraphSpacing = paragraphSpacing {
            newSettings.paragraphSpacing = paragraphSpacing
        }
        if let fontWeight = fontWeight {
            newSettings.fontWeight = fontWeight
        }
        if let letterSpacing = letterSpacing {
            newSettings.letterSpacing = letterSpacing
        }
        if let firstLineHeadIndent = firstLineHeadIndent {
            newSettings.firstLineHeadIndent = firstLineHeadIndent
        }
        if let pageInsets = pageInsets {
            newSettings.updateInsets(pageInsets)
        }
        if let headerHeight = headerHeight {
            newSettings.headerHeight = headerHeight
        }
        if let footerHeight = footerHeight {
            newSettings.footerHeight = footerHeight
        }
        if let titleContentSpacing = titleContentSpacing {
            newSettings.titleContentSpacing = titleContentSpacing
        }
        if let effectIndex = effectIndex {
            newSettings.effectIndex = effectIndex
        }
        //        if let openLongPress = openLongPress {
        //            newSettings.openLongPress = openLongPress
        //        }
        if let progressIndex = progressIndex {
            newSettings.progressIndex = progressIndex
        }
        if let titlePositionIndex = titlePositionIndex {
            newSettings.titlePositionIndex = titlePositionIndex
        }
        
        settings = newSettings
//        ReaderNotification.postPageReloadUpdate()
    }
    
    
//    func updateEyeProtectionSettings(
//        eyeProtectionEnabled: Bool? = nil,
//        harmfulLightFilter: Int? = nil,
//        backLightReduction: Int? = nil
//    ) {
//        var newSettings = settings
//        
//        if let eyeProtectionEnabled = eyeProtectionEnabled {
//            newSettings.eyeProtectionEnabled = eyeProtectionEnabled
//        }
//        if let harmfulLightFilter = harmfulLightFilter {
//            newSettings.harmfulLightFilter = harmfulLightFilter
//        }
//        if let backLightReduction = backLightReduction {
//            newSettings.backLightReduction = backLightReduction
//        }
//        
//        settings = newSettings
//        EyeCareManager.shared.applyEyeProtectionSettings(
//            eyeProtectionEnabled: settings.eyeProtectionEnabled,
//            harmfulLightFilter: settings.harmfulLightFilter,
//            backLightReduction: settings.backLightReduction
//        )
//    }
    
    // MARK: - 组件设置访问属性
    /// 页眉组件选择
    var headerComponents: [Set<String>] { settings.headerComponents }
    /// 页脚组件选择
    var footerComponents: [Set<String>] { settings.footerComponents }
    
    /// 更新组件设置
    /// - Parameters:
    ///   - headerComponents: 页眉组件选择
    ///   - footerComponents: 页脚组件选择
    func updateComponentSettings(
        headerComponents: [Set<String>]? = nil,
        footerComponents: [Set<String>]? = nil
    ) {
        var newSettings = settings
        
        if let headerComponents = headerComponents {
            newSettings.headerComponents = headerComponents
        }
        if let footerComponents = footerComponents {
            newSettings.footerComponents = footerComponents
        }
        
        settings = newSettings
    }
}
