import UIKit

extension RKReadController {
    
    /// 获取指定阅读记录阅读页
    func GetReadViewController(recordModel: RKReadRecordModel!) -> RKReadViewController? {
        
        if recordModel != nil {
            
            if ReaderLayoutManager.shared.openLongPress { // 需要返回支持长按的控制器
                
                let controller = RKReadLongPressViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
                
            }else{ // 无长按功能
                
                let controller = RKReadViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
            }
        }
        
        return nil
    }
    
    /// 获取当前阅读记录阅读页
    func GetCurrentReadViewController(isUpdateFont:Bool = false) ->RKReadViewController? {
        
        if ReaderLayoutManager.shared.effectType != .scroll { // 滚动模式不需要创建
            
            if isUpdateFont { readModel.recordModel.updateFont() }
            
            return GetReadViewController(recordModel: readModel.recordModel.copyModel())
        }
        
        return nil
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->UIViewController? {
        
        let recordModel = GetAboveReadRecordModel(recordModel: readModel.recordModel)
        
        if recordModel == nil { return nil }
        
        return GetReadViewController(recordModel: recordModel)
    }
    
    /// 获取仿真模式背面(只用于仿真模式背面显示)
    func GetReadViewBGController(recordModel:RKReadRecordModel!, targetView:UIView? = nil) -> RKReadViewBGController {
        
        let vc = RKReadViewBGController()
        
        vc.recordModel = recordModel
        
        let targetView = targetView ?? GetReadViewController(recordModel: recordModel)?.view
        
        vc.targetView = targetView
        
        return vc
    }
    
    
    /// 获取下一页控制器
    func GetBelowReadViewController() ->UIViewController? {
        
        let recordModel = GetBelowReadRecordModel(recordModel: readModel.recordModel)
        
        if recordModel == nil { return nil }
        
        return GetReadViewController(recordModel: recordModel)
    }
    
    /// 跳转指定章节(指定页面)
    func GoToChapter(chapterID:Int!, toPage:NSInteger = 0) {
        
        GoToChapter(chapterID: chapterID, number: toPage, isLocation: false)
    }
    
    /// 跳转指定章节(指定坐标)
    func GoToChapter(chapterID:Int!, location:NSInteger) {
        
        GoToChapter(chapterID: chapterID, number: location, isLocation: true)
    }
    
    /// 跳转指定章节 number:页码或者坐标 isLocation:是页码(false)还是坐标(true)
    private func GoToChapter(chapterID:Int!, number:NSInteger, isLocation:Bool) {
        
        // 复制阅读记录
        let recordModel = readModel.recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
        
        // 检查是否存在章节内容
        let isExist = RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
        
        // 存在 || 不存在(但是为本地阅读)
        if isExist || readModel.bookSourceType == .local {
            
            if !isExist {
                
                // 获取章节数据
                _ = RKReadTextFastParser.parser(readModel: readModel, chapterID: chapterID)
            }
            
            if isLocation {
                
                // 坐标定位
                recordModel.modify(chapterID: chapterID, location: number, isSave: false)
                
            }else{
                
                // 分页定位
                recordModel.modify(chapterID: chapterID, toPage: number, isSave: false)
            }
            
            // 阅读阅读记录
            updateReadRecord(recordModel: recordModel)
            
            // 展示阅读
            creatPageController(displayController: GetReadViewController(recordModel: recordModel))
            
        }else{ // 加载网络章节数据
            
            // ----- 搜索网络小说 -----
            
            //            MBProgressHUD.showLoading(view)
            //
            //            // 加载章节数据
            //            NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
            //
            //                MBProgressHUD.hide(self?.view)
            //
            //                if type == .success {
            //
            //                    // 获取章节数据
            //                    let data = HTTP_RESPONSE_DATA_DICT(response)
            //
            //                    // 解析章节数据
            //                    let chapterModel = DZMReadChapterModel(data)
            //
            //                    // 章节类容需要进行排版一篇
            //                    chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
            //
            //                    // 保存
            //                    chapterModel.save()
            //
            //                    // 修改阅读记录
            //                    recordModel.modify(chapterID: chapterModel.chapterID, toPage: toPage, isSave: false)
            //
            //                    // 更新阅读记录
            //                    self?.updateReadRecord(recordModel: recordModel)
            //
            //                    // 展示阅读记录
            //                    self?.creatPageController(displayController: GetReadViewController(recordModel: recordModel))
            //                }
            //            }
        }
        
        // ----- 搜索网络小说 -----
        
        //        // 预加载下一章(可选)
        //        if readModel.bookSourceType == .network { // 网络小说
        //
        //            if !recordModel.isLastChapter && !DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
        //
        //                // 加载章节数据
        //                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
        //
        //                    if type == .success {
        //
        //                        // 获取章节数据
        //                        let data = HTTP_RESPONSE_DATA_DICT(response)
        //
        //                        // 解析章节数据
        //                        let chapterModel = DZMReadChapterModel(data)
        //
        //                        // 章节类容需要进行排版一篇
        //                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
        //
        //                        // 保存
        //                        chapterModel.save()
        //                    }
        //                }
        //            }
        //        }
    }
    
    /// 获取当前记录上一页阅读记录
    func GetAboveReadRecordModel(recordModel: RKReadRecordModel!) -> RKReadRecordModel? {
        
        // 阅读记录为空
        if recordModel.chapterModel == nil { return nil }
        
        // 复制
        let recordModel = recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
        
        // 章节ID
        let chapterID = recordModel.chapterModel.previousChapterID
        print("上一页 章节ID: \(chapterID)  \(recordModel.isFirstChapter) \(recordModel.isFirstPage)")
        // 第一章 第一页
        if recordModel.isFirstChapter && recordModel.isFirstPage {
            showToast(message: "已经是第一页了")
            DZMLog("已经是第一页了")
            
            return nil
        }
        
        // 第一页
        if recordModel.isFirstPage {
            
            // 检查是否存在章节内容
            let isExist = RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || readModel.bookSourceType == .local {
                
                // 获取章节数据
                if !isExist { _ = RKReadTextFastParser.parser(readModel: readModel, chapterID: chapterID) }
                
                // 修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: DZM_READ_LAST_PAGE, isSave: false)
                
            }else{ // 加载网络章节数据
                
                fetchChapterContent(bookID: bookID, chapterID: chapterID)
                
                // 修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: DZM_READ_LAST_PAGE, isSave: false)
                self.updateReadRecord(recordModel: recordModel)
                
                return nil
            }
            
        }else{ recordModel.previousPage() }
        
        return recordModel
    }
    
    /// 获取当前记录下一页阅读记录
    func GetBelowReadRecordModel(recordModel: RKReadRecordModel!) -> RKReadRecordModel?  {
//        showToast(message: "已经是最后一页了")
        // 阅读记录为空
        if recordModel.chapterModel == nil { return nil }
        
        // 复制
        let recordModel = recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
        
        // 章节ID
        let chapterID = recordModel.chapterModel.nextChapterID
        
        print("下一页 章节ID: \(chapterID)  \(recordModel.isLastChapter) \(recordModel.isLastPage)")
        // 最后一章 最后一页
        if recordModel.isLastChapter && recordModel.isLastPage {
            showToast(message: "已经是最后一页了")
            DZMLog("已经是最后一页了")
            
            return nil
        }
        
        // 最后一页
        if recordModel.isLastPage {
            
            // 检查是否存在章节内容
            let isExist = RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || readModel.bookSourceType == .local {
                
                // 获取章节数据
                if !isExist { _ = RKReadTextFastParser.parser(readModel: readModel, chapterID: chapterID) }
                
                // 修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: 0, isSave: false)
                
            }else{ // 加载网络章节数据
                
                fetchChapterContent(bookID: bookID, chapterID: chapterID)
                
                // 如果存在则修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: 0, isSave: false)
                
                // 更新阅读记录
                self.updateReadRecord(recordModel: recordModel)
            }
            
        }else{ recordModel.nextPage() }
        
        return recordModel
    }
    
    /// 更新阅读记录(阅读控制器)
    func updateReadRecord(controller: RKReadViewController!) {
        
        updateReadRecord(recordModel: controller?.recordModel)
    }
    
    /// 更新阅读记录(阅读记录)
    func updateReadRecord(recordModel: RKReadRecordModel!) {
        
        if recordModel == nil { return }
        
        readModel.recordModel = recordModel
        
        readModel.recordModel.save()

        RK_READ_RECORD_CURRENT_CHAPTER_LOCATION = recordModel.locationFirst
    }
}
