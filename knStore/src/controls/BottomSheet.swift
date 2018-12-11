//
//  ViewController.swift
//  knStateview
//
//  Created by Ky Nguyen Coinhako on 10/23/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class knBottomSheetTestCtr: UIViewController {
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    var popupOffset: CGFloat { return popupView.frame.origin.y }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        popupView.addGestureRecognizer(tapRecognizer)
    }
    private var animationProgress: CGFloat = 0
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 440)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        popupView.addGestureRecognizer(InstantPanGestureRecognizer(target: self, action: #selector(popupViewPanned)))
    }
    
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    var transitionAnimator = UIViewPropertyAnimator()
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        animateTransitionIfNeeded(to: currentState.opposite, duration: 0.35)
    }
    
    private func animateTransitionIfNeeded(to state: State, duration: Double) {
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.popupView.layer.cornerRadius = 20
                self.popupView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                
                self.bottomConstraint.constant = 0
            case .closed:
                self.popupView.layer.cornerRadius = 0

                self.bottomConstraint.constant = 440
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = 440
            }
        }
        transitionAnimator.startAnimation()
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animationProgress = transitionAnimator.fractionComplete
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.35)
            transitionAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: popupView)
            var fraction = -translation.y / popupOffset
            if currentState == .open { fraction *= -1 }
            if transitionAnimator.isReversed { fraction *= -1 }
            transitionAnimator.fractionComplete = fraction + animationProgress
        case .ended:
            let yVelocity = recognizer.velocity(in: popupView).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            switch currentState {
            case .open:
                if !shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
            case .closed:
                if shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if !shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
            }
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
