//
//  ReadPageModel.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class ReadPageModel: NSObject, NSCoding {

    // MARK: 常用属性
    
    /// 当前页内容
    var content: NSAttributedString = NSAttributedString()
    
    /// 当前页范围
    var range: NSRange = NSRange()
    
    /// 当前页序号
    var page: Int = 0
    
    
    // MARK: 滚动模式使用
    
    /// 根据开头类型返回开头高度 (目前主要是滚动模式使用)
    var headTypeHeight: CGFloat = 0
    
    /// 当前内容Size (目前主要是(滚动模式 || 长按模式)使用)
    var contentSize: CGSize = .zero
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    var headTypeIndex: Int = 0
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    var headType: PageHeadType {
        get { PageHeadType(rawValue: headTypeIndex)! }
        set { headTypeIndex = newValue.rawValue }
    }
    
    /// 当前内容总高(cell 高度)
    var cellHeight: CGFloat {
        // 内容高度 + 头部高度
        return contentSize.height + headTypeHeight
    }
    
    
    // MARK: 快捷获取
    
    /// 书籍首页
    var isHomePage: Bool {
        return range.location == DZM_READ_BOOK_HOME_PAGE
    }
    
    /// 获取显示内容(考虑可能会变换字体颜色的情况)
    var showContent: NSAttributedString {
        let textColor = UIColor(.black)
        let tempShowContent = NSMutableAttributedString(attributedString: content)
        tempShowContent.addAttributes([.foregroundColor : textColor], range: NSRange(location: 0, length: content.length))
        return tempShowContent
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        content = aDecoder.decodeObject(forKey: "content") as? NSAttributedString ?? NSAttributedString()
        range = aDecoder.decodeObject(forKey: "range") as? NSRange ?? NSRange()
        page = aDecoder.decodeInteger(forKey: "page")
        headTypeHeight = aDecoder.decodeDouble(forKey: "headTypeHeight")
        contentSize = aDecoder.decodeObject(forKey: "contentSize") as? CGSize ?? .zero
        headTypeIndex = aDecoder.decodeInteger(forKey: "headTypeIndex")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(range, forKey: "range")
        aCoder.encode(page, forKey: "page")
        aCoder.encode(headTypeHeight, forKey: "headTypeHeight")
        aCoder.encode(contentSize, forKey: "contentSize")
        aCoder.encode(headTypeIndex, forKey: "headTypeIndex")
    }
    
    init(_ dict: [String: Any]? = nil) {
        super.init()
        
        if let dict = dict {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
