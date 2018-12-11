//
//  TextViewer.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/14/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit
class coinTextViewerController: knStaticListController {
    let padding: CGFloat = 24
    var text: String? { didSet {
        label.text = text
        }}
    override var title: String? { didSet { setNavBarTitle(text: title ?? "") }}
    let label = UIMaker.makeLabel(font: UIFont.main(), color: UIColor(value: 85), numberOfLines: 0)
    
    fileprivate let textCell = knTableCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor(UIColor.white)
        navigationController?.hideBar(false)
    }
    
    override func setupView() {
        super.setupView()
        addBackButton(tintColor: .white)
        
        textCell.addSubview(label)
        label.fill(toView: textCell, space: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        
        view.addSubview(tableView)
        tableView.fill(toView: view)
        
        datasource = [textCell]
    }
    
}
