//
//  ReadHomeView.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/5/7.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class ReadHomeView: UIView {
    
    /// 书籍名称
    private var name:UILabel!
    
    /// 当前阅读模型
    var readModel:ReadModel! {
        
        didSet{
            name.text = readModel.bookName
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书籍名称
        name = UILabel()
        name.textAlignment = .center
        name.font = UIFont.boldSystemFont(ofSize: 40)
        name.textColor = UIColor(.black)
        addSubview(name)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        name.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
