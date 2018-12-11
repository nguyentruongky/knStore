//
//  Voice.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 4/25/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//
 
import UIKit
import Speech
import AVFoundation

@available(iOS 10.0, *)
class coinVoiceController: knCustomTableController {
    let padding: CGFloat = 24
    var navController: UINavigationController?
    
    private var datasource = [String]() { didSet { tableView.reloadData() }}
    private let microButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "assitant").changeColor())
    let vocabulary = coinVocabulary()
    let animationView = knRippleAnimationView()
    let closeButton = UIMaker.makeButton(image: UIImage(named: "close"))
    let statementLabel = UIMaker.makeLabel(font: UIFont.main(size: 32), color: .white, numberOfLines: 0, alignment: .center)
    let userSpeechLabel = UIMaker.makeLabel(font: UIFont.main(size: 20), color: .white, numberOfLines: 0)
    
    lazy var speaker = coinSpeaker(delegate: self)
    lazy var speechRecognizer = coinRecorder(assistant: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userSpeechLabel.text = ""
        speechRecognizer = coinRecorder(assistant: self)
        speechRecognizer.stopRecording()
        statementLabel.text = vocabulary.getGreeting()
        tableView.isHidden = false
        run({ [unowned self] in self.speaker.say(self.statementLabel.text!) }, after: 0.35)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        speechRecognizer.stopRecording()
    }
    
    override func setupView() {
        view.backgroundColor = UIColor(r: 3, g: 28, b: 53)
        tableView.backgroundColor = view.backgroundColor
        navigationController?.hideBar(true)
        
        closeButton.contentEdgeInsets = UIEdgeInsets(space: 12)
        
        microButton.contentEdgeInsets = UIEdgeInsets(space: 20)
        microButton.tintColor = UIColor(r: 69, g: 125, b: 245)
        microButton.backgroundColor = .white
        
        view.addSubviews(views: tableView, closeButton, statementLabel, userSpeechLabel, animationView, microButton)

        userSpeechLabel.horizontal(toView: view, space: padding)
        userSpeechLabel.top(toView: view,
                           space: hasNotch() ? padding * 4 : padding * 2)
        
        statementLabel.verticalSpacing(toView: userSpeechLabel, space: padding * 2)
        statementLabel.horizontal(toView: view, space: padding * 2)
        
        tableView.horizontal(toView: view, space: padding)
        tableView.verticalSpacing(toView: statementLabel, space: padding)
        tableView.bottom(toView: view, space: -112)

        microButton.setRoundCorner(32)
        microButton.square(edge: 64)
        microButton.centerX(toView: view)
        microButton.bottom(toView: view, space: -24)
        microButton.addTarget(self, action: #selector(toggleRecording))
        
        animationView.frame.size = CGSize(width: 120, height: 120)
        animationView.center = CGPoint(x: screenWidth / 2 + 60, y: screenHeight + 4)
        
        closeButton.topRight(toView: view, top: hasNotch() ? padding * 1.5 : padding, right: -padding)
        closeButton.square(edge: 44)
        closeButton.addTarget(self, action: #selector(dismissBack))
        
        closeButton.isHidden = true 
    }
    
    @objc func toggleRecording() {
        speechRecognizer.toggleRecording()
    }
    
    override func registerCells() {
        tableView.register(coinAssistantActionCell.self, forCellReuseIdentifier: "coinAssistantActionCell")
    }
    
    override func fetchData() {
        datasource = vocabulary.sampleMessages
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return datasource.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinAssistantActionCell", for: indexPath) as! coinAssistantActionCell
        cell.data = datasource[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 48 }
}

@available(iOS 10.0, *)
extension coinVoiceController: coinSpeakerDelegate {
    func didFinishSpeak() {
        guard isMeOnTop() else { return }
        speechRecognizer.startRecording()
    }
    
    func isMeOnTop() -> Bool {
        return true
    }
}


class coinAssistantActionCell: knTableCell {
    let padding: CGFloat = 24
    let titleLabel = UIMaker.makeLabel(font: UIFont.main(),
                                           color: UIColor(r: 205, g: 210, b: 215),
                                           alignment: .center)
    var data: String? {
        didSet {
            titleLabel.text = data
        }
    }
    override func setupView() {
        backgroundColor = UIColor(r: 3, g: 28, b: 53)
        addSubviews(views: titleLabel)
        titleLabel.horizontal(toView: self, space: padding)
        titleLabel.centerY(toView: self)
    }
}
