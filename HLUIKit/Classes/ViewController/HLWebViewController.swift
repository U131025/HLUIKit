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

open class HLWebViewController: HLViewController {

    public let webView = WKWebView()
//    public let webView = UIWebView()
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        webView.delegate = self
//        webView.scalesPageToFit = true
        webView.navigationDelegate = self
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
//        webView.loadRequest(request)
        return self
    }

    open func loadRequest(htmlString: String) -> Self {
        webView.loadHTMLString(htmlString, baseURL: nil)
        return self
    }
}

//extension RxBaseWebViewController: UIWebViewDelegate {
//    public func webViewDidStartLoad(_ webView: UIWebView) {
//        DefaultWireframe.shared.showWaitingJuhua(message: nil, in: self.view)
//    }
//
//    public func webViewDidFinishLoad(_ webView: UIWebView) {
//        DefaultWireframe.shared.dismissJuhua()
//    }
//
//    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        DefaultWireframe.shared.showMessageJuhua(message: localizedString("网页加载失败"))
//    }
//}

extension HLWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("开始加载网页")
        DefaultWireframe.shared.showWaitingJuhua(message: nil, in: self.view)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("网页加载完毕")
        DefaultWireframe.shared.dismissJuhua()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("网页加载失败: \(error)")
        DefaultWireframe.shared.showMessageJuhua(message: "网页加载失败")
    }
}
