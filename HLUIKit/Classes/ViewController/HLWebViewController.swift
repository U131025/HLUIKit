//
//  RxBaseWebViewController.swift
//  Community
//
//  Created by mac on 2019/9/28.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

open class HLWebViewController: HLViewController, WKUIDelegate {

    public var webView = WKWebView()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        webView.delegate = self
//        webView.scalesPageToFit = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = .white
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override open func bindConfig() {
        super.bindConfig()
    }

    open func loadRequest(localResource: String, type: String = "docx") -> Self {
        DefaultWireframe.shared.showWaitingJuhua(message: nil, in: self.view)

        guard let filePath = Bundle.main.path(forResource: localResource, ofType: type) else {
            return self
        }
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
//            webView.load(fileData,
//                         mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
//                         textEncodingName: "UTF-8",
//                         baseURL: URL(fileURLWithPath: filePath))
            webView.load(fileData, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: filePath))
        } catch {
        }

        return self
    }

    open func loadRequest(url: URL) -> Self {
        let request = URLRequest(url: url)
        webView.load(request)
        return self
    }

    open func loadRequest(htmlString: String) -> Self {
        webView.loadHTMLString(htmlString, baseURL: nil)
        return self
    }
}

extension HLWebViewController: WKNavigationDelegate {

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("开始加载网页")
        DefaultWireframe.shared.showWaitingJuhua(message: nil, in: self.view)
    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("网页加载完毕")
        DefaultWireframe.shared.dismissJuhua()
    }

    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("网页加载失败: \(error)")
        DefaultWireframe.shared.showMessageJuhua(message: "网页加载失败")
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != true {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != true {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
