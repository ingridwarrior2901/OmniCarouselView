//
//  PagerView.swift
//  Pods
//
//  Created by daishi nakajima on 2016/04/01.
//
//

import UIKit

class PagerView: UIView {
    var count: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var current: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    let margin:CGFloat = 4
    override func draw(_ rect: CGRect) {
        let height = self.frame.height
        let ctx = UIGraphicsGetCurrentContext();
        var x = (self.frame.width - (height + margin) * CGFloat(count)) / 2
        for i in 0..<count {
            ctx?.addEllipse(in: CGRect(x: x, y: 0, width: height, height: height))
            if i == current {
                ctx?.setFillColor(UIColor.white.cgColor)
            } else {
                ctx?.setFillColor(UIColor.lightGray.cgColor)
            }
            ctx?.fillPath();
            
            x += height + margin
        }
    }

}
