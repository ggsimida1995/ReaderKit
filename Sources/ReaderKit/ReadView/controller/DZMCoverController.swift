import UIKit

// 定义代理协议
protocol CoverControllerDelegate: AnyObject {
    func coverController(_ coverController: CoverController, currentController: UIViewController?, finish: Bool)
    func coverController(_ coverController: CoverController, willTransitionToPendingController pendingController: UIViewController?)
    func coverController(_ coverController: CoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController?
    func coverController(_ coverController: CoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController?
}

class CoverController: UIViewController {
    // 代理
    weak var delegate: CoverControllerDelegate?
    // 手势启用状态
    var gestureRecognizerEnabled: Bool = true {
        didSet {
            panGesture.isEnabled = gestureRecognizerEnabled
            tapGestureRecognizerEnabled = gestureRecognizerEnabled
        }
    }
    // Tap手势启用状态
    var tapGestureRecognizerEnabled: Bool = true {
        didSet {
            tapGesture.isEnabled = tapGestureRecognizerEnabled
        }
    }
    // 当前手势操作是否带动画效果
    var openAnimate: Bool = true
    // 当前控制器
    private(set) var currentController: UIViewController?
    // 左拉右拉手势
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(touchPan(_:)))
        return pan
    }()
    // 点击手势
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchTap(_:)))
        tap.delegate = self
        return tap
    }()
    // 手势触发点在左边 辨认方向 左边拿上一个控制器  右边拿下一个控制器
    private var isLeft: Bool = false
    // 判断执行pan手势
    private var isPan: Bool = false
    // 手势是否重新开始识别
    private var isPanBegin: Bool = false
    // 动画状态
    private var isAnimateChange: Bool = false
    // 临时控制器 通过代理获取回来的控制器 还没有完全展示出来的控制器
    private var pendingController: UIViewController?
    // 移动中的触摸位置
    private var moveTouchPoint: CGPoint = .zero
    // 移动中的差值
    private var moveSpaceX: CGFloat = 0
    // 动画时间
    private let animateDuration: TimeInterval = 0.20

    override func viewDidLoad() {
        super.viewDidLoad()
        didInit()
    }

    private func didInit() {
        // 动画效果开启
        openAnimate = true
        // 设置背景颜色
        view.backgroundColor = .white
        // 添加手势
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        // 启用手势
        gestureRecognizerEnabled = true
        // 开启裁剪
        view.layer.masksToBounds = true
    }

    @objc private func touchPan(_ pan: UIPanGestureRecognizer) {
        let tempPoint = pan.translation(in: view)
        let touchPoint = pan.location(in: view)

        if !moveTouchPoint.equalTo(.zero) && (pan.state == .began || pan.state == .changed) {
            moveSpaceX = touchPoint.x - moveTouchPoint.x
        }
        moveTouchPoint = touchPoint

        if pan.state == .began {
            if isAnimateChange { return }
            if openAnimate { isAnimateChange = true }
            isPanBegin = true
            isPan = true
        } else if pan.state == .changed {
            if abs(tempPoint.x) > 0.01 {
                if isPanBegin {
                    isPanBegin = false
                    pendingController = getPanController(with: tempPoint)
                    if let delegate = delegate, let pendingController = pendingController {
                        delegate.coverController(self, willTransitionToPendingController: pendingController)
                    }
                    addController(pendingController)
                }
                if openAnimate && isPan, let pendingController = pendingController {
                    if isLeft {
                        pendingController.view.frame = CGRect(x: touchPoint.x - view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
                    } else {
                        currentController?.view.frame = CGRect(x: tempPoint.x > 0 ? 0 : tempPoint.x, y: 0, width: view.bounds.width, height: view.bounds.height)
                    }
                }
            }
        } else {
            if isPan {
                isPan = false
                if openAnimate, let pendingController = pendingController {
                    var isSuccess = true
                    if isLeft {
                        if pendingController.view.frame.origin.x <= -(view.bounds.width - view.bounds.width * 0.18) {
                            isSuccess = false
                        } else if moveSpaceX < 0 {
                            isSuccess = false
                        }
                    } else {
                        if (currentController?.view.frame.origin.x ?? 0) >= -1 {
                            isSuccess = false
                        }
                    }
                    gestureSuccess(isSuccess, animated: true)
                } else {
                    gestureSuccess(true, animated: openAnimate)
                }
            }
            moveTouchPoint = .zero
            moveSpaceX = 0
        }
    }

    @objc private func touchTap(_ tap: UITapGestureRecognizer) {
        if isAnimateChange { return }
        if openAnimate { isAnimateChange = true }
        let touchPoint = tap.location(in: view)
        pendingController = getTapController(with: touchPoint)
        if let delegate = delegate, let pendingController = pendingController {
            delegate.coverController(self, willTransitionToPendingController: pendingController)
        }
        addController(pendingController)
        gestureSuccess(true, animated: openAnimate)
    }

    private func gestureSuccess(_ isSuccess: Bool, animated: Bool) {
        if let pendingController = pendingController {
            if isLeft {
                if animated {
                    UIView.animate(withDuration: animateDuration) {
                        if isSuccess {
                            pendingController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                        } else {
                            pendingController.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                        }
                    } completion: { [weak self] _ in
                        self?.animateSuccess(isSuccess)
                    }
                } else {
                    if isSuccess {
                        pendingController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                    } else {
                        pendingController.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
                    }
                    animateSuccess(isSuccess)
                }
            } else {
                if animated {
                    UIView.animate(withDuration: animateDuration) {
                        if isSuccess {
                            self.currentController?.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                        } else {
                            self.currentController?.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                        }
                    } completion: { [weak self] _ in
                        self?.animateSuccess(isSuccess)
                    }
                } else {
                    if isSuccess {
                        currentController?.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
                    } else {
                        currentController?.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                    }
                    animateSuccess(isSuccess)
                }
            }
        }
    }

    private func animateSuccess(_ isSuccess: Bool) {
        if isSuccess {
            currentController?.view.removeFromSuperview()
            currentController?.removeFromParent()
            currentController = pendingController
            pendingController = nil
            isAnimateChange = false
        } else {
            pendingController?.view.removeFromSuperview()
            pendingController?.removeFromParent()
            pendingController = nil
            isAnimateChange = false
        }
        if let delegate = delegate {
            delegate.coverController(self, currentController: currentController, finish: isSuccess)
        }
    }

    private func getTapController(with touchPoint: CGPoint) -> UIViewController? {
        var vc: UIViewController?
        let leftWidth = view.bounds.width / 3
        let rightWidth = view.bounds.width / 3
        if touchPoint.x < leftWidth {
            isLeft = true
            if let delegate = delegate {
                vc = delegate.coverController(self, getAboveControllerWithCurrentController: currentController)
            }
        } else if touchPoint.x > (view.bounds.width - rightWidth) {
            isLeft = false
            if let delegate = delegate {
                vc = delegate.coverController(self, getBelowControllerWithCurrentController: currentController)
            }
        }
        if vc == nil {
            isAnimateChange = false
        }
        return vc
    }

    private func getPanController(with touchPoint: CGPoint) -> UIViewController? {
        var vc: UIViewController?
        if touchPoint.x > 0 {
            isLeft = true
            if let delegate = delegate {
                vc = delegate.coverController(self, getAboveControllerWithCurrentController: currentController)
            }
        } else {
            isLeft = false
            if let delegate = delegate {
                vc = delegate.coverController(self, getBelowControllerWithCurrentController: currentController)
            }
        }
        if vc == nil {
            isAnimateChange = false
        }
        return vc
    }

    func setController(_ controller: UIViewController?, animated: Bool = false, isAbove: Bool = true) {
        if let controller = controller {
            if animated && openAnimate && currentController != nil {
                if isAnimateChange { return }
                isAnimateChange = true
                isLeft = isAbove
                pendingController = controller
                addController(controller)
                gestureSuccess(true, animated: true)
            } else {
                addController(controller)
                controller.view.frame = view.bounds
                currentController?.view.removeFromSuperview()
                currentController?.removeFromParent()
                currentController = controller
            }
        }
    }

    private func addController(_ controller: UIViewController?) {
        guard let controller = controller else { return }
        addChild(controller)
        if isLeft {
            view.addSubview(controller.view)
            controller.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        } else {
            if let currentController = currentController {
                view.insertSubview(controller.view, belowSubview: currentController.view)
            } else {
                view.addSubview(controller.view)
            }
            controller.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
        setShadowController(controller)
    }

    private func setShadowController(_ controller: UIViewController) {
        controller.view.layer.shadowColor = UIColor.black.cgColor
        controller.view.layer.shadowOffset = .zero
        controller.view.layer.shadowOpacity = 0.5
        controller.view.layer.shadowRadius = 10
    }
}

extension CoverController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && gestureRecognizer == tapGesture {
            let touchPoint = tapGesture.location(in: view)
            let leftWidth = view.bounds.width / 3
            let rightWidth = view.bounds.width / 3
            if touchPoint.x > leftWidth && touchPoint.x < (view.bounds.width - rightWidth) {
                return true
            }
        }
        return false
    }
}
