//
//  AvatarGenerator.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 8/21/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

struct knAvatarGenerator {
    private func getColor() -> UIColor {
        let min: UInt32 = 50
        let max: UInt32 = 150
        return UIColor(r: CGFloat(UInt32.random(lower: min, upper: max)),
                             g: CGFloat(UInt32.random(lower: min, upper: max)),
                             b: CGFloat(UInt32.random(lower: min, upper: max)))
    }
    
    func generate2Char(string: String) -> UIImage {
        if string == "" { return #imageLiteral(resourceName: "avatar") }
        let bg = getColor()
        let label = UIMaker.makeLabel(text: string.uppercased(), font: UIFont.main(size: 45),
                                        color: .white, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = true
        label.backgroundColor = bg
        label.sizeToFit()
        let factor: CGFloat = hasNotch() ? 3 : (DeviceType.IS_IPHONE_6P ? 2.5 : 2)
        label.frame.size.width *= factor
        label.frame.size.height = label.frame.size.width
        label.setCorner(radius: label.frame.size.height / 2)
        return label.createImage()
    }
    
}
