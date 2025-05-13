
import UIKit

class DZMReadView: UIView {
    
    /// 当前页模型(使用contentSize绘制)
    var pageModel:DZMReadPageModel! {
        
        didSet{
            
            frameRef = DZMCoreText.GetFrameRef(attrString: pageModel.showContent, rect: CGRect(origin: CGPoint.zero, size: pageModel.contentSize))
        }
    }
    
    /// 当前页内容(使用固定范围绘制)
    var content:NSAttributedString! {
        
        didSet{
            
            frameRef = DZMCoreText.GetFrameRef(attrString: content, rect: CGRect(origin: CGPoint.zero, size: DZM_READ_VIEW_RECT.size))
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 正常使用
        backgroundColor = UIColor.clear
        
        
        
        
        // 可以修改为随机颜色便于调试范围
        //        backgroundColor = DZM_COLOR_ARC
    }
    
    // private func addDashedLine() {
    //     let shapeLayer = CAShapeLayer()
    //     shapeLayer.strokeColor = UIColor(hexString: ReaderThemeManager.shared.menuFont)?.cgColor
    //     shapeLayer.lineWidth = 2
    //     shapeLayer.lineDashPattern = [4, 4] // 虚线的样式：4个点的线，4个点的间隔
    //     shapeLayer.fillColor = nil
        
    //     // 设置虚线框的路径
    //     let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: DZM_READ_VIEW_RECT.size)) // 沿着视图边界绘制矩形
    //     shapeLayer.path = path.cgPath
        
    //     layer.addSublayer(shapeLayer)
    // }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 移除旧的虚线层（避免重复添加）
        layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        
        // 重新添加虚线
        // 根据设置决定是否添加虚线
        // if ReaderStateManager.shared.showHeaderFooterDashLine && ReaderLayoutManager.shared.effectType != .scroll {
        //     addDashedLine()
        // }
        
    }
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height);
        
        ctx?.scaleBy(x: 1.0, y: -1.0);
        
        CTFrameDraw(frameRef!, ctx!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
