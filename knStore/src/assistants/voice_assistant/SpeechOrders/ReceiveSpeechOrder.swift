//
//  ReceiveSpeechOrder.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/29/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation
@available(iOS 10.0, *)
class coinReceiveSpeech: coinSpeechOrder {
    override init() {
        super.init()
        action = coinAction.receive
    }
    
    override func getVocabulary() -> [Response] {
        return [
            Response(key: .coin, text: "voice_receive_coin".i18n),
            Response(key: .coin, text: "voice_which_currency".i18n),
            Response(key: .unlock, text: "voice_receive_unlock_1".i18n),
            Response(key: .unlock, text: "voice_receive_unlock_2".i18n)
        ]
    }
    
    override func getStep() -> coinVoiceStep {
        if action == nil { return .action }
        if coin == nil { return .coin }
        if unlockNeeded == true { return .unlock }
        return .action
    }
        
    override func nextAction() { }
    
    override func execute(by speech: String) {
        if coin == nil {
            coin = texter.getCoin(from: speech)
        }
        doer?.sayMessage(reaction)
        switch step {
        case .action:
            break
        case .coin:
            coin = texter.getCoin(from: speech)
        default:
            doer?.startCommand()
        }
    }
}
