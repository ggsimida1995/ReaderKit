//
//  ReadController+EffectType.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

extension ReadController {

    /// 创建阅读视图
    func creatPageController(displayController: ReadViewController? = nil) {
        
        // 清理
        clearPageController()
        
        // 翻页类型
        let effectType = ReaderLayoutManager.shared.effectType
   
        // 创建
        if effectType == .simulation { // 仿真
            
            guard let displayController = displayController else { return }
            
            // 创建
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            
            pageViewController = PageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
            
            // 自定义tap手势的相关代理
            pageViewController.aDelegate = self
            
            pageViewController.delegate = self
            
            pageViewController.dataSource = self
            
            contentView.insertSubview(pageViewController.view, at: 0)
            
            pageViewController.view.backgroundColor = UIColor.clear
            
            pageViewController.view.frame = contentView.bounds
            
            // 翻页背部带文字效果
            pageViewController.isDoubleSided = true
            
            pageViewController.setViewControllers([displayController], direction: .forward, animated: false, completion: nil)
            
        } else if effectType == .hTranslation || effectType == .vTranslation { // 平移
            
            if displayController == nil { return }
            
            // 创建
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            
            pageViewController = PageViewController(transitionStyle: .scroll,navigationOrientation: effectType == .hTranslation ? .horizontal : .vertical,options: options)
            
            // 自定义tap手势的相关代理
            pageViewController.aDelegate = self
            
            pageViewController.delegate = self
            
            pageViewController.dataSource = self
            
            contentView.insertSubview(pageViewController.view, at: 0)
            
            pageViewController.view.backgroundColor = UIColor.clear
            
            pageViewController.view.frame = contentView.bounds
            
            pageViewController.setViewControllers((displayController != nil ? [displayController!] : nil), direction: .forward, animated: false, completion: nil)
            
        } else if effectType == .scroll { // 滚动
            
            scrollController = ReadViewScrollController()
            
            scrollController.vc = self
            
            contentView.insertSubview(scrollController.view, at: 0)
            
            scrollController.view.frame = contentView.bounds
            
            scrollController.view.backgroundColor = UIColor.clear
            
            addChild(scrollController)
            
        } else { // 覆盖 无效果
            
            guard let displayController = displayController else { return }
           
            coverController = CoverController()
           
            coverController.delegate = self
           
            contentView.insertSubview(coverController.view, at: 0)
           
            coverController.view.frame = contentView.bounds
           
            coverController.view.backgroundColor = UIColor.clear
           
            coverController.setController(displayController)
           
            if ReaderLayoutManager.shared.effectType == .no {
                coverController.openAnimate = false
            }
        }
        
        // 记录
        currentDisplayController = displayController
    }
    
    /// 清理所有阅读控制器
    func clearPageController() {
        
        currentDisplayController?.removeFromParent()
        currentDisplayController = nil
        
        if let pageViewController = pageViewController {
            pageViewController.view.removeFromSuperview()
            pageViewController.removeFromParent()
            self.pageViewController = nil
        }
        
        if let coverController = coverController {
            coverController.view.removeFromSuperview()
            coverController.removeFromParent()
            self.coverController = nil
        }
        
        if let scrollController = scrollController {
            scrollController.view.removeFromSuperview()
            scrollController.removeFromParent()
            self.scrollController = nil
        }
    }
    
    /// 手动设置翻页(注意: 非滚动模式调用)
    func setViewController(displayController: ReadViewController?, isAbove: Bool, animated: Bool) {
        guard let displayController = displayController else { return }
        
        // 仿真
        if let pageViewController = pageViewController {
            if (ReaderLayoutManager.shared.effectType == .hTranslation || ReaderLayoutManager.shared.effectType == .vTranslation) { // 平移
                let direction: UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                pageViewController.setViewControllers([displayController], direction: direction, animated: animated, completion: nil)
            } else { // 仿真
                let direction: UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                let bgController = GetReadViewBGController(recordModel: displayController.recordModel, targetView: displayController.view)
                pageViewController.setViewControllers([displayController, bgController], direction: direction, animated: animated, completion: nil)
            }
            return
        }
        
        // 覆盖 无效果
        if let coverController = coverController {
            coverController.setController(displayController, animated: animated, isAbove: isAbove)
            return
        }
        
        // 记录
        currentDisplayController = displayController
    }
    
    
    // MARK: -- CoverControllerDelegate
    
    /// 切换结果
    func coverController(_ coverController: CoverController, currentController: UIViewController?, finish isFinish: Bool) {
        // 记录
        currentDisplayController = currentController as? ReadViewController
        
        // 更新阅读记录
        if let controller = currentDisplayController {
            updateReadRecord(controller: controller)
        }
    }
    
    /// 将要显示的控制器
    func coverController(_ coverController: CoverController, willTransitionToPendingController pendingController: UIViewController?) {
        // 关闭菜单
        // readMenu.showMenu(isShow: false)
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: CoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return GetAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: CoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return GetBelowReadViewController()
    }
    
    
    // MARK: -- UIPageViewControllerDelegate
    
    /// 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // 记录
        currentDisplayController = pageViewController.viewControllers?.first as? ReadViewController
        
        // 更新阅读记录
        if let controller = currentDisplayController {
            updateReadRecord(controller: controller)
        }
    }
    
    /// 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // 关闭菜单
        // readMenu.showMenu(isShow: false)
    }
    
    // MARK: -- PageViewControllerDelegate
    
    /// 获取上一页
    func pageViewController(_ pageViewController: PageViewController, getViewControllerBefore viewController: UIViewController!) {
        // 获取上一页
        if let readViewController = GetAboveReadViewController() as? ReadViewController {
            // 手动设置
            setViewController(displayController: readViewController, isAbove: true, animated: true)
            
            // 更新阅读记录
            updateReadRecord(controller: readViewController)
            
            // 关闭菜单
            // readMenu.showMenu(isShow: false)
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: PageViewController, getViewControllerAfter viewController: UIViewController!) {
        // 获取下一页
        if let readViewController = GetBelowReadViewController() as? ReadViewController {
            // 手动设置
            setViewController(displayController: readViewController, isAbove: false, animated: true)
            
            // 更新阅读记录
            updateReadRecord(controller: readViewController)
            
            // 关闭菜单
            // readMenu.showMenu(isShow: false)
        }
    }
    
    // MARK: -- UIPageViewControllerDataSource
    
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (ReaderLayoutManager.shared.effectType == .hTranslation || ReaderLayoutManager.shared.effectType == .vTranslation) { // 平移
            return GetAboveReadViewController()
        } else { // 仿真
            // 翻页累计
            tempNumber -= 1
            
            // 获取当前页阅读记录
            var recordModel: ReadRecordModel?
            
            if let readViewController = viewController as? ReadViewController {
                recordModel = readViewController.recordModel
            } else if let bgController = viewController as? ReadViewBGController {
                recordModel = bgController.recordModel
            }
            
            guard let recordModel = recordModel else { return nil }
            
            if abs(tempNumber) % 2 == 0 { // 背面
                guard let aboveRecordModel = GetAboveReadRecordModel(recordModel: recordModel) else { return nil }
                return GetReadViewBGController(recordModel: aboveRecordModel)
            } else { // 内容
                return GetReadViewController(recordModel: recordModel)
            }
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (ReaderLayoutManager.shared.effectType == .hTranslation || ReaderLayoutManager.shared.effectType == .vTranslation) { // 平移
            return GetBelowReadViewController()
        } else { // 仿真
            // 翻页累计
            tempNumber += 1
            
            // 获取当前页阅读记录
            var recordModel: ReadRecordModel?
            
            if let readViewController = viewController as? ReadViewController {
                recordModel = readViewController.recordModel
            } else if let bgController = viewController as? ReadViewBGController {
                recordModel = bgController.recordModel
            }
            
            guard let recordModel = recordModel else { return nil }
            
            if abs(tempNumber) % 2 == 0 { // 背面
                return GetReadViewBGController(recordModel: recordModel)
            } else { // 内容
                guard let belowRecordModel = GetBelowReadRecordModel(recordModel: recordModel) else { return nil }
                return GetReadViewController(recordModel: belowRecordModel)
            }
        }
    }
}
