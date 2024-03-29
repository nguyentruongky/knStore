//  Created by Ky Nguyen

import UIKit

extension UIFont {
    enum KNWeight: String {
        case black = "Muli-Black"
        case bold = "Muli-Bold"
        case medium = "Muli-SemiBold"
        case regular = "Muli-Regular"
    }
    
    static func main(_ weight: KNWeight = .regular, size: CGFloat = 15) -> UIFont {
        return font(weight.rawValue, size: size)
    }
    
    static func font(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
}
