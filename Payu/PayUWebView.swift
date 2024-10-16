//
//  PayUWebView.swift
//  AstroYeti
//
//  Created by Astrotalk on 11/01/22.
//  Copyright © 2022 Puneet Gupta. All rights reserved.
//

import UIKit
import WebKit

protocol AstromallPayuDelegate {
    func isPaymentSusscess(productOrderId:String,id:String)
    func isPaymentFail()
}
protocol ChatVcPayuDelegate {
    func isPaymentSusscess()
    func isPaymentFail()
}
protocol WalletPayuDelegate {
    //func isPaymentSusscess(productOrderId:String,id:String)
    func isPaymentFail()
    func isPaymentSusscess()

}
class PayUWebView: UIViewController,WKNavigationDelegate,WKUIDelegate{
    @IBOutlet weak var wkWebView: WKWebView!
    weak var delegate : WalletPaymentProtocol?
    weak var GoldDelegate: AstroTalkGoldProtocol?
    var payuData = [String:String]()
    var controllerString = String()
    var controllerOBJ = UIViewController()
    var eventId = -1
    var postionFromEventList = 0
    var productOrderId = String()
    var astromallDelegate : AstromallPayuDelegate?
    var walletDelegate : WalletPayuDelegate?
    var chatVcDelegate : ChatVcPayuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openPayuPaymentGetway()
        self.title = "Payu Payment"
        self.wkWebView.navigationDelegate = self
        self.navigationBar_ButtonIcon()

    }
    func navigationBar_ButtonIcon() {
        let btnback = self.barButton(image: "NewBackIcon")
        btnback.addTarget(self, action: #selector(self.backPressed(button:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: btnback)]
    }
    @objc func backPressed(button: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
        astromallDelegate?.isPaymentFail()
        walletDelegate?.isPaymentFail()
        chatVcDelegate?.isPaymentFail()

     }
    func openPayuPaymentGetway()  {
        self.payuData["key"] = k_PayuKey
        if let url = URL(string:k_PayuURL) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = self.getPostString(params: self.payuData)
        print (postString )
            request.httpBody = postString.data(using: .utf8)
        self.wkWebView.load(request)
        MyLoader.hideLoading(self.view)
        }
    }
    //helper method to build url form request
    func getPostString(params:[String:String]) -> String
        {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      //  MyLoader.hideLoading(self.view)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            printLog(log: urlStr)
            if urlStr.contains("https://astrotalk.com/payment-success") {
                if self.productOrderId.isEmpty != true {
//                    let webpageURL = URL(string: urlStr)
//                    printLog(log: "incomming url  \(urlStr)")
//                    var dict = [String:Any]()
//                    let components = URLComponents(url: webpageURL!, resolvingAgainstBaseURL: false)!
//                    if components.query != nil {
//                    if let queryItems = components.queryItems {
//                        for item in queryItems {
//                            dict[item.name] = item.value!
//                        }
//                    }
//                    }
//                    print(dict)
//                    let id = dict["i"]
                    astromallDelegate?.isPaymentSusscess(productOrderId: self.productOrderId, id: "")
                }else{
                    self.navigationController?.popViewController(animated: true)
                    //self.showSuccessfullDialoge()
                    chatVcDelegate?.isPaymentSusscess()
                    walletDelegate?.isPaymentSusscess()
                    astromallDelegate?.isPaymentSusscess(productOrderId: "", id: "")
                    
                }
            }else if urlStr.contains("https://astrotalk.com/payment-fail"){
                if self.productOrderId.isEmpty != true {
                    self.navigationController?.popViewController(animated: true)
                    astromallDelegate?.isPaymentFail()

                }else{
                    self.navigationController?.popViewController(animated: true)
                    walletDelegate?.isPaymentFail()
                    chatVcDelegate?.isPaymentFail()
                    astromallDelegate?.isPaymentFail()

                    //self.presentAlertClass()
                }
            }
        }
        decisionHandler(.allow)
    }
    
      func showSuccessfullDialoge() {
          let alertController = UIAlertController(title: "Success", message: "Payment Successful.", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "ok", style: .default, handler: {
              (action : UIAlertAction!) -> Void in
              if self.controllerString.isEmpty == false {
                  if self.controllerString == "EventList"{
                      self.delegate?.sendDataToEventList(eventId: self.eventId,position: self.postionFromEventList)
                      self.navigationController?.popViewController(animated: true)
                  } else if self.controllerString == "VoIPCall"{
                      if SharedVariables.getIsCallInProgress(){
                          self.navigationController?.popToViewController(self.controllerOBJ, animated: true)
                      } else{
                          let delegate = UIApplication.shared.delegate as? AppDelegate
                          delegate?.notificationDict.removeAll()
                          delegate?.onBoardingSucess_Home()
                      }
                  } else if self.controllerString == "AstroTalk Gold" {
                      self.GoldDelegate?.sendDataToAstroTalkGold(isFromWalletPayementVc: true)
                      //                    NotificationCenter.default.post(name: Notification.Name("AstroTalkGoldRecharge"), object: nil, userInfo: ["isRecharge": true])
                      
                      self.navigationController?.popToViewController(self.controllerOBJ, animated: true)
                  }
                  else{
                      self.navigationController?.popToViewController(self.controllerOBJ, animated: true)
                  }
              }else{
                  NotificationCenter.default.post(name: Notification.Name("onBoardingPaymentSucess"), object:nil, userInfo: ["value":0])
//                  let vc = WListDetailsVC()
//                  vc.selectionTag = 1
//                  self.navigationController?.pushViewController(vc, animated: true)
              }
          })
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
      }
}
