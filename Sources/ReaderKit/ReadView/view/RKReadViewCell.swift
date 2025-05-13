import UIKit

class RKReadViewCell: UITableViewCell {

    /// 阅读视图
    private var readView:RKReadView!
    
    var pageModel:RKReadPageModel! {
        
        didSet{
            
            readView.pageModel = pageModel
            
            setNeedsLayout()
        }
    }
    
    class func cell(_ tableView:UITableView) ->RKReadViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "RKReadViewCell")
        
        if cell == nil {
            
            cell = RKReadViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "RKReadViewCell")
        }
        
        return cell as! RKReadViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 阅读视图
        readView = RKReadView()
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
      
        // 分页顶部高度
        let y = pageModel?.headTypeHeight ?? 0.01
        
        // 内容高度
        let h = pageModel?.contentSize.height ?? 0.01

        readView.frame = CGRect(x: 0, y: y, width: DZM_READ_VIEW_RECT.width, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
