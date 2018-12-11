//
//  AnnouncementView.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 2/27/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit

private let padding: CGFloat = 24
final class AnnouncementView: GridView<AnnouncementItemCell, String> {
    override var datasource: [String] {
        didSet {
            if datasource.count == 1 {
                let edge: CGFloat = screenWidth - padding * 2
                itemSize = CGSize(width: edge, height: 0)
                collectionView.reloadData()
            }
        }
    }
    override func setupView() {
        let edge: CGFloat = screenWidth - padding * 2.75
        lineSpacing = padding
        layout = FAPaginationLayout()
        (layout as? FAPaginationLayout)?.scrollDirection = .horizontal
        itemSize = CGSize(width: edge, height: 0)
        let leftSpacing: CGFloat = padding
        contentInset = UIEdgeInsets(left: leftSpacing, right: leftSpacing)

        super.setupView()
        
        addSubviews(views: collectionView)
        collectionView.fill(toView: self, space: UIEdgeInsets(bottom: 24))
    }
}

final class AnnouncementItemCell: GridCell<String> {
    override var data: String? { didSet { messageLabel.text = data }}
    let messageLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 14),
                                             color: UIColor.white,
                                             numberOfLines: 0,
                                             alignment: .center)
    
    override func setupView() {
        let view = UIMaker.makeView(background: UIColor(r: 28, g: 61, b: 133))
        view.createRoundCorner(7)
        view.addSubviews(views: messageLabel)
        messageLabel.fill(toView: view, space: UIEdgeInsets(space: padding))

        addSubview(view)
        view.fill(toView: self)
    }
}








