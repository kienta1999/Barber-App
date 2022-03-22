//
//  PostView.swift
//  BarberApp
//
//  Created by admin on 3/21/22.
//

import UIKit

class PostView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    var subView: PostView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib.init(nibName: "PostView", bundle: bundle)
        subView = nib.instantiate(withOwner: self, options: nil).first as? PostView
        self.addSubview(subView!)
    }
    
    public func configurateView(_ imageUrl: URL?, _ caption: String, _ label: Int){
        if let subView = subView {
            if let data = try? Data(contentsOf: imageUrl!) {
                subView.imageView.image = UIImage(data: data)
            }
            subView.captionTextView.text = caption
            subView.likesLabel.text = String("\(label) likes")
        }
        
    }
}
