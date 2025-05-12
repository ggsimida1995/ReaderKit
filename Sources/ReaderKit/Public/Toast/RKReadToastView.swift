import UIKit

/// 阅读器 Toast 视图
class ReadToastView: UIView {
    
    // MARK: - Properties
    
    /// 单例
    static let shared = ReadToastView()
    
    /// 文本标签
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    /// 动画是否完成
    private var isAnimateComplete: Bool = true
    
    // MARK: - Initialization
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // 添加文本标签
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    
    /// 显示 Toast
    /// - Parameters:
    ///   - message: 提示信息
    ///   - duration: 显示时长
    func show(message: String, duration: Double = 2.0) {
        // 如果动画未完成，直接返回
        if !isAnimateComplete { return }
        
        // 设置消息
        messageLabel.text = message
        
        // 设置尺寸
        frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        
        // 添加到父视图
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let contentView = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController?.view {
            // 移除之前的 Toast
            removeFromSuperview()
            
            // 添加到 contentView
            contentView.addSubview(self)
            center = contentView.center
            
            // 设置初始状态
            alpha = 0
            transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            // 显示动画
            isAnimateComplete = false
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                self.transform = .identity
            }) { [weak self] _ in
                self?.isAnimateComplete = true
            }
            
            // 自动隐藏
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.hide()
            }
        }
    }
    
    /// 隐藏 Toast
    func hide() {
        // 如果动画未完成，直接返回
        if !isAnimateComplete { return }
        
        isAnimateComplete = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { [weak self] _ in
            self?.removeFromSuperview()
            self?.isAnimateComplete = true
        }
    }
    
    // MARK: - Error Handling
    
    /// 处理错误提示
    /// - Parameters:
    ///   - error: 错误信息
    ///   - operation: 操作名称
    static func showError(_ error: Error?, operation: String) {
        if let error = error {
            let message = "\(operation)失败: \(error.localizedDescription)"
            shared.show(message: message)
        }
    }
} 