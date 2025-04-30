//
//  ReadHomeViewCell.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/5/7.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class ReadHomeViewCell: UITableViewCell {

    /// 书籍首页视图
    private(set) var homeView:ReadHomeView!
    
    class func cell(_ tableView:UITableView) ->ReadHomeViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadHomeViewCell")
        
        if cell == nil {
            
            cell = ReadHomeViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadHomeViewCell")
        }
        
        return cell as! ReadHomeViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书籍首页
        homeView = ReadHomeView()
        contentView.addSubview(homeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        homeView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
