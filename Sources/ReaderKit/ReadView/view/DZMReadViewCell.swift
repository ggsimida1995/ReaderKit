//
//  DZMReadViewCell.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class ReadViewCell: UITableViewCell {

    /// 阅读视图
    private var readView:ReadView!
    
    var pageModel:ReadPageModel! {
        
        didSet{
            
            readView.pageModel = pageModel
            
            setNeedsLayout()
        }
    }
    
    class func cell(_ tableView:UITableView) ->ReadViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMReadViewCell")
        
        if cell == nil {
            
            cell = ReadViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DZMReadViewCell")
        }
        
        return cell as! ReadViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 阅读视图
        readView = ReadView()
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
      
        // 分页顶部高度
        let y = pageModel?.headTypeHeight ?? 0.01
        
        // 内容高度
        let h = pageModel?.contentSize.height ?? 0.01

        readView.frame = CGRect(x: 0, y: y, width: DZM_READ_VIEW_RECT.width, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
