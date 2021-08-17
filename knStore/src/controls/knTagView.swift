
//
//  KNTagView.swift
//  KNTagView
//
//  Created by Ky Nguyen on 11/29/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

protocol KNTagSelectionDelegate {
    func didSelectTag(tag: KNTag, atIndex index: Int)
}

class KNTagView : UIView {
    let activeBackgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let inactiveBackgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    let cellId = "cellId"
    var datasource = [KNTag]() { didSet { collectionView.reloadData() } }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CenterAlignedCollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(KNTagCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

extension KNTagView : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return datasource.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KNTagCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = KNTagCell()
        configureCell(cell, forIndexPath: indexPath)
        cell.tagName.sizeToFit()
        let size = CGSize(width: cell.tagName.frame.size.width + 16, height: cell.tagName.frame.size.height + 16)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? KNTagCell else { return  }
        collectionView.deselectItem(at: indexPath, animated: false)
        datasource[indexPath.row].selected = !datasource[indexPath.row].selected
        cell.backgroundColor = datasource[indexPath.row].selected ? activeBackgroundColor : inactiveBackgroundColor
        cell.tagName.textColor = datasource[indexPath.row].selected ? UIColor.white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }
    
    func configureCell(_ cell: KNTagCell, forIndexPath indexPath: IndexPath) {
        let tag = datasource[indexPath.row]
        cell.tagName.text = tag.text
        cell.tagName.textColor = tag.selected ? UIColor.white : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = tag.selected ? activeBackgroundColor : inactiveBackgroundColor
    }
}


struct KNTag {
    var text: String?
    var selected = false
    
    init(text: String) {
        self.text = text
    }
}

class KNTagCell: UICollectionViewCell {
    var tagName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    var tagNameMaxWidthConstraint: NSLayoutConstraint?
    
    var data: KNTag? { didSet { tagName.text = data?.text } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tagName)
        tagName.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        tagName.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        tagName.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        tagName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        tagName.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        tagNameMaxWidthConstraint = tagName.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        tagNameMaxWidthConstraint!.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
        tagNameMaxWidthConstraint!.isActive = true
        
        backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        layer.cornerRadius = 4
    }
}



