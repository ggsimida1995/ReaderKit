//
//  ReadViewStatusTopView.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

class ReadViewStatusTopView: UIView {
    
    /// 左侧区域
    private var leftStackView: UIStackView!
    /// 中间区域
    private var centerStackView: UIStackView!
    /// 右侧区域
    private var rightStackView: UIStackView!
    
    /// 进度
    private(set) var progressLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    /// 电池
    private var batteryView: BatteryView!
    /// 页码
    private(set) var pageLabel: UILabel!
    /// 章节名
    private(set) var chapterLabel: UILabel!
    /// 书名
    private(set) var bookNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupObservers()
        
        // 设置页眉高度
        heightAnchor.constraint(equalToConstant: ReaderLayoutManager.shared.headerHeight).isActive = true
    }
    
    private func setupSubviews() {
        // 初始化左中右区域的 StackView
        leftStackView = createStackView()
        centerStackView = createStackView()
        rightStackView = createStackView()
        
        addSubview(leftStackView)
        addSubview(centerStackView)
        addSubview(rightStackView)
        
        // 初始化所有标签
        progressLabel = createLabel()
        timeLabel = createLabel()
        batteryView = BatteryView()
        batteryView.tintColor = UIColor(.black)
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        
        pageLabel = createLabel()
        chapterLabel = createLabel()
        bookNameLabel = createLabel()
        
        setupConstraints()
        updateHeaderComponents()
        
        // 初始化调用
        didChangeTime()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLayoutChange),
            name: .readerLayoutDidChange,
            object: nil
        )
    }
    
    @objc private func handleLayoutChange() {
        updateHeaderComponents()
    }
    
    private func updateHeaderComponents() {
        // 清除所有现有视图
        leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        centerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 获取当前页眉组件设置
        let headerComponents = ReaderLayoutManager.shared.headerComponents
        
        // 更新左侧组件
        for key in headerComponents[0] {
            if let view = createComponentView(for: key) {
                leftStackView.addArrangedSubview(view)
            }
        }
        
        // 更新中间组件
        for key in headerComponents[1] {
            if let view = createComponentView(for: key) {
                centerStackView.addArrangedSubview(view)
            }
        }
        
        // 更新右侧组件
        for key in headerComponents[2] {
            if let view = createComponentView(for: key) {
                rightStackView.addArrangedSubview(view)
            }
        }
    }
    
    /// 更新时间和电池状态
    @objc func didChangeTime() {
        timeLabel.text = TimerString("HH:mm")
        batteryView.batteryLevel = UIDevice.current.batteryLevel
    }
    
    private func createComponentView(for key: String) -> UIView? {
        switch key {
        case "chapterName": // 章节名
            return chapterLabel
        case "bookName": // 书名
            return bookNameLabel
        case "pageNumber": // 页码
            return pageLabel
        case "chapterProgress": // 章节进度
            return progressLabel
        case "time": // 时间
            return timeLabel
        case "battery": // 电量
            return batteryView
        default:
            return nil
        }
    }
    
    /// 创建 StackView
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加红色边框
        // stackView.layer.borderWidth = 1
        // stackView.layer.borderColor = UIColor.red.cgColor
        
        return stackView
    }
    
    /// 创建 Label
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// 约束布局
    private func setupConstraints() {
        let padding: CGFloat = 20
        let bottomPadding: CGFloat = 3
        
        NSLayoutConstraint.activate([
            // 左侧 StackView - 靠左
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            leftStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
            leftStackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            // 中间 StackView - 居中
            centerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
            centerStackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            // 右侧 StackView - 靠右
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            rightStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding),
            rightStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func addDashedLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(.black).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [4, 4] // 虚线的样式：4个点的线，4个点的间隔
        shapeLayer.fillColor = nil
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: bounds.height),
                              CGPoint(x: bounds.width, y: bounds.height)])
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 移除旧的虚线层
        layer.sublayers?.forEach { layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        // 根据设置决定是否添加虚线
//        if ReaderStateManager.shared.showHeaderFooterDashLine {
//            addDashedLine()
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
