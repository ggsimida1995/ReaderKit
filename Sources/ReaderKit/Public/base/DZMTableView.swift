//
//  TableView.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class TableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        
        super.init(frame: frame, style: style)
        
        backgroundColor = UIColor.clear
        
        separatorStyle = .none
        
        if #available(iOS 11.0, *) {
            
            contentInsetAdjustmentBehavior = .never
            estimatedRowHeight = 0
            estimatedSectionFooterHeight = 0
            estimatedSectionHeaderHeight = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
