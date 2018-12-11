//
//  SpeechModel.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/23/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit

enum coinVoiceStep: String {
    case greeting
    case action
    case coin
    case amount
    case unlock
    case retryAmount
    case unlockWithoutAmount
}

@available(iOS 10.0, *)
class coinSpeechOrder {
    weak var doer: coinAnalyser?
    let texter = coinTexter()
    
    var action: coinAction?
    var coin: Coin?
    var amount: Double?
    var unlockNeeded = true
    var amountRetryTimes = 0
    
    var reaction: Response { get { return getResponse() }}
    func getResponse() -> Response {
        var response: Response?
        switch step {
        case .action:
            response = getMessage(for: .greeting)
        default:
            response = getMessage(for: step)
        }
        return response ?? Response()
    }
    
    var step: coinVoiceStep { get { return getStep() }}
    func getStep() -> coinVoiceStep { return .action }
    
    var vocabulary: [Response] { get { return getVocabulary() }}
    func getVocabulary() -> [Response] { return [Response]() }
    
    func nextAction() {}
    func execute(by speech: String) {}
    
    func getMessage(for step: coinVoiceStep) -> Response? {
        let stepResponses = vocabulary.filter({ return $0.key == step })
        guard stepResponses.count > 0 else { return nil }
        let range = 0 ..< stepResponses.count
        let randomIndex = Int.random(in: range)
        return stepResponses[randomIndex]
    }

    static func getOrder(by action: coinAction) -> coinSpeechOrder {
        switch action {
        case .buy:
            return coinBuySpeech()
        case .sell:
            return coinSellSpeech()
        case .send:
            return coinSendSpeech()
        case .receive:
            return coinReceiveSpeech()
        default:
            return coinSellSpeech()
        }
    }
}
