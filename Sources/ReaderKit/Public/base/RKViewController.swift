import UIKit

class RKViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialize()
        
        addSubviews()
        
        addComplete()
    }
    
    func initialize() {
        
        view.backgroundColor = .clear
        
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) { } else {
            
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func addSubviews() { }
    
    func addComplete() { }
}
