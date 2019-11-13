//
//  FundSourcesView.swift
//  BondProject
//
//  Created by Ky Nguyen on 10/25/19.
//  Copyright © 2019 Jeffrey Zavattero. All rights reserved.
//

import UIKit

class FundSourcesView: knGridView<FundSourceCell, FundSource> {
    func setDatasource(methods: [FundSource]) {
        let addNewItem = FundSource(type: "", number: "", holderName: "")
        datasource = methods + [addNewItem]
    }
    
    override func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.layout = layout
        var width = screenWidth - space * 4
        width = min(width, 350)
        itemSize = CGSize(width: width, height: 0)
        itemSpacing = space
        super.setupView()
        fillGrid()
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(left: space, right: space)
        collectionView.register(WalletCell.self, forCellWithReuseIdentifier: "WalletCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell", for: indexPath) as! WalletCell
            cell.setData(data: datasource[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FundSourceCell", for: indexPath) as! FundSourceCell
        cell.setData(data: datasource[indexPath.row])
        return cell
    }
}

class WalletCell: knGridCell<FundSource> {
    private let walletLabel = UIMaker.makeLabel(
        text: "Wallet",
        font: .main(.medium, size: 20),
        color: UIColor.main.alpha(0.8))
    
    override func setData(data: FundSource) {
        self.data = data
        let total = round(1000*data.balance)/1000
        balanceLabel.text = "$\(total)"
    }
    
    
    let balanceLabel = UIMaker.makeLabel(
        font: .main(.bold, size: 66),
        color: .main)
    let depositButton = UIMaker.makeButton(
        title: "Deposit",
        titleColor: .main,
        font: UIFont.main(.medium, size: 17))
    let withdrawButton = UIMaker.makeButton(
        title: "Withdraw",
        titleColor: UIColor.main.alpha(0.7),
        font: UIFont.main(.medium, size: 17))
    
    override func setupView() {
        
        let cardView = UIMaker.makeView(background: .white)
        cardView.addSubviews(views: walletLabel, balanceLabel)
        walletLabel.topLeft(toView: cardView, topSpace: space, leftSpace: space)
        
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.horizontalSuperview(space: space)
        balanceLabel.bottomToSuperview(space: -space)
        
        cardView.addSubviews(views: depositButton, withdrawButton)
        cardView.stackHorizontally(views: [depositButton, withdrawButton], viewSpaces: 8, leftSpace: nil, rightSpace: space)
        depositButton.bottom(toView: walletLabel)
        withdrawButton.top(toView: depositButton)
        
        
        addSubviews(views: cardView)
        cardView.fillSuperview()
        cardView.setCorner(radius: 15)
        
        
        depositButton.addTarget(self, action: #selector(showDeposit))
        withdrawButton.addTarget(self, action: #selector(showWithdraw))
    }
    
    @objc func showDeposit() {
        UIApplication.present(DepositController())
    }
    
    @objc func showWithdraw() {
        UIApplication.present(WithdrawController())
    }
}

class FundSourceCell: knGridCell<FundSource> {
    override func setData(data: FundSource) {
        self.data = data
        if let type = data.type {
            iconImageView.image = UIImage(named: type)
            iconImageView.changeColor(to: .white)
        }
        numberLabel.text = data.number
        holderLabel.text = data.holderName?.uppercased()
        isChecked = data.isChecked
        
        let isEmptyCard = data.holderName?.isEmpty == true && data.type?.isEmpty == true && data.number?.isEmpty == true
        plusIcon.isHidden = !isEmptyCard
    }
    
    private var isChecked = false {
        didSet {
            checkIcon.isHidden = !isChecked
        }
    }
    
    func toggleChecked() {
        isChecked = !isChecked
        data?.isChecked = isChecked
    }
    
    let iconImageView = UIMaker.makeImageView()
    let checkIcon = UIMaker.makeImageView(imageName: "check-circle")
    let plusIcon = UIMaker.makeImageView(imageName: "plus")
    let numberLabel = UIMaker.makeLabel(
        font: UIFont.systemFont(ofSize: 20, weight: .semibold),
        color: .white)
    let holderLabel = UIMaker.makeLabel(
        font: UIFont.systemFont(ofSize: 20, weight: .semibold),
        color: .white)
    
    override func setupView() {
        checkIcon.changeColor(to: .white)
        plusIcon.changeColor(to: .white)
        
        let cardView = UIMaker.makeView(background: UIColor.subColor)
        cardView.addSubviews(views: iconImageView, checkIcon, numberLabel, holderLabel)
        
        iconImageView.topLeft(toView: cardView, topSpace: 0, leftSpace: space)
        iconImageView.square(edge: 64)
        
        checkIcon.topRight(toView: cardView, topSpace: space, rightSpace: -space)
        checkIcon.square(edge: 32)
        checkIcon.isHidden = true
        
        numberLabel.leftToSuperview(space: space)
        numberLabel.centerYToSuperview()
        
        holderLabel.left(toView: numberLabel)
        holderLabel.bottomToSuperview(space: -space)
        
        addSubviews(views: cardView)
        cardView.fillSuperview()
        cardView.setCorner(radius: 15)
        
        cardView.addSubviews(views: plusIcon)
        plusIcon.centerSuperview()
        plusIcon.square(edge: 48)
    }
}

class FundSource {
    var type: String?
    var number: String?
    var holderName: String?
    var isChecked = false
    var balance: Double = 0
    init(type: String, number: String, holderName: String) {
        self.type = type
        self.number = number
        self.holderName = holderName
    }
}
