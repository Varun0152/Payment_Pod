//
//  ViewController.swift
//  MyPodLibrary
//
//  Created by Varun0152 on 10/11/2024.
//  Copyright (c) 2024 Varun0152. All rights reserved.
//

import UIKit
import MyPodLibrary

class ViewController: UIViewController {
    
    let App_Id = "102"
    let version = "11.2.293"
    let userWithoutLoginId = "11771534"
    let AuthToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MTI5OTEwNDU1IiwiYXV0aCI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJidXNpbmVzc0lkIjoxLCJhcHBJZCI6MTAyLCJyb2xlX3R5cGUiOiJST0xFX1VTRVIiLCJpZCI6NzAwMzEyOCwiaXNMaXZlIjpmYWxzZSwidHNfbnVtYmVyIjo0LCJpYXQiOjE3MjkwNjI4MTksImV4cCI6MjA0NDQyMjgxOX0.jhALPr7ycNLNHttNMRdqkc-o4LZk2bzfBT8CXViC4PM"
    let userId = "7003128"
    let businessId = "1"
    let networkManager = NetworkManager.shared
    let timeZone = "Asia/Kolkata"
    
    var usdPerRupee:Float = 0.0
    var gstamountPayable:Float = 0.0
    var gstAmount: Float = 0.0
    var newAmountWithGST: Float = 0.0
    var kGSTPrice: Float = 18
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func tap(_ sender:Any) {
        networkManager.userId = userId
        networkManager.appId = App_Id
        networkManager.authToken = AuthToken
        networkManager.businessId = businessId
        networkManager.version = version
        networkManager.timezone = "Asia/Kolkata"
        setupAndStartPayment()
    }
    
    func setupAndStartPayment() {
        let userId = userId
        if self.timeZone == "Asia/Kolkata" {
            if gstamountPayable == 0.0 {
                gstAmount = ((50) * kGSTPrice) / 100
            }else {
                gstAmount = (gstamountPayable * kGSTPrice) / 100
            }
            gstAmount = gstAmount.roundToGst(places:2)
            newAmountWithGST = (50) + gstAmount
        } else{
            gstAmount = (gstamountPayable * kGSTPrice) / 100
            newAmountWithGST = (50) + gstAmount
        }
        
        let amountDetails = AmountDetails(
            amountPayable: 50,
            discount: 0,
            gstAmount: gstAmount,
            newAmountWithGST: newAmountWithGST,
            usdPerRupee:1,
            walletAmount: 100,
            couponId: ""
        )
        let paymentDetails = PaymentGatewayDetails(
            methodName: "Debit Card",
            type: "card",
            typeId: "1618" ,
            viewType: "NON_METHOD",
            gatewayId: "11",
            category: ""
        )
        
        let generalDetails = GeneralDetails(
            timeZone: timeZone,
            userId: userId,
            mobileNumber: "+918375996422",
            recurringPaymentsStatus: "",
            kiMobileNumber: "+918375996422",
            userName: "Varun Bagga"
        )
        
        let appDetails = AppDetails(appId: App_Id, bussinessId: businessId, version: version)
        
        let PaymentInfo = PaymentInfo(
            amoutDetails: amountDetails,
            paymentGateWayDetails: paymentDetails,
            generalDetails: generalDetails,
            appDetails:appDetails
        )
        
        PaymentManager.shared.startPayment(withDetail: PaymentInfo, viewController: self, navigationController: self.navigationController)
        
    }
}
