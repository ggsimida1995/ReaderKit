//
//  ReadController.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

//CoverControllerDelegate,
class ReadController: ViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,PageViewControllerDelegate,CoverControllerDelegate,ReadContentViewDelegate {

    // MARK: 数据相关
    
    /// 阅读对象
    var readModel:ReadModel!
    
    
    // MARK: UI相关
    
    /// 阅读主视图
    var contentView:ReadContentView!
    
    /// 翻页控制器 (仿真)
    var pageViewController:PageViewController!
    
    /// 翻页控制器 (滚动)
    var scrollController:ReadViewScrollController!
    
    /// 翻页控制器 (无效果,覆盖)
    var coverController:CoverController!
    
    /// 非滚动模式时,当前显示 ReadViewController
    var currentDisplayController:ReadViewController?
    
    /// 用于区分正反面的值(勿动)
    var tempNumber:NSInteger = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 初始化书籍阅读记录
        updateReadRecord(recordModel: readModel.recordModel)
        
        // 初始化菜单
//       readMenu = ReadMenu(vc: self, delegate: self)
        
        // 背景颜色
        // view.backgroundColor = ReadConfigure.shared().bgColor
        view.backgroundColor = UIColor(.white)
        
        
        // 初始化控制器
        creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
        
        // 监控阅读长按视图通知
        monitorReadLongPressView()

         // 添加通知观察者
        ReaderNotification.addPageReloadUpdateObserver(self, selector: #selector(handlePageReloadUpdate))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }

    override func addSubviews() {
        
        super.addSubviews()
        
//        // 目录侧滑栏
//       leftView = ReadLeftView()
//       leftView.catalogView.readModel = readModel
//       leftView.catalogView.delegate = self
//       leftView.markView.readModel = readModel
//       leftView.markView.delegate = self
//       leftView.isHidden = true
//       view.addSubview(leftView)
//       leftView.frame = CGRect(x: -_READ_LEFT_VIEW_WIDTH, y: 0, width: _READ_LEFT_VIEW_WIDTH, height: _READ_LEFT_VIEW_HEIGHT)
//        
        // 阅读视图
        contentView = ReadContentView()
        contentView.delegate = self
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: _READ_CONTENT_VIEW_WIDTH, height: _READ_CONTENT_VIEW_HEIGHT)
    }
    
    // MARK: 监控阅读长按视图通知
    
    // 监控阅读长按视图通知
    private func monitorReadLongPressView() {
        
        if ReaderLayoutManager.shared.openLongPress {
            
            _READ_NOTIFICATION_MONITOR(target: self, action: #selector(longPressViewNotification(notification:)))
        }
    }

     @objc private func handlePageReloadUpdate(notification: Notification) {
        print("handlePageReloadUpdate")
         view.backgroundColor = UIColor(.white)
        creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
    }
    
    // 处理通知
    @objc private func longPressViewNotification(notification:Notification) {
        
        // 获得状态
        let info = notification.userInfo
        
        // 隐藏菜单
//       readMenu.showMenu(isShow: false)
        
        // 解析状态
        if info != nil && info!.keys.contains(_READ_KEY_LONG_PRESS_VIEW) {
            
            let isOpen = info![_READ_KEY_LONG_PRESS_VIEW] as! NSNumber
            
           coverController?.gestureRecognizerEnabled = isOpen.boolValue
            
            pageViewController?.gestureRecognizerEnabled = isOpen.boolValue
            
//           readMenu.singleTap.isEnabled = isOpen.boolValue
        }
    }
    
    
    // MARK: ReadCatalogViewDelegate
    
    /// 章节目录选中章节
//    func catalogViewClickChapter(catalogView: ReadCatalogView, chapterListModel: ReadChapterListModel) {
//        
//
//        
//        contentView.showCover(isShow: false)
//        
//        if readModel.recordModel.chapterModel.id == chapterListModel.id { return }
//        
//        GoToChapter(chapterID: chapterListModel.id)
//    }
    
    // MARK: ReadMarkViewDelegate
    
    /// 书签列表选中书签
//    func markViewClickMark(markView: ReadMarkView, markModel: ReadMarkModel) {
//        
////       showLeftView(isShow: false)
//        
//        contentView.showCover(isShow: false)
//        
//        GoToChapter(chapterID: markModel.chapterID, location: markModel.location.intValue)
//    }
    
    
    // MARK: ReadContentViewDelegate
    
    /// 点击遮罩
    func contentViewClickCover(contentView: ReadContentView) {
        
//       showLeftView(isShow: false)
    }
    
   // MARK: ReadMenuDelegate
    
    /// 菜单将要显示
//    func readMenuWillDisplay(readMenu: ReadMenu!) {
//        
//        // 检查当前内容是否包含书签
//        readMenu.topView.checkForMark()
//        
//        // 刷新阅读进度
////        readMenu.bottomView.progressView.reloadProgress()
//    }
    
    /// 点击返回
//    func readMenuClickBack(readMenu: ReadMenu!) {
//        
//        // 清空所有阅读缓存
//        // KeyedArchiver.clear()
//        
//        // 清空指定书籍缓存
//        KeyedArchiver.remove(folderName: readModel.bookID)
//        
//        // 移除 PageViewController，因为这个仿真模式的 UIPageViewController 不手动移除会照成内存泄漏，对象不释放
//        // 它需要提前手动移除，要不然会导致释放不了走不了 deinit() 函数
//        if (ReadConfigure.shared().effectType == .simulation) {
//            
//            clearPageController()
//        }
//        
//        // 清空坐标
//        _READ_RECORD_CURRENT_CHAPTER_LOCATION = nil
//        
//        // 返回
//        navigationController?.popViewController(animated: true)
//    }
    
    /// 点击书签
//    func readMenuClickMark(readMenu: ReadMenu!, topView: RMTopView!, markButton: UIButton!) {
//        
//        markButton.isSelected = !markButton.isSelected
//        
//        if markButton.isSelected { readModel.insetMark()
//            
//        }else{ _ = readModel.removeMark() }
//        
//        topView.updateMarkButton()
//    }
    
    /// 点击目录
//    func readMenuClickCatalogue(readMenu:ReadMenu!) {
//        
//        showLeftView(isShow: true)
//        
//        contentView.showCover(isShow: true)
//        
//        readMenu.showMenu(isShow: false)
//    }
    
    /// 点击日夜间
//   func readMenuClickDayAndNight() {
//       
//       // 日夜间可以根据需求判断修改目录背景颜色,文字颜色等等(目前放在showLeftView方法中,leftView将要出现的时候处理)
//       // leftView.updateUI()
//   }
    
    /// 点击上一章
//   func readMenuClickPreviousChapter() {
//       
//       if readModel.recordModel.isFirstChapter {
//           
//           Log("已经是第一章了")
//           
//       }else{
//           
//           GoToChapter(chapterID: readModel.recordModel.chapterModel.previousChapterID)
//           
//           // 检查当前内容是否包含书签
////           readMenu.topView.checkForMark()
//           
//           // 刷新阅读进度
////            readMenu.bottomView.progressView.reloadProgress()
//       }
//   }
    
    /// 点击下一章
//   func readMenuClickNextChapter() {
//       
//       if readModel.recordModel.isLastChapter {
//           
//           Log("已经是最后一章了")
//           
//       }else{
//           
//           GoToChapter(chapterID: readModel.recordModel.chapterModel.nextChapterID)
//   
//           // 检查当前内容是否包含书签
////           readMenu.topView.checkForMark()
//           
//           // 刷新阅读进度
////            readMenu.bottomView.progressView.reloadProgress()
//       }
//   }
    
    /// 拖拽阅读记录
//   func readMenuDraggingProgress(toPage: NSInteger) {
//       
//       if readModel.recordModel.page.intValue != toPage{
//           
//           readModel.recordModel.page = NSNumber(value: toPage)
//           
//           creatPageController(displayController: GetCurrentReadViewController())
//           
//           // 检查当前内容是否包含书签
////           readMenu.topView.checkForMark()
//       }
//   }
    
    /// 拖拽章节进度(总文章进度,网络文章也可以使用)
//    func readMenuDraggingProgress(readMenu: ReadMenu!, toChapterID: NSNumber, toPage: NSInteger) {
       
//        // 不是当前阅读记录章节
//        if toChapterID != readModel!.recordModel.chapterModel.id {
           
//            GoToChapter(chapterID: toChapterID, toPage: toPage)
           
//            // 检查当前内容是否包含书签
//            readMenu.topView.checkForMark()
//        }
//    }
    
    /// 切换进度显示(分页 || 总进度)
//    func readMenuClickDisplayProgress(readMenu: ReadMenu) {
//        
//        creatPageController(displayController: GetCurrentReadViewController())
//    }
    
    /// 点击切换背景颜色
//   func readMenuClickBGColor() {
//       
//       // 切换背景颜色可以根据需求判断修改目录背景颜色,文字颜色等等(目前放在showLeftView方法中,leftView将要出现的时候处理)
//       // leftView.updateUI()
//       
//       view.backgroundColor = ReadConfigure.shared().bgColor
//       
//       creatPageController(displayController: GetCurrentReadViewController())
//   }
    
    /// 点击切换字体
//   func readMenuClickFont() {
//       
//       creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
//   }
//    
//    /// 点击切换字体大小
//   func readMenuClickFontSize() {
//       
//       creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
//   }
//    
//    /// 点击切换间距
//   func readMenuClickSpacing() {
//       
//       creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
//   }
//    
//    /// 点击切换翻页效果
//   func readMenuClickEffect() {
//       
//       creatPageController(displayController: GetCurrentReadViewController())
//   }
//    
    
    // MARK: 展示动画
    
    /// 辅视图展示
    // func showLeftView(isShow:Bool, completion:AnimationCompletion? = nil) {
     
    //     if isShow { // leftView 将要显示
            
    //         // 刷新UI 
    //         leftView.updateUI()
            
    //         // 滚动到阅读记录
    //         leftView.catalogView.scrollRecord()
            
    //         // 允许显示
    //         leftView.isHidden = false
    //     }
        
    //     UIView.animate(withDuration: _READ_AD_TIME, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
    //         if isShow {
                
    //             self?.leftView.frame.origin = CGPoint.zero
                
    //             self?.contentView.frame.origin = CGPoint(x: _READ_LEFT_VIEW_WIDTH, y: 0)
                
    //         }else{
                
    //             self?.leftView.frame.origin = CGPoint(x: -_READ_LEFT_VIEW_WIDTH, y: 0)
                
    //             self?.contentView.frame.origin = CGPoint.zero
    //         }
            
    //     }) { [weak self] (isOK) in
            
    //         if !isShow { self?.leftView.isHidden = true }
            
    //         completion?()
    //     }
    // }
    
    deinit {
        
        // 移除阅读长按视图监控
        _READ_NOTIFICATION_REMOVE(target: self)
        
        // 清理阅读控制器
        clearPageController()
    }
}
