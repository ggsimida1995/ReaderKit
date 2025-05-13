import UIKit

class DZMReadViewController: DZMViewController {
    
    /// 当前页阅读记录对象
    var recordModel: DZMReadRecordModel!
    
    /// 阅读对象(用于显示书名以及书籍首页显示书籍信息)
    weak var readModel: DZMReadModel!
    
    /// 顶部状态栏
    var topView: ReadViewStatusTopView!
    
    /// 底部状态栏
    var bottomView: ReadViewStatusBottomView!
    
    /// 阅读视图
    private var readView: DZMReadView!
    
    /// 书籍首页视图
    private var homeView: DZMReadHomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print("ReaderThemeManager.shared.imageShowMode  \(ReaderThemeManager.shared.imageShowMode)")
        // 设置阅读背景
        // 设置阅读背景
        view.backgroundColor = UIColor.white
        if ReaderThemeManager.shared.imageShowMode == 1 {
            // 图片背景
            let fileName = ReaderThemeManager.shared.uuid.sha1
            let filePath = DZMFileManager.shared.getImage(fileName: fileName, inFolder: "bookBG")
            
            if let imagePath = filePath {
                let imageView = UIImageView(image: imagePath)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                
                 // 设置透明度 (0.0 为完全透明，1.0 为完全不透明)
                imageView.alpha = ReaderThemeManager.shared.imageAlpha // 示例值，可根据需求调整
                // 将 imageView 添加到视图层次的最底层
                view.insertSubview(imageView, at: 0)
                
                // 使用 Auto Layout 设置约束
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            }
        }
        
        // 刷新阅读进度
        reloadProgress()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // 阅读使用范围
        // let readRect = DZM_READ_RECT!
        // print("\(readRect)")
        
        // 顶部状态栏
        topView = ReadViewStatusTopView()
        topView.bookNameLabel.text = readModel.bookName
        topView.chapterLabel.text = recordModel.chapterModel.name
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: ReaderLayoutManager.shared.headerHeight)
        ])
        
        
        // 底部状态栏
        bottomView = ReadViewStatusBottomView()
        view.addSubview(bottomView) // 注意：这里可能是笔误，应该是 bottomView
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ReaderLayoutManager.shared.footerHeight)
        ])
        
        // 阅读视图
        initReadView()
    }
    
    /// 初始化阅读视图
    func initReadView() {
        // 是否为书籍首页
        if recordModel.pageModel.isHomePage {
            topView.isHidden = true
            bottomView.isHidden = true
            
            homeView = DZMReadHomeView()
            homeView.readModel = readModel
            view.addSubview(homeView)
            homeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                homeView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: ReaderLayoutManager.shared.pageInsets.top),
                homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReaderLayoutManager.shared.pageInsets.left),
                homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReaderLayoutManager.shared.pageInsets.right),
                homeView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -ReaderLayoutManager.shared.pageInsets.bottom)
            ])
        } else {
            readView = DZMReadView()
            readView.content = recordModel.contentAttributedString
            view.addSubview(readView)
            readView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                readView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: ReaderLayoutManager.shared.pageInsets.top),
                readView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReaderLayoutManager.shared.pageInsets.left),
                readView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReaderLayoutManager.shared.pageInsets.right),
                readView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -ReaderLayoutManager.shared.pageInsets.bottom)
            ])
        }
    }
    
    /// 刷新阅读进度显示
    private func reloadProgress() {
        // if ReaderLayoutManager.shared.progressType == .total { // 总进度
        //     let progress: Float = DZM_READ_TOTAL_PROGRESS(readModel: readModel, recordModel: recordModel)
        //     bottomView.progressLabel.text = DZM_READ_TOTAL_PROGRESS_STRING(progress: progress)
        // } else { // 分页进度
        let progress: Float = DZM_READ_TOTAL_PROGRESS(readModel: readModel, recordModel: recordModel)
        
        bottomView.pageLabel.text = "\(recordModel.page.intValue + 1)/\(recordModel.chapterModel!.pageCount.intValue)"
        bottomView.chapterLabel.text = recordModel.chapterModel.name
        bottomView.bookNameLabel.text = readModel.bookName
        bottomView.progressLabel.text = DZM_READ_TOTAL_PROGRESS_STRING(progress: progress)
        
        topView.chapterLabel.text = recordModel.chapterModel.name
        topView.bookNameLabel.text = readModel.bookName
        topView.progressLabel.text = DZM_READ_TOTAL_PROGRESS_STRING(progress: progress)
        topView.pageLabel.text = "\(recordModel.page.intValue + 1)/\(recordModel.chapterModel!.pageCount.intValue)"
        
        // }
    }
    
    deinit {
        bottomView?.removeTimer()
    }
}
