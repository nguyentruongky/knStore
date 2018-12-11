//
//  WebBrowser.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/11/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit
class knWebBrowserController: knController {
    var url: String?
    
    let webview: UIWebView = {
        let view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override var title: String? {
        didSet { navigationItem.title = title }
    }
    
    override func setupView() {
        navigationController?.changeTitleFont(UIFont.boldSystemFont(ofSize: 17), color: UIColor.color(value: 85))
        statusBarStyle = .default
        navigationController?.hideBar(false)
        navigationController?.removeLine(color: .white)
        navigationController?.isNavigationBarHidden = false
        addBackButton(tintColor: UIColor.color(value: 85))
        
        view.addSubview(webview)
        webview.fill(toView: view)
    }
    
    override func fetchData() {
        guard let url = url, let link = URL(string: url) else { return }
        webview.loadRequest(URLRequest(url: link))
    }
}
