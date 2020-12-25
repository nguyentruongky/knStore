//
//  PhotoThumbView.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/14/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit

class knPhotoThumbView: KNView {
    let padding: CGFloat = 24
    var datasource = [UIImage]() { didSet { collectionView.reloadData() }}
    
    lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(knPhotoThumbCell.self, forCellWithReuseIdentifier: "knPhotoThumbCell")
        return cv
        }()
    
    override func setupView() {
        addSubviews(views: collectionView)
        collectionView.fill(toView: self)
    }
    
    @objc func removeImage(at index: Int) {
        datasource.remove(at: index)
    }
}

extension knPhotoThumbView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "knPhotoThumbCell", for: indexPath) as! knPhotoThumbCell
        cell.data = datasource[indexPath.row]
        cell.backgroundColor = .green
        cell.tag = indexPath.row
        cell.removeImageAtIndex = removeImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 2) / 3
        return CGSize(width: width, height: width)
    }
}

class knPhotoThumbCell: knCollectionCell {
    var data: UIImage? {
        didSet { imageView.image = data }
    }
    
    var removeImageAtIndex: ((Int) -> Void)?
    let imageView = UIMaker.makeImageView(contentMode: .scaleAspectFill)
    let removeButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "remove-1"))
    
    override func setupView() {
        addSubviews(views: imageView, removeButton)
        imageView.fill(toView: self)
        removeButton.topRight(toView: imageView)
        removeButton.square(edge: 44)
        
        removeButton.addTarget(self, action: #selector(removeImage))
    }
    
    @objc func removeImage() {
        removeImageAtIndex?(tag)
    }
    
}



