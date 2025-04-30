//
//  ViewController.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialize()
        
        addSubviews()
        
        addComplete()
    }
    
    func initialize() {
        
        view.backgroundColor = .clear
        
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) { } else {
            
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func addSubviews() { }
    
    func addComplete() { }
}
