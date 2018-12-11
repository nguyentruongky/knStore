//
//  Texter.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/29/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation

class coinTexter {
    let vocabulary = coinVocabulary()
    func doesContainAction(_ action: coinAction, in text: String) -> Bool {
        guard let words = vocabulary.actionWords[action.rawValue] else { return false}
        return doesContain(words: words, in: text)
    }
    
    func doesContainActions(_ actions: [coinAction], in text: String) -> coinAction? {
        for action in actions {
            guard let words = vocabulary.actionWords[action.rawValue] else { return nil }
            if doesContain(words: words, in: text) {
                return action
            }
        }
        return nil
    }
    
    func doesContain(words: [String], in text: String) -> Bool {
        let lowerText = text.lowercased()
        for word in words where lowerText.contains(word.lowercased()) {
            return true
        }
        return false
    }
    
    func doesContainCoin(_ coin: Coin, in text: String) -> Bool {
        guard let words = vocabulary.coinWords[coin.rawValue] else { return false}
        return doesContain(words: words, in: text)
    }
    
    func doesContainCoins(_ coins: [Coin], in text: String) -> Coin? {
        for coin in coins {
            guard let words = vocabulary.coinWords[coin.rawValue] else { return nil}
            if doesContain(words: words, in: text) {
                return coin
            }
        }
        return nil
    }
    
    func getNumber(in text: String) -> Double? {
        let words = text.splitString(" ")
        let numbers = words.compactMap({ (word) -> Double? in
            if word.lowercased().contains("1k") { return 1000.0 }
            if word.contains("$") {
                let number = word.replacingOccurrences(of: "$", with: "")
                return Double(number)
            }
            return Double(word)
        })
        return numbers.last
    }
    
    func getCoin(from speech: String) -> Coin? {
        guard let coin = doesContainCoins(Coin.names, in: speech) else { return nil }
        return coin
    }
}
