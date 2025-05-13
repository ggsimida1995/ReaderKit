import UIKit

class RKReadHomeViewCell: UITableViewCell {

    /// 书籍首页视图
    private(set) var homeView:RKReadHomeView!
    
    class func cell(_ tableView:UITableView) ->RKReadHomeViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "RKReadHomeViewCell")
        
        if cell == nil {
            
            cell = RKReadHomeViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "RKReadHomeViewCell")
        }
        
        return cell as! RKReadHomeViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书籍首页
        homeView = RKReadHomeView()
        contentView.addSubview(homeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        homeView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
