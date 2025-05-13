
import UIKit

// 定义 DZMMagnifierView 类
class DZMMagnifierView: UIWindow {
    // 动画时间
    private let DZM_MV_AD_TIME: TimeInterval = 0.08
    // 放大比例
    private let DZM_MV_SCALE: CGFloat = 1.3
    // 放大区域
    private let DZM_MV_WH: CGFloat = 120

    weak var targetWindow: UIView? {
        didSet {
            makeKeyAndVisible()
            UIView.animate(withDuration: DZM_MV_AD_TIME) {
                self.transform = .identity
            }
            // 移除多余的 self.targetPoint = self.targetPoint
        }
    }

    var targetPoint: CGPoint = .zero {
        didSet {
            if let targetWindow = targetWindow {
                var center = CGPoint(x: targetPoint.x, y: self.center.y)
                if targetPoint.y > bounds.height * 0.5 {
                    center.y = targetPoint.y - bounds.height / 2
                }
                self.center = CGPoint(x: center.x + offsetPoint.x, y: center.y + offsetPoint.y)
                if let contentLayer = self.contentLayer {
                    contentLayer.setNeedsDisplay()
                }
            }
        }
    }

    var offsetPoint: CGPoint = CGPoint(x: 0, y: -40) {
        didSet {
            // 移除多余的 self.targetPoint = self.targetPoint
        }
    }

    var scale: CGFloat = 1.3 {
        didSet {
            if let contentLayer = self.contentLayer {
                contentLayer.setNeedsDisplay()
            }
        }
    }

    private var strongSelf: DZMMagnifierView?
    private weak var contentLayer: CALayer?
    private weak var coverOne: UIImageView?
    private weak var coverTwo: UIImageView?

    class func magnifierView() -> DZMMagnifierView {
        let mv = DZMMagnifierView()
        mv.strongSelf = mv
        return mv
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(frame: .zero)
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        offsetPoint = CGPoint(x: 0, y: -40)
        scale = DZM_MV_SCALE
        frame = CGRect(x: 0, y: 0, width: DZM_MV_WH, height: DZM_MV_WH)
        layer.cornerRadius = DZM_MV_WH / 2
        layer.masksToBounds = true
        windowLevel = .alert

        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                self.windowScene = windowScene
            }
        }

        if isIpad {
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray.withAlphaComponent(0.9).cgColor
        }

        let contentLayer = CALayer()
        contentLayer.frame = bounds
        contentLayer.delegate = self
        contentLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(contentLayer)
        self.contentLayer = contentLayer

        transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        if !isIpad {
            let coverOne = UIImageView()
            coverOne.image = UIImage(named: "magnifier_0")
            coverOne.frame = CGRect(x: 0, y: 0, width: DZM_MV_WH, height: DZM_MV_WH)
            addSubview(coverOne)
            self.coverOne = coverOne

            let coverTwo = UIImageView()
            coverTwo.image = UIImage(named: "magnifier_1")
            coverTwo.frame = CGRect(x: 0, y: 0, width: DZM_MV_WH, height: DZM_MV_WH)
            addSubview(coverTwo)
            self.coverTwo = coverTwo
        }
    }

    func remove(complete: (() -> Void)? = nil) {
        UIView.animate(withDuration: DZM_MV_AD_TIME, animations: {
            self.coverOne?.alpha = 0
            self.coverTwo?.alpha = 0
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { [weak self] _ in
            self?.coverOne?.removeFromSuperview()
            self?.coverTwo?.removeFromSuperview()
            self?.removeFromSuperview()
            self?.strongSelf = nil
            complete?()
        })
    }

    // 直接在类中实现 CALayerDelegate 的方法，移除扩展
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.translateBy(x: DZM_MV_WH / 2, y: DZM_MV_WH / 2)
        ctx.scaleBy(x: scale, y: scale)
        ctx.translateBy(x: -targetPoint.x, y: -targetPoint.y)
        targetWindow?.layer.render(in: ctx)
    }
}


