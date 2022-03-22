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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }

    init(_ image: UIImageView, _ caption: String, _ label: Int) {
        self.imageView = image
        self.captionTextView.text = caption
        self.likesLabel.text = String("\(label) likes")
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      }
}
