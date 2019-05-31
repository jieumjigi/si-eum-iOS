//
//  WebViewController.swift
//  sieum
//
//  Created by seongho on 07/04/2019.
//  Copyright © 2019 홍성호. All rights reserved.
//

import Foundation
import WebKit
import PanModal

final class WebViewController: BaseViewController {
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView: WKWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        return webView
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKUIDelegate {
    
}

extension WebViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return webView.scrollView
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}
