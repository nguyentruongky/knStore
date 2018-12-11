//
//  Recognizer.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 5/25/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import Speech

@available(iOS 10.0, *)
class coinRecorder: NSObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var timer: Timer?
    private var latestSpeech = ""
    private weak var assistant: coinVoiceController?
    var textAnalyser: coinAnalyser!

    convenience init(assistant: coinVoiceController) {
        self.init()
        self.assistant = assistant
        textAnalyser = coinAnalyser(assistant: assistant)
    }

    func runAnalyser(speech: String) {
        if latestSpeech == speech { return }
        latestSpeech = speech
        print("inside runAnalyser")
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
    }
    
    @objc private func timerTick() {
        print("inside timerTick")
        timer?.invalidate()
        timer = nil
        if audioEngine.isRunning == false { return }
        textAnalyser.analyzeText(latestSpeech)
    }
    
    func toggleRecording() {
        if audioEngine.isRunning {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func startRecording() {
        if audioEngine.isRunning { return }
        
        vibrate()
        cancelCurrentTaskIfNeeded()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        func didRecognized(result: SFSpeechRecognitionResult?, error: Error?) {
            var isFinal = true
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                let speech = bestString
                assistant?.userSpeechLabel.text = speech
                assistant?.tableView.isHidden = true
                runAnalyser(speech: speech)
                print("didRecognized")
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal == true {
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                recognitionTask = nil
                stopRecording()
            }
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: didRecognized)
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in self?.recognitionRequest?.append(buffer) }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            assistant?.animationView.isHidden = false
        } catch {
            print("audioEngine couldn't start because of an error.")
            stopRecording()
        }
    }
    
    private func cancelCurrentTaskIfNeeded() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        assistant?.animationView.isHidden = true
    }
}
