//
//  PaymentInfo.swift
//  MyPodLibrary
//
//  Created by Varun Bagga on 11/10/24.
//

import Foundation


public struct PaymentInfo {
    var amoutDetails: AmountDetails
    var paymentGateWayDetails: PaymentGatewayDetails
    var upiInfo: UPIInfo?
    var generalDetails: GeneralDetails
    var appDetails: AppDetails
    
    public init(amoutDetails: AmountDetails, paymentGateWayDetails: PaymentGatewayDetails, upiInfo: UPIInfo? = nil, generalDetails: GeneralDetails, appDetails: AppDetails) {
        self.amoutDetails = amoutDetails
        self.paymentGateWayDetails = paymentGateWayDetails
        self.upiInfo = upiInfo
        self.generalDetails = generalDetails
        self.appDetails = appDetails
    }
}

public struct AppDetails {
    var appId:String
    var bussinessId:String
    var version:String
    
    public init(appId: String, bussinessId: String, version: String) {
        self.appId = appId
        self.bussinessId = bussinessId
        self.version = version
    }
}

public struct GeneralDetails {
    var timeZone: String
    var userId: String
    var mobileNumber: String
    var recurringPaymentsStatus : String
    var kiMobileNumber:String
    var userName: String
    
    public init(timeZone: String, userId: String, mobileNumber: String, recurringPaymentsStatus: String, kiMobileNumber: String, userName: String) {
        self.timeZone = timeZone
        self.userId = userId
        self.mobileNumber = mobileNumber
        self.recurringPaymentsStatus = recurringPaymentsStatus
        self.kiMobileNumber = kiMobileNumber
        self.userName = userName
    }
}

public struct PaymentGatewayDetails {
    var methodName: String
    var type : String
    var typeId : String
    var viewType: String
    var gatewayId: String
    var category: String
    
    public init(methodName: String, type: String, typeId: String, viewType: String, gatewayId: String, category: String) {
        self.methodName = methodName
        self.type = type
        self.typeId = typeId
        self.viewType = viewType
        self.gatewayId = gatewayId
        self.category = category
    }
}

public struct UPIInfo {
    var fallBack: FallBackMethod
    var upimethod: UPIPaymentMethod?
    var isActive:Bool
    
    public init(fallBack: FallBackMethod, upimethod: UPIPaymentMethod? = nil, isActive: Bool) {
        self.fallBack = fallBack
        self.upimethod = upimethod
        self.isActive = isActive
    }
}

public struct AmountDetails{
    var amountPayable: Float
    var discount: Float
    var gstAmount: Float
    var newAmountWithGST:Float
    var usdPerRupee: Float
    var walletAmount: Float
    var couponId: String
    
    public init(amountPayable: Float, discount: Float, gstAmount: Float, newAmountWithGST: Float, usdPerRupee: Float, walletAmount: Float, couponId: String) {
        self.amountPayable = amountPayable
        self.discount = discount
        self.gstAmount = gstAmount
        self.newAmountWithGST = newAmountWithGST
        self.usdPerRupee = usdPerRupee
        self.walletAmount = walletAmount
        self.couponId = couponId
    }
}


public struct PaymentDetails {
    var methodName: String
    var type : String
    var typeId : String
    var viewType: String
    var gatewayId: Int
    
    public init(methodName: String, type: String, typeId: String, viewType: String, gatewayId: Int) {
        self.methodName = methodName
        self.type = type
        self.typeId = typeId
        self.viewType = viewType
        self.gatewayId = gatewayId
    }
}
