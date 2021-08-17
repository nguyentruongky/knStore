//
//  Camera.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 9/7/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit

/**
import SwiftyCam

class KNCameraCtr: SwiftyCamViewController {
    let captureButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "capture"))
    let switchButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "switch_camera"))
    let flashButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "flash_on"))

    @objc func toggleFlash() {
        flashEnabled = !flashEnabled
        flashButton.setImage(flashEnabled ? #imageLiteral(resourceName: "flash_on") : #imageLiteral(resourceName: "flash_off"), for: .normal)
    }

    func nextStep(photo: UIImage) {}
    
    override func viewDidLoad() {
        flashButton.setImage(#imageLiteral(resourceName: "flash_off"), for: .normal)
        videoGravity = .resizeAspectFill
        super.viewDidLoad()
        setupView()
        
        if Platform.isSimulator == true {
            func didSelectImage(_ image: UIImage) {
                nextStep(photo: image)
            }
            KNPhotoSelectorWorker(finishSelection: didSelectImage).execute()
            return
        }

        flashEnabled = true
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = false
        flashEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideBar(true)
    }
    
    func setupView() {
        flashButton.addTarget(self, action: #selector(toggleFlash))
        flashButton.imageView?.change(color: .white)
        flashButton.tintColor = .white
        captureButton.addTarget(self, action: #selector(takePhoto))
        switchButton.addTarget(self, action: #selector(switchCamera))
        
        let backButton = UIMaker.makeButton(image: #imageLiteral(resourceName: "back_arrow"))
        backButton.square(edge: 36)
        backButton.addTarget(self, action: #selector(back))
        view.addSubviews(views: backButton)
        backButton.topLeft(toView: view, top: appDelegate.isiPhoneX ? 44 : 20, left: 12)

        view.addSubviews(views: flashButton)
        flashButton.topRight(toView: view, top: appDelegate.isiPhoneX ? 44 : 20, right: -24)
        
        let bottomView = UIMaker.makeView(background: .clear)
        bottomView.addSubviews(views: captureButton, switchButton)
        
        captureButton.square(edge: 70)
        captureButton.center(toView: bottomView)
        
        switchButton.square(edge: 44)
        switchButton.right(toView: bottomView, space: -padding * 1.5)
        switchButton.centerY(toView: bottomView)
        
        view.addSubviews(views: bottomView)
        
        bottomView.horizontal(toView: view)
        bottomView.bottom(toView: view)
        bottomView.height(appDelegate.isiPhoneX ? 110 : 90)
    }
}

extension KNCameraCtr: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        nextStep(photo: photo)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
}
*/
