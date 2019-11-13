//
//  Cell.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 3/16/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit

open class Cell: UIView {
    public var gridlines = Gridlines(top: .default, bottom: .default, left: .default, right: .default)
    @available(*, deprecated: 0.6.3, renamed: "gridlines")
    public var grids: Gridlines {
        get {
            return gridlines
        }
        set {
            gridlines = grids
        }
    }
    public var borders = Borders(top: .none, bottom: .none, left: .none, right: .none) {
        didSet {
            hasBorder = borders.top != .none || borders.bottom != .none || borders.left != .none || borders.right != .none
        }
    }
    var hasBorder = false

    public internal(set) var reuseIdentifier: String?

    var indexPath: IndexPath!

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func prepareForReuse() {}
}

extension Cell: Comparable {
    public static func <(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.indexPath < rhs.indexPath
    }
}

final class BlankCell: Cell {}
