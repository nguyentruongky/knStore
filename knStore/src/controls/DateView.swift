//
//  DateView.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 11/26/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

fileprivate let padding: CGFloat = 24
struct INDate {
    var day: Int
    var date: Date
    var dayOfWeek: String
    var selected = false
    init(date: Date) {
        self.date = date
        day = date.day
        dayOfWeek = date.dayOfTheWeek.substring(to: 3)
    }
}

class INMovieDateCell: knGridCell<INDate> {
    override var data: INDate? { didSet {
        guard let data = data else { return }
        dayOfWeekLabel.text = data.dayOfWeek
        dayLabel.text = String(data.day)
    }}
    let dayOfWeekLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 14),
                                      color: UIColor(value: 170),
                                      alignment: .center)
    let dayLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 20),
                                           color: UIColor(value: 170),
                                           alignment: .center)
    let selectedBar = UIMaker.makeHorizontalLine(color: UIColor(r: 156, g: 90, b: 249), height: 2)
    override func setupView() {
        addSubviews(views: dayOfWeekLabel, dayLabel, selectedBar)
        addConstraints(withFormat: "V:|-8-[v0]-4-[v1]-16-[v2]|",
                       views: dayOfWeekLabel, dayLabel, selectedBar)
        dayOfWeekLabel.centerX(toView: self)
        dayLabel.centerX(toView: self)
        selectedBar.horizontal(toView: self)
        selectedBar.isHidden = true
    }
    
    override var isSelected: Bool { didSet {
        selectedBar.isHidden = !isSelected
        let color = isSelected ? UIColor(value: 70) : UIColor(value: 170)
        dayOfWeekLabel.textColor = color
        dayLabel.textColor = color
    }}
}

class INMovieDateView: knGridView<INMovieDateCell, INDate> {
    var selectedIndex: IndexPath?
    
    override func setupView() {
        lineSpacing = padding
        layout = UICollectionViewFlowLayout()
        (layout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        itemSize = CGSize(width: 64, height: 0)
        lineSpacing = 8
        contentInset = UIEdgeInsets(left: 8, right: 8)
        
        super.setupView()
        addSubviews(views: collectionView)
        collectionView.fill(toView: self)
        
        let line = UIMaker.makeHorizontalLine(color: UIColor(value: 241), height: 1)
        addSubviews(views: line)
        line.horizontal(toView: self)
        line.bottom(toView: self)
    }
    
    override func didSelectItem(at indexPath: IndexPath) {
        if let selected = selectedIndex {
            let cell = collectionView.cellForItem(at: selected)
            cell?.isSelected = false
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        
        selectedIndex = indexPath
    }
}

