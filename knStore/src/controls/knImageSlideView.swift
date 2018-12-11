//
//  PhotoSlideshow.swift
//  Marco
//
//  Created by Ky Nguyen on 6/27/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class knImageSlideCell: knGridCell<String> {
    override var data: String? { didSet {
        imgView.downloadImage(from: data)
        }}
    let imgView = UIMaker.makeImageView(contentMode: .scaleAspectFill)
    override func setupView() {
        addSubviews(views: imgView)
        imgView.fill(toView: self,
                     space: UIEdgeInsets(top: 32, left: 32, bottom: 16, right: 32))
    }
}

class knImageSlideView: knGridView<knImageSlideCell, String> {
    let dots = UIPageControl()
    override var datasource: [String] { didSet {
        dots.numberOfPages = datasource.count
        dots.hidesForSinglePage = true
        }}
    
    override func setupView() {
        layout = UICollectionViewFlowLayout()
        (layout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        itemSize = CGSize(width: screenWidth, height: 250)
        super.setupView()
        collectionView.isPagingEnabled = true
        
        dots.translatesAutoresizingMaskIntoConstraints = false
        dots.currentPageIndicatorTintColor = UIColor.white
        dots.pageIndicatorTintColor = UIColor(value: 243)
        
        addSubviews(views: collectionView, dots)
        addConstraints(withFormat: "V:|-8-[v0][v1]|", views: collectionView, dots)
        collectionView.horizontal(toView: self)
        dots.centerX(toView: self)
        dots.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / screenWidth)
        dots.currentPage = page
    }
}
