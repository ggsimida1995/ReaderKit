// //
// //  DZMReadConfigure.swift
// //  DZMeBookRead
// //
// //  Created by dengzemiao on 2019/4/17.
// //  Copyright © 2019年 DZM. All rights reserved.
// //

// import UIKit

// /// 一切为了好玩 》》》》》
// ///// 主题颜色
// //var DZM_READ_COLOR_MAIN:UIColor { return DZM_COLOR_ARC } // DZM_COLOR_253_85_103
// //
// ///// 菜单默认颜色
// //var DZM_READ_COLOR_MENU_COLOR:UIColor { return DZM_COLOR_ARC } // DZM_COLOR_235_235_235
// //
// ///// 菜单背景颜色
// //var DZM_READ_COLOR_MENU_BG_COLOR:UIColor { return DZM_COLOR_ARC.withAlphaComponent(0.95) } // UIColor.black.withAlphaComponent(0.95)
// /// 一切为了好玩 》》》》》

// /// 主题颜色
// var DZM_READ_COLOR_MAIN:UIColor = DZM_COLOR_253_85_103

// /// 菜单默认颜色
// var DZM_READ_COLOR_MENU_COLOR:UIColor = DZM_COLOR_230_230_230

// /// 菜单背景颜色
// var DZM_READ_COLOR_MENU_BG_COLOR:UIColor = DZM_COLOR_46_46_46.withAlphaComponent(0.95)

// /// 阅读背景颜色列表
// let DZM_READ_BG_COLORS:[UIColor] = [UIColor.white, DZM_COLOR_238_224_202, DZM_COLOR_205_239_205, DZM_COLOR_206_233_241, DZM_COLOR_58_52_54, DZM_COLOR_BG_0]

// /// 阅读字体颜色列表
// /// let DZM_READ_TEXT_COLORS:[UIColor] = [DZM_COLOR_145_145_145]

// /// 阅读状态栏字体颜色列表
// /// let DZM_READ_STATUS_TEXT_COLORS:[UIColor] = [DZM_COLOR_145_145_145]

// /// 阅读最小阅读字体大小
// let DZM_READ_FONT_SIZE_MIN:NSInteger = 12

// /// 阅读最大阅读字体大小
// let DZM_READ_FONT_SIZE_MAX:NSInteger = 50

// /// 阅读默认字体大小
// let DZM_READ_FONT_SIZE_DEFAULT:NSInteger = 22

// // /// 阅读字体大小叠加指数
// let DZM_READ_FONT_SIZE_SPACE:NSInteger = 1

// // /// 章节标题 - 在当前字体大小上叠加指数
// let DZM_READ_FONT_SIZE_SPACE_TITLE:NSInteger = 1

// /// 阅读标题最小字体大小
// let DZM_READ_FONT_SIZE_MIN_TITLE:NSInteger = 10

// /// 阅读标题最大字体大小
// let DZM_READ_FONT_SIZE_MAX_TITLE:NSInteger = 50

// /// 阅读标题默认字体大小
// let DZM_READ_FONT_SIZE_DEFAULT_TITLE:NSInteger = 26

// /// 标题间距最小
// let DZM_READ_TITLE_SPACING_MIN:NSInteger = -5

// /// 标题间距最大
// let DZM_READ_TITLE_SPACING_MAX:NSInteger = 50

// /// 标题间距默认
// let DZM_READ_TITLE_SPACING_DEFAULT:NSInteger = 26



// /// 首行缩进最小字符数
// let DZM_READ_PARAGRAPH_SPACING_MIN:NSInteger = 0

// /// 首行缩进最大字符数
// let DZM_READ_PARAGRAPH_SPACING_MAX:NSInteger = 8

// /// 首行缩进默认字符数
// let DZM_READ_PARAGRAPH_SPACING_DEFAULT:NSInteger = 2

// /// 字间距最小
// let DZM_READ_SPACING_MIN:NSInteger = -15

// /// 字间距最大
// let DZM_READ_SPACING_MAX:NSInteger = 50

// /// 字间距默认
// let DZM_READ_SPACING_DEFAULT:NSInteger = 0

// /// 行间距最小
// let DZM_READ_LINE_SPACING_MIN:NSInteger = -20

// /// 行间距最大
// let DZM_READ_LINE_SPACING_MAX:NSInteger = 50

// /// 行间距默认
// let DZM_READ_LINE_SPACING_DEFAULT:NSInteger = 8

// ///// 段落间距最小
// //let DZM_READ_PARAGRAPH_SPACING_MIN:NSInteger = -5
// //
// ///// 段落间距最大
// //let DZM_READ_PARAGRAPH_SPACING_MAX:NSInteger = 50
// //
// ///// 段落间距默认
// //let DZM_READ_PARAGRAPH_SPACING_DEFAULT:NSInteger = 15


// /// 页面边距左边距最小
// let DZM_READ_PAGE_MARGIN_LEFT_MIN:NSInteger = 0

// /// 页面边距左边距最大
// let DZM_READ_PAGE_MARGIN_LEFT_MAX:NSInteger = 100

// /// 页面边距左边距默认
// let DZM_READ_PAGE_MARGIN_LEFT_DEFAULT:NSInteger = 20

// /// 页面边距右边距最小
// let DZM_READ_PAGE_MARGIN_RIGHT_MIN:NSInteger = 0

// /// 页面边距右边距最大
// let DZM_READ_PAGE_MARGIN_RIGHT_MAX:NSInteger = 100

// /// 页面边距右边距默认
// let DZM_READ_PAGE_MARGIN_RIGHT_DEFAULT:NSInteger = 20


// /// 上边距（滚动无效果）最小
// let DZM_READ_PAGE_MARGIN_TOP_MIN:NSInteger = 0

// /// 上边距（滚动无效果）最大
// let DZM_READ_PAGE_MARGIN_TOP_MAX:NSInteger = 537

// /// 上边距（滚动无效果）默认
// let DZM_READ_PAGE_MARGIN_TOP_DEFAULT:NSInteger = 10


// /// 下边距（滚动无效果）最小
// let DZM_READ_PAGE_MARGIN_BOTTOM_MIN:NSInteger = 0

// /// 下边距（滚动无效果）最大
// let DZM_READ_PAGE_MARGIN_BOTTOM_MAX:NSInteger = 537

// /// 下边距（滚动无效果）默认
// let DZM_READ_PAGE_MARGIN_BOTTOM_DEFAULT:NSInteger = 10

// /// 页眉上下位置最小
// let DZM_READ_PAGE_MARGIN_HEADER_MIN:NSInteger = 0

// /// 页眉上下位置最大
// let DZM_READ_PAGE_MARGIN_HEADER_MAX:NSInteger = 84

// /// 页眉上下位置默认
// let DZM_READ_PAGE_MARGIN_HEADER_DEFAULT:NSInteger = 49

// /// 页脚位置最小
// let DZM_READ_PAGE_MARGIN_FOOTER_MIN:NSInteger = 0

// /// 页脚位置最大
// let DZM_READ_PAGE_MARGIN_FOOTER_MAX:NSInteger = 60

// /// 页脚位置默认
// let DZM_READ_PAGE_MARGIN_FOOTER_DEFAULT:NSInteger = 20





// /// 单利对象
// private var configure:DZMReadConfigure?

// class DZMReadConfigure: NSObject {
    
//     // MARK: 阅读页面配置
    
//     /// 开启长按菜单功能 (滚动模式是不支持长按功能的)
//     var openLongPress:Bool = true
    
    
//     // MARK: 阅读内容配置
    
//     /// 背景颜色索引
//     @objc var bgColorIndex:NSNumber!
    
//     /// 字体类型索引
//     @objc var fontIndex:NSNumber!
    
//     /// 翻页类型索引
//     @objc var effectIndex:NSNumber!
    
//     /// 间距类型索引
//     @objc var spacingIndex:NSNumber!
    
//     /// 进度显示索引
//     @objc var progressIndex:NSNumber!
    
//     /// 字体大小
//     @objc var fontSize:NSNumber!
    
//     /// 标题字体大小
//     @objc var fontSizeTitle:NSNumber!
    

//     // MARK: 快捷获取
    
//     /// 使用分页进度 || 总文章进度(网络文章也可以使用)
//     /// 总文章进度注意: 总文章进度需要有整本书的章节总数,以及当前章节带有从0开始排序的索引。
//     /// 如果还需要在拖拽底部功能条上进度条过程中展示章节名,则需要带上章节列表数据,并去 DZMRMProgressView 文件中找到 ASValueTrackingSliderDataSource 修改返回数据源为章节名。
//     var progressType:DZMProgressType! { return DZMProgressType(rawValue: progressIndex.intValue) }
    
//     /// 翻页类型
//     var effectType:DZMEffectType! { return DZMEffectType(rawValue: effectIndex.intValue) }
    
//     /// 字体类型
//     var fontType:DZMFontType! { return DZMFontType(rawValue: fontIndex.intValue) }
    
//     /// 间距类型
//     var spacingType:DZMSpacingType! { return DZMSpacingType(rawValue: spacingIndex.intValue) }
    
//     /// 背景颜色
//     var bgColor:UIColor! {
        
//         if bgColorIndex.intValue == DZM_READ_BG_COLORS.firstIndex(of: DZM_COLOR_BG_0) { // 牛皮黄背景
            
//             return UIColor(patternImage: UIImage(named: "read_bg_0")!)
            
//         }else{
            
//             return DZM_READ_BG_COLORS[bgColorIndex.intValue]
//         }
//     }
    
//     /// 字体颜色
//     var textColor:UIColor! {
        
//         // 固定颜色
//         return DZM_COLOR_145_145_145
    
//         // 根据背景颜色选择
// //        return DZM_READ_TEXT_COLORS[bgColorIndex.intValue]
        
//         // 字体颜色列表选择
// //        return DZM_READ_TEXT_COLORS[textColorIndex.intValue]
        
//         // 日夜间切换
// //         if DZMUserDefaults.bool(DZM_READ_KEY_MODE_DAY_NIGHT) {
// //
// //            return DZM_COLOR_145_145_145
// //
// //         }else{ return DZM_COLOR_145_145_145 }
//     }
    
//     /// 状态栏字体颜色
//     var statusTextColor:UIColor! {
        
//         // 固定颜色
//         return DZM_COLOR_145_145_145
        
//         // 根据背景颜色选择
// //        return DZM_READ_STATUS_TEXT_COLORS[bgColorIndex.intValue]
        
//         // 字体颜色列表选择
// //         return DZM_READ_STATUS_TEXT_COLORS[statusTextColorIndex.intValue]
        
//         // 日夜间切换
// //         if DZMUserDefaults.bool(DZM_READ_KEY_MODE_DAY_NIGHT) {
// //
// //            return DZM_COLOR_145_145_145
// //
// //         }else{ return DZM_COLOR_145_145_145 }
//     }
    
//     /// 行间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
//     var lineSpacing:CGFloat! {
    
//         if spacingType == .big { // 大间距
            
//             return DZM_SPACE_10
            
//         }else if spacingType == .middle { // 中间距
            
//             return DZM_SPACE_7
            
//         }else{ // 小间距
            
//             return DZM_SPACE_5
//         }
//     }
    
//     /// 段间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
//     var paragraphSpacing:CGFloat {
        
//         if spacingType == .big { // 大间距
            
//             return DZM_SPACE_20
            
//         }else if spacingType == .middle { // 中间距
            
//             return DZM_SPACE_15
            
//         }else{ // 小间距
            
//             return DZM_SPACE_10
//         }
//     }
    
//     /// 阅读字体
//     func font(isTitle:Bool = false) ->UIFont {
        
//         let size = SA_SIZE(CGFloat(isTitle ? fontSizeTitle.intValue : fontSize.intValue))
        
//         let fontType = self.fontType
        
//         if fontType == .one { // 黑体
            
//             return UIFont(name: "EuphemiaUCAS-Italic", size: size)!
            
//         }else if fontType == .two { // 楷体
            
//             return UIFont(name: "AmericanTypewriter-Light", size: size)!
            
//         }else if fontType == .three { // 宋体
            
//             return UIFont(name: "Papyrus", size: size)!
            
//         }else{ // 系统
            
//             return UIFont.systemFont(ofSize: size)
//         }
//     }
    
//     /// 字体属性
//     /// isPaging: 为YES的时候只需要返回跟分页相关的属性即可 (原因:包含UIColor,小数点相关的...不可返回,因为无法进行比较)
//      func attributes(isTitle:Bool, isPageing:Bool = false) ->[NSAttributedString.Key:Any] {
        
//         // 段落配置
//         let paragraphStyle = NSMutableParagraphStyle()
        
//         // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
//         paragraphStyle.lineHeightMultiple = 1.0
        
//         if isTitle {
            
//             // 行间距
//             paragraphStyle.lineSpacing = 0
            
//             // 段间距
//             paragraphStyle.paragraphSpacing = 0
            
//             // 对其
//             paragraphStyle.alignment = .center
            
//         }else{
            
//             // 行间距
//             paragraphStyle.lineSpacing = lineSpacing
            
//             // 换行模式（避免每页尾部留空白）
//             paragraphStyle.lineBreakMode = .byCharWrapping
// //            paragraphStyle.lineBreakMode = .byWordWrapping
            
//             // 段间距
//             paragraphStyle.paragraphSpacing = paragraphSpacing
            
//             // 对其
//             paragraphStyle.alignment = .justified
//         }
// //         let textColor = UIColor(hexString: ReaderThemeManager.shared.readBG)
//         let textColor = UIColor(hexString: ReaderThemeManager.shared.readFont)
//         // let titleattributes: [NSAttributedString.Key: Any] = [
//         //     .font: readerLayoutSettingsPublic.settings.currentTitleFont,
//         //     .paragraphStyle: titleStyle,
//         //     .kern: readerLayoutSettingsPublic.settings.letterSpacing,
//         //     .foregroundColor: textColor
//         // ]
        
//         if isPageing {
            
//             return [.font: font(isTitle: isTitle), .paragraphStyle: paragraphStyle, .foregroundColor: textColor]
            
//         }else{
            
//             return [.foregroundColor: textColor, .font: font(isTitle: isTitle), .paragraphStyle: paragraphStyle]
//         }
//     }
    
    
//     // MARK: 辅助
    
//     /// 保存(使用 DZMUserDefaults 存储是方便配置修改)
//     func save() {
        
//         let dict = ["bgColorIndex": bgColorIndex,
//                     "fontIndex": fontIndex,
//                     "effectIndex": effectIndex,
//                     "spacingIndex": spacingIndex,
//                     "progressIndex": progressIndex,
//                     "fontSize": fontSize]
    
//         DZMUserDefaults.setObject(dict, DZM_READ_KEY_CONFIGURE)
//     }
    
    
//     // MARK: 构造
    
//     /// 获取对象
//     class func shared() ->DZMReadConfigure {
        
//         if configure == nil { configure = DZMReadConfigure(DZMUserDefaults.object(DZM_READ_KEY_CONFIGURE)) }
        
//         return configure!
//     }
    
//     init(_ dict:Any? = nil) {
        
//         super.init()
  
//         if dict != nil { setValuesForKeys(dict as! [String : Any]) }
        
//         initData()
//     }
    
//     /// 初始化配置数据,以及处理初始化数据的增删
//     private func initData() {
        
//         // 背景
//         if (bgColorIndex == nil) || (bgColorIndex.intValue >= DZM_READ_BG_COLORS.count) {
            
//             bgColorIndex = NSNumber(value: DZM_READ_BG_COLORS.index(of: DZM_COLOR_BG_0) ?? 0)
//         }
        
//         // 字体类型
//         if (fontIndex == nil) || (DZMFontType(rawValue: fontIndex.intValue) == nil) {
            
//             fontIndex = NSNumber(value: DZMFontType.two.rawValue)
//         }
        
//         // 间距类型
//         if (spacingIndex == nil) || (DZMSpacingType(rawValue: spacingIndex.intValue) == nil) {
            
//             spacingIndex = NSNumber(value: DZMSpacingType.small.rawValue)
//         }
        
//         // 翻页类型
//         if (effectIndex == nil) || (DZMEffectType(rawValue: effectIndex.intValue) == nil) {
            
//             effectIndex = NSNumber(value: DZMEffectType.simulation.rawValue)
//         }
        
//         // 正文字体大小
//         if (fontSize == nil) || (fontSize.intValue > DZM_READ_FONT_SIZE_MAX || fontSize.intValue < DZM_READ_FONT_SIZE_MIN) {
            
//             fontSize = NSNumber(value: DZM_READ_FONT_SIZE_DEFAULT)
//         }
//         /// 标题字体大小
//         if (fontSizeTitle == nil) || (fontSizeTitle.intValue > DZM_READ_FONT_SIZE_MAX_TITLE || fontSizeTitle.intValue < DZM_READ_FONT_SIZE_MIN_TITLE) {
            
//             fontSizeTitle = NSNumber(value: DZM_READ_FONT_SIZE_DEFAULT_TITLE)
//         }
        
//         // 显示进度类型
//         if (progressIndex == nil) || (DZMProgressType(rawValue: progressIndex.intValue) == nil) {
            
//             progressIndex = NSNumber(value: DZMProgressType.page.rawValue)
//         }
//     }
    
//     class func model(_ dict:Any?) ->DZMReadConfigure  { return DZMReadConfigure(dict) }
    
//     override func setValue(_ value: Any?, forUndefinedKey key: String) { }
// }
