//  Created by Ky Nguyen

import UIKit

public extension UInt32 {
    // prevent overflow with Int and Int32
    public static func random(lower: UInt32 = min, upper: UInt32 = max / 2) -> Int {
        return Int(arc4random_uniform(upper - lower - 10) + lower)
    }
}

extension Formatter {
    static func format(with separator: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter
    }
}

extension BinaryInteger {
    func format(with separator: String) -> String {
        return Formatter.format(with: separator).string(for: self) ?? ""
    }
}

