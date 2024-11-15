//
//  PaymentViewController.swift
//  MyPodLibrary_Example
//
//  Created by Varun Bagga on 15/11/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import MyPodLibrary

class PaymentViewController: UIViewController {
    
    let App_Id = "2"
    let version = "11.2.296"
    let userWithoutLoginId = "21131330"
    let AuthToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4Mzc1OTk2NDIyIiwiYXV0aCI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJidXNpbmVzc0lkIjoxLCJhcHBJZCI6Miwicm9sZV90eXBlIjoiUk9MRV9VU0VSIiwiaWQiOjcwMDM3MTMsImlzTGl2ZSI6ZmFsc2UsInRzX251bWJlciI6MTQsImlhdCI6MTczMTY2NTI0OSwiZXhwIjoyMDQ3MDI1MjQ5fQ.RZuQaU5_ZXXCnRdZjZHUt3f-wWun7FxWQxbO_MZe1EI"
    let userId = "7003713"
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
            methodName: "CRED UPI",
            type: "UPI",
            typeId: "1754" ,
            viewType: "NON_METHOD",
            gatewayId: "1",
            category: "UPI"
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
        let fallBack = FallBackMethod(
            icon: "",
            viewType: "NON_METHOD",
            isRecommended: false,
            methodName: "Credit Card",
            typeId: 1456,
            id: 1,
            type: "card",
            gatewayId: 1
        )
        
        let appUPIInfo = UPIInfo(fallBack: fallBack, isActive: true)
        
        let PaymentInfo = PaymentInfo(
            amoutDetails: amountDetails,
            paymentGateWayDetails: paymentDetails,
            upiInfo: appUPIInfo,
            generalDetails: generalDetails,
            appDetails:appDetails
        )
        
        PaymentManager.shared.startPayment(withDetail: PaymentInfo, viewController: self, navigationController: self.navigationController)
        
    }
}
