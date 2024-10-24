//
//  PayoneerWebView.swift
//  AstroYeti
//
//  Created by Astrotalk on 03/11/23.
//  Copyright © 2023 Puneet Gupta. All rights reserved.
//

import UIKit
import WebKit

protocol PayoneerWebViewDelegate: AnyObject {
    func paymentSuccessful()
    func paymentFailed()
}


class PayoneerWebView: UIViewController {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    weak var delegate: PayoneerWebViewDelegate?
    
    private let viewModel: PayoneerWebViewModel
    
    init(viewModel: PayoneerWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self
        self.title = "Payoneer Payment"
//        MyLoader.showLoading(self.view)
        self.openPayuPaymentGetway()
    }
    
    private func openPayuPaymentGetway() {
        if let request = viewModel.getPayoneerWebViewUrlRequest() {
            self.wkWebView.load(request)
            self.navigationItem.setHidesBackButton(true, animated: false)
//            MyLoader.hideLoading(self.view)
        }
    }

}

extension PayoneerWebView: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains(viewModel.payoneerSuccessStringUrl) {
                self.navigationController?.popViewController(animated: true)
                delegate?.paymentSuccessful()
            }else if urlStr.contains(viewModel.payoneerFailStringUrl) {
                self.navigationController?.popViewController(animated: true)
                delegate?.paymentFailed()
            }
        }
        
        decisionHandler(.allow)
    }
}
