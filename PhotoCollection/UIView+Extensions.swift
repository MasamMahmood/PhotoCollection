//
//  UIView.swift
//  diposmobile4
//

import UIKit

extension UIView{
    
    static func loadViewFromNib<T : UIView>() -> T!{
        
        let nib = UINib(nibName: String(NSStringFromClass(self.classForCoder()).split(separator: ".")[1]), bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        return view as! T
    }
    
}
import UIKit

extension UIView {
    var viewInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        }
        
        return .zero
    }
}


