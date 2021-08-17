//
//  KNTwoColumnsController.swift
//  Ogenii
//
//  Created by Ky Nguyen on 6/15/17.
//  Copyright © 2017 Ogenii. All rights reserved.
//

import UIKit


class KNTwoColumnsController: KNController {
    let cellId = "cellId"
    
    var layout : KNTwoColumnsCollectionViewLayout!
    
    lazy var collectionView: UICollectionView = {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: KNTwoColumnsCollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        let cellPadding = KNTwoColumnCollectionViewSetting.cellPadding
        cv.contentInset = UIEdgeInsets(top: 0, left: cellPadding, bottom: cellPadding, right: cellPadding)
        cv.layer.masksToBounds = true
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {
        
        if let layout = collectionView.collectionViewLayout as? KNTwoColumnsCollectionViewLayout {
            self.layout = layout
            layout.delegate = self
        }
        
        view.addSubview(collectionView)
        collectionView.fill(toView: view)
    }
    
    override func fetchData() {
        
    }
    
}

extension KNTwoColumnsController : KNTwoColumnsCollectionViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension KNTwoColumnsController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}




struct KNTwoColumnCollectionViewSetting {
    static let cellPadding : CGFloat = 6
    static let columnWidth = UIScreen.main.bounds.width / CGFloat(2) - cellPadding * 3
}

final class KNTwoColumnsCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! KNTwoColumnsCollectionViewLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? KNTwoColumnsCollectionViewLayoutAttributes else { return false }
        if attributes.photoHeight == photoHeight {
            return super.isEqual(object)
        }
        return false
    }
}

protocol KNTwoColumnsCollectionViewLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}


final class KNTwoColumnsCollectionViewLayout: UICollectionViewLayout {
    var delegate : KNTwoColumnsCollectionViewLayoutDelegate!
    var numberOfColumns = 2
    private var cache = [KNTwoColumnsCollectionViewLayoutAttributes]()
    private var contentHeight : CGFloat = 0
    private var contentWidth : CGFloat {
        
        let inset = collectionView!.contentInset
        return collectionView!.bounds.width - (inset.left + inset.right)
    }
    
    func clearCache() {
        cache.removeAll()
    }
    
    override func prepare() {
        
        guard cache.isEmpty else { return }
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellHeight = delegate.collectionView(collectionView: collectionView!, heightForCellAtIndexPath: indexPath)
            let height = KNTwoColumnCollectionViewSetting.cellPadding * 2 + cellHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: KNTwoColumnCollectionViewSetting.cellPadding, dy: KNTwoColumnCollectionViewSetting.cellPadding)
            
            let attributes = KNTwoColumnsCollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.photoHeight = cellHeight
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column >= (numberOfColumns - 1) ? 0 : column + 1
        }
    }
    
    override var collectionViewContentSize: CGSize { return CGSize(width: contentWidth, height: contentHeight) }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}

