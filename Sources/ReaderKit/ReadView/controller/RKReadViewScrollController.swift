import UIKit

class RKReadViewScrollController: RKViewController,UITableViewDelegate,UITableViewDataSource {
    
    /// 当前主控制器
    weak var vc: RKReadController!
    
    /// 顶部状态栏
    private var topView:RKReadViewStatusTopView!
    
    /// 阅读视图
    private var tableView:RKTableView!
    
    /// 底部状态栏
    private var bottomView:RKReadViewStatusBottomView!
    
    /// 当前阅读章节ID列表(只会存放本次阅读的列表)
    private var chapterIDs:[Int] = []
    
    /// 当前正在加载的章节
    private var loadChapterIDs:[Int] = []
    
    /// 当前阅读的章节列表,通过已有的章节ID列表,来获取章节模型。
    private var chapterModels:[String:RKReadChapterModel] = [:]
    
    /// 记录滚动坐标
    private var scrollPoint:CGPoint!
    
    /// 是否为向上滚动
    private var isScrollUp:Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 阅读记录开始阅读
        chapterIDs.append(vc.readModel.recordModel.chapterModel.id)
        
        // 刷新阅读进度
        reloadProgress()
        
        // 设置 tableView 样式
        tableView.tableHeaderView = nil
        tableView.backgroundColor = .clear
        
        // 定位上次阅读位置
        tableView.scrollToRow(at: IndexPath(row: vc.readModel.recordModel.page, section: 0), at: .top, animated: false)
    }
    
    override func addSubviews() {
        
        super.addSubviews()
        view.backgroundColor = .clear
//         if ReaderThemeManager.shared.imageShowMode == 1 {
//            // 图片背景
//            let fileName = ReaderThemeManager.shared.uuid.sha1
//            let filePath = FileManager.shared.getImage(fileName: fileName, inFolder: "bookBG")
//            
//            if let imagePath = filePath {
//                let imageView = UIImageView(image: imagePath)
//                imageView.contentMode = .scaleAspectFill
//                imageView.clipsToBounds = true
//                
//                 // 设置透明度 (0.0 为完全透明，1.0 为完全不透明)
//                imageView.alpha = ReaderThemeManager.shared.imageAlpha // 示例值，可根据需求调整
//                // 将 imageView 添加到视图层次的最底层
//                view.insertSubview(imageView, at: 0)
//                
//                // 使用 Auto Layout 设置约束
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
//                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//                ])
//            }
//        }
        // 阅读使用范围
//       let readRect = DZM_READ_RECT!
        
        // 顶部状态栏
        topView = RKReadViewStatusTopView()
        topView.bookNameLabel.text = vc.readModel.bookName
        topView.chapterLabel.text = vc.readModel.recordModel.chapterModel.name
        view.addSubview(topView)
        // topView.frame = CGRect(x: readRect.minX, y: readRect.minY, width: readRect.width, height: _READ_STATUS_TOP_VIEW_HEIGHT)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: ReaderLayoutManager.shared.headerHeight)
        ])
        // 阅读视图
        tableView = RKTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.frame = DZM_READ_VIEW_RECT
 
        // 底部状态栏
        bottomView = RKReadViewStatusBottomView()
        bottomView.bookNameLabel.text = vc.readModel.bookName
        bottomView.chapterLabel.text = vc.readModel.recordModel.chapterModel.name
        view.addSubview(bottomView)
        // bottomView.frame = CGRect(x: readRect.minX, y: readRect.maxY - _READ_STATUS_BOTTOM_VIEW_HEIGHT, width: readRect.width, height: _READ_STATUS_BOTTOM_VIEW_HEIGHT)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ReaderLayoutManager.shared.footerHeight)
        ])
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return chapterIDs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let chapterID = chapterIDs[section]
        
        // 获取章节内容模型
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        // 有数据则返回页数
        if chapterModel != nil { return chapterModel!.pageCount }
        
        // 没有数据或者正在加载
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapterID = chapterIDs[indexPath.section]
        guard let chapterModel = GetChapterModel(chapterID: chapterID) else { return UITableViewCell() }
        
        let pageModel = chapterModel.pageModels[indexPath.row]
        
        // 是否为书籍首页
        if pageModel.isHomePage {
            let cell = RKReadHomeViewCell.cell(tableView)
            cell.homeView.readModel = vc.readModel
            return cell
        } else {
            let cell = RKReadViewCell.cell(tableView)
            cell.pageModel = pageModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chapterID = chapterIDs[indexPath.section]
        guard let chapterModel = GetChapterModel(chapterID: chapterID) else { return 0 }
        
        return chapterModel.pageModels[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView = nil
            headerView.backgroundColor = .clear
        }
        
        guard let chapterModel = chapterModels[String(chapterIDs[section])] else { return }
        
        // 预加载上一章
        preloadingPrevious(chapterModel)
        
        // 预加载下一章
        preloadingNext(chapterModel)
    }
    
    /// 书籍首页将要出现
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { return }
        
        let chapterID = chapterIDs[indexPath.section]
        guard let chapterModel = GetChapterModel(chapterID: chapterID) else { return }
        
        let pageModel = chapterModel.pageModels[indexPath.row]
        
        if pageModel.isHomePage {
            
            topView?.isHidden = true
            
            bottomView?.isHidden = true
        }
    }
    
    /// 书籍首页消失
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { return }
        
        let chapterID = chapterIDs[indexPath.section]
        guard let chapterModel = GetChapterModel(chapterID: chapterID) else { return }
        
        let pageModel = chapterModel.pageModels[indexPath.row]
        
        if pageModel.isHomePage {
            topView?.isHidden = false
            bottomView?.isHidden = false
        }
    }
    
    
    // MARK: 监控滚动以及拖拽
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 隐藏菜单
        //        vc.readMenu.showMenu(isShow: false)
        
        // 重置属性
        isScrollUp = true
        scrollPoint = CGPoint.zero
    }
    
    // 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 开始减速
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollPoint == nil { return }
        
        let point = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        if point.y < scrollPoint.y { // 上滚
            isScrollUp = true
            
        }else if point.y > scrollPoint.y { // 下滚
            
            isScrollUp = false
            
        }else{ }
        
        // 记录坐标
        scrollPoint = point
    }
    
    // MARK: 阅读记录以及进度
    
    /// 更新阅读记录(滚动模式) isRollingUp:是否为往上滚动
    private func updateReadRecord(isRollingUp: Bool) {
        let indexPaths = tableView.indexPathsForVisibleRows
        
        // 异步更新(推荐使用异步)
        DispatchQueue.global().async { [weak self] () in
            guard let self = self,
                  let indexPaths = indexPaths,
                  !indexPaths.isEmpty else { return }
            
            let indexPath: IndexPath = isRollingUp ? indexPaths.last! : indexPaths.first!
            let chapterID = self.chapterIDs[indexPath.section]
            
            guard let chapterModel = self.GetChapterModel(chapterID: chapterID) else { return }
            
            self.vc.readModel.recordModel.modify(chapterModel: chapterModel, page: indexPath.row)
            RK_READ_RECORD_CURRENT_CHAPTER_LOCATION = self.vc.readModel.recordModel.locationFirst
            
            DispatchQueue.main.async { [weak self] () in
                guard let self = self else { return }
                
                self.topView.bookNameLabel.text = chapterModel.name
                self.topView.chapterLabel.text = chapterModel.name
                self.bottomView.bookNameLabel.text = chapterModel.name
                self.bottomView.chapterLabel.text = chapterModel.name
                self.reloadProgress()
            }
        }
    }
    
    /// 刷新阅读进度显示
    private func reloadProgress() {
        guard let chapterModel = vc.readModel.recordModel.chapterModel else { return }
        
        let progress: Float = DZM_READ_TOTAL_PROGRESS(readModel: vc.readModel, recordModel: vc.readModel.recordModel)
        
        bottomView.pageLabel.text = "\(vc.readModel.recordModel.page + 1)/\(chapterModel.pageCount)"
        bottomView.chapterLabel.text = chapterModel.name
        bottomView.bookNameLabel.text = vc.readModel.bookName
        bottomView.progressLabel.text = DZM_READ_TOTAL_PROGRESS_STRING(progress: progress)
        
        topView.chapterLabel.text = chapterModel.name
        topView.bookNameLabel.text = vc.readModel.bookName
        topView.progressLabel.text = DZM_READ_TOTAL_PROGRESS_STRING(progress: progress)
        topView.pageLabel.text = "\(vc.readModel.recordModel.page + 1)/\(chapterModel.pageCount)"
    }
    
    // MARK: 获得阅读数据
    
    /// 获取章节内容模型
    private func GetChapterModel(chapterID: Int) -> RKReadChapterModel? {
        var chapterModel: RKReadChapterModel? = nil
        
        if chapterModels.keys.contains(String(chapterID)) { // 内存中存在章节内容
            chapterModel = chapterModels[String(chapterID)]
        } else { // 内存中不存在章节列表
            // 检查是否存在章节内容
            let isExist = RKReadChapterModel.isExist(bookID: vc.readModel.bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || vc.readModel.bookSourceType == .local {
                // 获取章节数据
                if !isExist {
                    chapterModel = RKReadTextFastParser.parser(readModel: vc.readModel, chapterID: chapterID)
                } else {
                    chapterModel = RKReadChapterModel.model(bookID: vc.readModel.bookID, chapterID: chapterID)
                }
                
                chapterModels[String(chapterID)] = chapterModel
            }
        }
        
        return chapterModel
    }
    
    
    // MARK: 预加载数据
    
    /// 预加载上一个章节
    private func preloadingPrevious(_ chapterModel: RKReadChapterModel) {
        // 章节ID
        let chapterID = chapterModel.previousChapterID
        
        // 是否有章节 || 是否为第一章 || 是否正在加载 || 是否已经存在阅读列表
        if chapterModel.isFirstChapter || loadChapterIDs.contains(chapterID) || chapterIDs.contains(chapterID) { return }
        
        // 加入加载列表
        loadChapterIDs.append(chapterID)
        
        // 书籍ID
        let bookID = chapterModel.bookID
        
        // 由于字典在异步下存在线程安全，这里换成同步，防止字典内对象中途释放或者野指针
        DispatchQueue.global().sync { [weak self] () in
            guard let self = self else { return }
            
            // 检查是否存在章节内容
            let isExist = RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || self.vc.readModel.bookSourceType == .local {
                // 章节内容
                var tempChapterModel: RKReadChapterModel!
                
                // 获取章节数据
                if !isExist {
                    // 章节还没从全文里面解析出来，需要解析出来使用
                    tempChapterModel = RKReadTextFastParser.parser(readModel: self.vc.readModel, chapterID: chapterID)
                } else {
                    // 本地存在章节，取出来使用
                    tempChapterModel = RKReadChapterModel.model(bookID: bookID, chapterID: chapterID)
                }
                
                // 确保章节模型不为空
                guard let finalChapterModel = tempChapterModel else { return }
                
                // 加入阅读内容列表
                self.chapterModels[String(chapterID)] = finalChapterModel
                
                DispatchQueue.main.async { [weak self] () in
                    guard let self = self else { return }
                    
                    // 当前章节索引
                    let previousIndex = max(0, self.chapterIDs.firstIndex(of: chapterModel.id)! - 1)
                    
                    // 加载列表索引
                    let loadIndex = self.loadChapterIDs.firstIndex(of: chapterID)!
                    
                    // 阅读章节ID列表加入
                    self.chapterIDs.insert(chapterID, at: previousIndex)
                    
                    // 移除加载列表
                    self.loadChapterIDs.remove(at: loadIndex)
                    
                    // 刷新整个tableView
                    self.tableView.reloadData()
                    
                    // 调整内容偏移
                    self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y + finalChapterModel.pageTotalHeight)
                }
            } else { // 加载网络章节数据
                let tempChapterModel = fetchChapterContent(bookID: bookID, chapterID: chapterID)
                
                // 确保章节模型不为空
                guard let finalChapterModel = tempChapterModel else { return }
                
                DispatchQueue.main.async { [weak self] () in
                    guard let self = self else { return }
                    
                    // 加入阅读内容列表
                    self.chapterModels[String(chapterID)] = finalChapterModel
                    
                    // 当前章节索引
                    let previousIndex = max(0, self.chapterIDs.firstIndex(of: chapterModel.id)! - 1)
                    
                    // 加载列表索引
                    let loadIndex = self.loadChapterIDs.firstIndex(of: chapterID)!
                    
                    // 阅读章节ID列表加入
                    self.chapterIDs.insert(chapterID, at: previousIndex)
                    
                    // 移除加载列表
                    self.loadChapterIDs.remove(at: loadIndex)
                    
                    // 刷新整个tableView
                    self.tableView.reloadData()
                    
                    // 调整内容偏移
                    self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y + finalChapterModel.pageTotalHeight)
                }
            }
        }
    }
    
    /// 预加载下一个章节
    private func preloadingNext(_ chapterModel: RKReadChapterModel) {
        // 章节ID
        let chapterID = chapterModel.nextChapterID
        
        // 是否有章节 || 是否为最后一章 || 是否正在加载 || 是否已经存在阅读列表
        if chapterModel.isLastChapter || loadChapterIDs.contains(chapterID) || chapterIDs.contains(chapterID) { return }
        
        // 加入加载列表
        loadChapterIDs.append(chapterID)
        
        // 书籍ID
        let bookID = chapterModel.bookID
        
        // 由于字典在异步下存在线程安全，这里换成同步，防止字典内对象中途释放或者野指针
        DispatchQueue.global().sync { [weak self] () in
            guard let self = self else { return }
            
            // 检查是否存在章节内容
            let isExist = RKReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || self.vc.readModel.bookSourceType == .local {
                // 章节内容
                var tempChapterModel: RKReadChapterModel!
                
                // 获取章节数据
                if !isExist {
                    // 章节还没从全文里面解析出来，需要解析出来使用
                    tempChapterModel = RKReadTextFastParser.parser(readModel: self.vc.readModel, chapterID: chapterID)
                } else {
                    // 本地存在章节，取出来使用
                    tempChapterModel = RKReadChapterModel.model(bookID: bookID, chapterID: chapterID)
                }
                
                // 确保章节模型不为空
                guard let finalChapterModel = tempChapterModel else { return }
                
                // 加入阅读内容列表
                self.chapterModels[String(chapterID)] = finalChapterModel
                
                DispatchQueue.main.async { [weak self] () in
                    guard let self = self else { return }
                    
                    // 当前章节索引
                    let nextIndex = self.chapterIDs.firstIndex(of: chapterModel.id)! + 1
                    
                    // 加载列表索引
                    let loadIndex = self.loadChapterIDs.firstIndex(of: chapterID)!
                    
                    // 阅读章节ID列表加入
                    self.chapterIDs.insert(chapterID, at: nextIndex)
                    
                    // 移除加载列表
                    self.loadChapterIDs.remove(at: loadIndex)
                    
                    // 刷新整个tableView
                    self.tableView.reloadData()
                }
            } else { // 加载网络章节数据
                let tempChapterModel = fetchChapterContent(bookID: bookID, chapterID: chapterID)
                
                // 确保章节模型不为空
                guard let finalChapterModel = tempChapterModel else { return }
                
                DispatchQueue.main.async { [weak self] () in
                    guard let self = self else { return }
                    
                    // 加入阅读内容列表
                    self.chapterModels[String(chapterID)] = finalChapterModel
                    
                    // 当前章节索引
                    let nextIndex = self.chapterIDs.firstIndex(of: chapterModel.id)! + 1
                    
                    // 加载列表索引
                    let loadIndex = self.loadChapterIDs.firstIndex(of: chapterID)!
                    
                    // 阅读章节ID列表加入
                    self.chapterIDs.insert(chapterID, at: nextIndex)
                    
                    // 移除加载列表
                    self.loadChapterIDs.remove(at: loadIndex)
                    
                    // 刷新整个tableView
                    self.tableView.reloadData()
                }
            }
        }
    }
    

}
