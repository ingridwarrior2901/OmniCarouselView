//
//  OmniCarouselView.swift
//  Pods
//
//  Created by daishi nakajima on 2016/03/31.
//
//

import UIKit

open class OmniCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    public enum Content {
        case imageUrl(URL)
        case image(UIImage)
        case view(UIView)
    }
    
    // use infinite loop
    @IBInspectable var infinite: Bool = false
    // show pager
    @IBInspectable var pager: Bool = true
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let rightArrow = UIImageView(image: OmniCarouselView.loadImage("arrow-right"))
    let leftArrow = UIImageView(image: OmniCarouselView.loadImage("arrow-left"))
    
    open var contents: [Content] = [] {
        didSet {
            self.contentsChanged()
        }
    }
    
    // infinite loop
    fileprivate var loopContents: [Content]?
    fileprivate var positionFixed = false
    
    // pager
    fileprivate var pagerView: PagerView?
    
    let CellId = "carousel_cell"
    
    override open func awakeFromNib() {
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OmniCarouselViewCell.self, forCellWithReuseIdentifier: CellId)
        
        
        collectionView.isPagingEnabled = true
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = self.backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        
        if pager {
            self.pagerView = PagerView()
            if let v = self.pagerView {
                v.backgroundColor = UIColor.clear
                self.addSubview(v)
            }
        }
    }    
    
    fileprivate func contentsChanged() {
        if infinite {
            // for infinite loop
            self.loopContents = self.contents
            if let item = self.contents.last {
                self.loopContents?.insert(item, at: 0)
            }
            if let item = self.contents.first {
                self.loopContents?.append(item)
            }
            self.positionFixed = false
        } else {
            loopContents = nil
        }
        
        collectionView.reloadData()
        if contents.count > 1 {
            self.showArrows()
        }
        
        if let pagerView = self.pagerView {
            pagerView.count = self.contents.count
            pagerView.current = 0
            self.bringSubview(toFront: pagerView)
        }
    }
    
    fileprivate func showArrows() {
        [leftArrow, rightArrow].forEach { (view) -> () in
            self.addSubview(view)
            UIView.animate(withDuration: 3.0, animations: { () -> Void in
                view.alpha = 0.0
            }, completion: { (s) -> Void in
                view.removeFromSuperview()
            }) 
        }
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loopContents?.count ?? contents.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath)
        if let cell = cell as? OmniCarouselViewCell {
            let c = loopContents?[indexPath.row] ?? contents[indexPath.row];
            cell.setContent(c)
        }
        return cell;
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  infinite && !self.positionFixed {
            self.positionFixed = true
            // scroll to default position for infinite loop
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        rightArrow.frame = CGRect(x: self.frame.width - 48, y: self.frame.height/2 - 24, width: rightArrow.frame.width, height: rightArrow.frame.height)
        leftArrow.frame = CGRect(x: 0, y: self.frame.height/2 - 24, width: leftArrow.frame.width, height: leftArrow.frame.height)
        
        if let view = self.pagerView {
            view.frame = CGRect(x: 4, y: self.frame.height - 20, width: self.frame.width - 8, height: 8)
        }
    }
    
    class func loadImage(_ name: String) -> UIImage? {
        let podBundle = Bundle(for: OmniCarouselView.self)
        if let url = podBundle.url(forResource: "OmniCarouselView", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Calculate where the collection view should be at the right-hand end item
        var page = Int(scrollView.contentOffset.x / frame.width)
        if let lContents = self.loopContents {
            let right = Int(self.frame.width) * (lContents.count - 1)
            if Int(scrollView.contentOffset.x) >= right {
                let indexPath = IndexPath(item: 1, section: 0)
                collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
                page = 1
            } else if (scrollView.contentOffset.x == 0)  {
                let indexPath = IndexPath(item: (lContents.count - 2), section: 0)
                collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
                page = lContents.count - 2
            }
        }
        if infinite {
            pagerView?.current = page - 1
        } else {
            pagerView?.current = page
        }
    }
}
