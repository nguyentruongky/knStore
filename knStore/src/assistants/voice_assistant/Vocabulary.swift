//
//  Vocabulary.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/4/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation

struct Response {
    var key: coinVoiceStep = .action
    var text: String = ""
}

enum coinAction: String {
    case buy, sell, checkPrice, send, receive
    case greeting
    static let actions: [coinAction] = [.buy, .sell, .checkPrice, .send, .receive]
}

enum Coin: String {
    case eth, btc, bch
    static let names: [Coin] = [.bch, .btc, .eth]
}

struct coinVocabulary {
    let coinWords = [
        "btc": ["btc", "ptc", "bitcoin", "big coin", "bit coin", "b tc", "Ledisi", "BDC", "BBC", "CBC", "me TC", "DTC", "CBD", "me PC", "me TC", "BPC"],
        "bch": ["bit coin cash", "bitcoin cash", "bch", "bc8", "pch"],
        "eth": ["eth", "ether", "ethereum", "80 h", "ets"]
    ]
    let actionWords = [
        "receive": ["receive", "receipt", "received"],
        "send": ["sent", "send", "san", "sam", "said", "cell", "saying", "sen"],
        "buy": ["buy", "by", "bye", "pie", "my"],
        "sell": ["sell", "seo", "sale", "sales"],
        "checkPrice": ["check price", "how much", "price of"],
    ]
    
    var sampleMessages = [
        "voice_buy_crypto".i18n,
        "voice_sell_crypto".i18n,
        "voice_send_crypto".i18n,
        "voice_receive_crypto".i18n,
    ]
    
    func getGreeting() -> String {
        return getMessage(for: .greeting, action: .greeting)?.text ?? "voice_greeting_1".i18n
    }
 
    private let responses = [
        "greeting": [
            Response(key: .greeting, text: "voice_greeting_1".i18n),
            Response(key: .greeting, text: "voice_greeting_2".i18n),
            Response(key: .greeting, text: "voice_greeting_3".i18n),
        ]
    ]
    
    func getMessage(for step: coinVoiceStep, action: coinAction) -> Response? {
        guard let actionResponses = responses[action.rawValue] else { return nil }
        let stepResponses = actionResponses.filter({ return $0.key == step })
        guard stepResponses.count > 0 else { return nil }
        let range = 0 ..< stepResponses.count
        let randomIndex = Int.random(in: range)
        return stepResponses[randomIndex]
    }
}
