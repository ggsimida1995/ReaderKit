import UIKit

//CoverControllerDelegate,
class RKReadController: RKViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,RKPageViewControllerDelegate,RKCoverControllerDelegate,RKReadContentViewDelegate {

    // MARK: 数据相关
    
    /// 阅读对象
    var readModel: RKReadModel!
    
    
    // MARK: UI相关
    
    /// 阅读主视图
    var contentView: RKReadContentView!
    
    /// 翻页控制器 (仿真)
    var pageViewController: RKPageViewController!
    
    /// 翻页控制器 (滚动)
    var scrollController:RKReadViewScrollController!
    
    /// 翻页控制器 (无效果,覆盖)
    var coverController:RKCoverController!
    
    /// 非滚动模式时,当前显示 ReadViewController
    var currentDisplayController:RKReadViewController?
    
    /// 用于区分正反面的值(勿动)
    var tempNumber:NSInteger = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 初始化书籍阅读记录
        updateReadRecord(recordModel: readModel.recordModel)
        
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
    

    override func addSubviews() {
        super.addSubviews()
        
        // 阅读视图
        contentView = RKReadContentView()
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
    
    // MARK: - Toast 相关方法
    
    /// 显示 Toast
    func showToast(message: String, duration: Double = 2.0) {
        ReadToastView.shared.show(message: message, duration: duration)
    }
    
    /// 隐藏 Toast
    func hideToast() {
        ReadToastView.shared.hide()
    }
    
    deinit {
        RKKeyedArchiver.clear()
        // 移除阅读长按视图监控
        _READ_NOTIFICATION_REMOVE(target: self)
        
        // 清理阅读控制器
        clearPageController()
    }
}
