//
//  Detection.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/3/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit
import AVFoundation

class KNObject: NSObject {
    override init() { super.init() }
}

@available(iOS 10.0, *)
class coinAnalyser: KNObject {
    weak var assistant: coinVoiceController?
    private var responseTexts = [String]()
    private let texter = coinTexter()
    private var speechOrder: coinSpeechOrder!

    convenience init(assistant: coinVoiceController?) {
        self.init()
        self.assistant = assistant
    }
    
    func analyzeText(_ speech: String) {
        print(speech)
        assistant?.userSpeechLabel.text = speech
        assistant?.tableView.isHidden = true 
        
        getOrderIfNeeded(from: speech)
        speechOrder?.execute(by: speech)
    }
    
    private func getOrderIfNeeded(from speech: String) {
        if speechOrder == nil {
            guard let action = texter.doesContainActions(coinAction.actions, in: speech) else { return }
            speechOrder = coinSpeechOrder.getOrder(by: action)
            speechOrder.doer = self
            stopRecording()
        }
    }
    
    func startCommand() {
        stopRecording()
        presentLockScreen()
    }
    
    func presentLockScreen() {
        func successAction() {
            speechOrder.nextAction()
        }
    }
    
    func setupProtector(_ protector: coinProtector) {
        protector.backButton.isHidden = false
        protector.backButton.removeTarget(protector as! UIViewController, action: nil, for: .allEvents)
        protector.backButton.addTarget(self, action: #selector(closeProtector))
    }
    
    @objc func closeProtector() {
        assistant?.navController?.KN_dismiss()
    }
    
    func sayMessage(_ response: Response) {
        let message = response.text
        guard isDuplicatedMessage(response) == false else { return }
        assistant?.statementLabel.text = message
        responseTexts.append(response.key.rawValue)
        assistant?.speaker.say(message)
    }
    
    private func isDuplicatedMessage(_ response: Response) -> Bool {
        return responseTexts.last == response.key.rawValue
    }
    
    func stopRecording() {
        assistant?.speechRecognizer.stopRecording()
    }
}
