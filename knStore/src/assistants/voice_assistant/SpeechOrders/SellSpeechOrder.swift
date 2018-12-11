//
//  SellSpeechOrder.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/29/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation
@available(iOS 10.0, *)
class coinSellSpeech: coinSpeechOrder {
    override init() {
        super.init()
        action = coinAction.sell
    }
    
    override func getVocabulary() -> [Response] {
        return [
            Response(key: .coin, text: "voice_sell_coin".i18n),
            Response(key: .coin, text: "voice_which_currency".i18n),
            Response(key: .amount, text: "voice_sell_amount".i18n),
            Response(key: .amount, text: "voice_sell_amount_2".i18n),
            Response(key: .unlock, text: "voice_trade_unlock_1".i18n),
            Response(key: .unlock, text: "voice_trade_unlock_2".i18n),
            Response(key: .unlock, text: "voice_trade_unlock_3".i18n),
            Response(key: .retryAmount, text: "voice_amount_retry".i18n),
            Response(key: .unlockWithoutAmount, text: "voice_unlock_without_amount".i18n),
        ]
    }
    
    override func getStep() -> coinVoiceStep {
        if action == nil { return .action }
        if coin == nil { return .coin }
        if amount == nil && (amountRetryTimes == 0 || amountRetryTimes == 1) { return .amount }
        if amount == nil && amountRetryTimes == 2 { return .retryAmount }
        if amount == nil && amountRetryTimes >= 3 { return .unlockWithoutAmount }
        if unlockNeeded == true { return .unlock }
        return .action
    }
    
    override func nextAction() {}
    
    override func execute(by speech: String) {
        coin = texter.getCoin(from: speech) ?? coin
        amount = texter.getNumber(in: speech) ?? amount
        
        doer?.sayMessage(reaction)
        
        switch step {
        case .coin:
            coin = texter.getCoin(from: speech)
            
        case .amount:
            if let amt = texter.getNumber(in: speech) {
                amount = amt
            } else {
                amountRetryTimes += 1
            }
            doer?.stopRecording()
            doer?.sayMessage(reaction)
            
        case .retryAmount:
            doer?.stopRecording()
            if let amt = texter.getNumber(in: speech) {
                amount = amt
                doer?.sayMessage(reaction)
                doer?.startCommand()
            } else {
                amountRetryTimes += 1
                doer?.analyzeText(speech)
            }
            
        case .unlock, .unlockWithoutAmount:
            doer?.startCommand()
            
        default:
            break
        }
    }
}
