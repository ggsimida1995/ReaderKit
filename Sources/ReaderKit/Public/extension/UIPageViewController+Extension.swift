import UIKit

private var IsGestureRecognizerEnabled: UInt8 = 0
private var TapIsGestureRecognizerEnabled: UInt8 = 0

extension UIPageViewController {

    /// 手势启用
    var gestureRecognizerEnabled:Bool {
        
        get{ return (objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? Bool) ?? true }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue }
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// tap手势
    var tapGestureRecognizer:UITapGestureRecognizer? {

        for ges in gestureRecognizers {
            
            if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                
                return ges as? UITapGestureRecognizer
            }
        }
        
        return nil
    }
    
    /// tap手势启用
    var tapGestureRecognizerEnabled:Bool {
        
        get{ return (objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? Bool) ?? true }
        
        set{
            
            tapGestureRecognizer?.isEnabled = newValue
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
