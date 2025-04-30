import Foundation

/// 阅读器相关的通知定义
enum ReaderNotification {
    /// 通知名称定义
    static let needRepaginateContent = NSNotification.Name("Reader.NeedRepaginateContent")
    static let PageReloadUpdate = NSNotification.Name("Reader.PageReloadUpdate")
    static let DashLineChange = NSNotification.Name("Reader.DashLineChange")
    /// 发送通知的便捷方法
    static func postNeedRepaginateContent() {
        NotificationCenter.default.post(name: needRepaginateContent, object: nil)
    }
    
  static func postPageReloadUpdate() {
 
        NotificationCenter.default.post(name: PageReloadUpdate, object: nil)
    }
    
    static func postDashLineChange(isVisible: Bool) {
        NotificationCenter.default.post(name: DashLineChange, object: nil, userInfo: ["isVisible": isVisible])
    }
    
    /// 添加观察者的便捷方法
    static func addRepaginateObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: needRepaginateContent,
            object: nil
        )
    }
    
    static func addPageReloadUpdateObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: PageReloadUpdate,
            object: nil
        )
    }

    static func addDashLineChangeObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: DashLineChange,
            object: nil
        )
    }

    static func removePageReloadUpdateObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: PageReloadUpdate, object: nil)
    }
}
