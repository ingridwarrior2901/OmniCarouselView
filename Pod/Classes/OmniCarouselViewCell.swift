//
//  OmniCarouselViewCell.swift
//  Pods
//
//  Created by daishi nakajima on 2016/03/31.
//
//

import UIKit
import AlamofireImage

@objc(OmniCarouselViewCell)
class OmniCarouselViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var anyView : UIView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setContent(_ c: OmniCarouselView.Content) {
        self.anyView?.removeFromSuperview()
        switch c {
        case .imageUrl(let url):
            self.imageView.af_setImage(withURL: url)
        case .image(let image):
            self.imageView.image = image
        case .view(let view):
            self.anyView = view
            self.addSubview(view)
        }
    }
    
    func setup() {        
        self.contentView.autoresizingMask = autoresizingMask;
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(self.imageView)
    }
    
    override func layoutSubviews() {
        self.imageView.frame = self.bounds
        if let view = self.anyView {
            view.frame = self.bounds
        }
    }
}
