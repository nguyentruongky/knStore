//
//  Speaker.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/25/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation
import AVFoundation

protocol coinSpeakerDelegate: class {
    func didFinishSpeak()
}

@available(iOS 10.0, *)
class coinSpeaker: knObject {
    private let synth = AVSpeechSynthesizer()
    var delegate: coinSpeakerDelegate?
    
    convenience init(delegate: coinSpeakerDelegate) {
        self.init()
        self.delegate = delegate
        synth.delegate = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
    }

    func say(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1
        synth.speak(utterance)
    }
}


@available(iOS 10.0, *)
extension coinSpeaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinishSpeak()
    }
}
