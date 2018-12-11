//
//  GetSearchHistoryWorker.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 10/6/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import Foundation
struct snGetSearchHistoryWorker {
    func execute() -> [String] {
        guard let recent = UserDefaults.get(key: "search_history") as String? else {
            return []
        }
        return recent.splitString("•")
    }
}

struct snSaveSearchHistoryWorker {
    var keyword: String
    func execute() {
        var recent = UserDefaults.get(key: "search_history") as String? ?? ""
        if recent.contains(keyword) {
            recent = recent.remove(keyword)
        }
        var histories = recent.splitString("•")
        if histories.count == 10 {
            histories.removeLast()
        }
        recent = keyword + "•" + histories.joined(separator: "•")
        UserDefaults.set(key: "search_history", value: recent)
    }
}
