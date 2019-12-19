

import UIKit

protocol handleDeleteAction {
    func didDeleteButtonClicked(_: UIButton)
}

@IBDesignable class FotoDeleteAlert: UIView {
    
    var delegate: handleDeleteAction?
    
    @IBOutlet weak var silBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        silBtn.addTarget(self, action: #selector(didDelete(_:)), for: .touchUpInside)
    }
    
    @IBAction func didCancel(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func didDelete(_ sender: Any) {
        
        self.delegate?.didDeleteButtonClicked(sender as! UIButton)
       
        
    }
}

