//
//  TradingiPadDetail.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 4/13/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit
let IPAD_MAX_WIDTH: CGFloat = screenWidth / 3 * 1.65

class coiniPadDetailManager: NSObject {
    let padding: CGFloat = 24
    
    let instructionView = UIMaker.makeView()
    
    weak var guest: knController?
    weak var host: UIViewController?
    
    override init() { super.init() }
    
    convenience init(host: UIViewController) {
        self.init()
        self.host = host
    }
    
    func addPage(_ page: knController,
                 to controller: UIViewController,
                 at frame: CGRect) {
        controller.view.addSubview(page.view)
        page.view.frame = frame
        controller.addChild(page)
        page.didMove(toParent: controller)
        self.guest = page
    }
    
    func addInstructionView() {
        guard let view = host?.view else { return }
        view.addSubviews(views: instructionView)
        instructionView.horizontal(toView: view,
                            leftPadding: screenWidth - IPAD_MAX_WIDTH + padding,
                            rightPadding: 0)
        instructionView.centerY(toView: view, space: -120)
    }
    
    func removePage() {
        guard let page = guest else { return }
        page.willMove(toParent: nil)
        page.view.removeFromSuperview()
        page.removeFromParent()
    }
    
    func shouldShow(controller: UIViewController) -> Bool {
        let clazzName = NSStringFromClass(controller.classForCoder)
        var currentClazzName = ""
        if let currentCtrl = guest {
            currentClazzName = NSStringFromClass(currentCtrl.classForCoder)
        }
        return clazzName == currentClazzName ? false : true
    }
    
    func showController(controller: knController,
                        in mainController: knController,
                        rect: CGRect? = nil) {
        var newRect = rect
        if rect == nil {
            let width = screenWidth - IPAD_MAX_WIDTH
            newRect = CGRect(x: width, y: 0, width: IPAD_MAX_WIDTH,
                             height: mainController.view.frame.height)
        }
        if guest != nil {
            removePage()
        }
        addPage(controller, to: mainController, at: newRect!)
    }
}
