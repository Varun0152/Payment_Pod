//
//  PaymentLogRootData.swift
//  MyPodLibrary
//
//  Created by Varun Bagga on 11/10/24.
//

import Foundation

class PaymentLogData : NSObject{
    var currencyConversionFactor:Double?
    var amount : Int?
    var appId : Int?
    var businessId : Int?
    var cashBackPercentage : AnyObject?
    var completeApiHitTimeInMs : AnyObject?
    var consultantId : AnyObject?
    var consultantIdToBuyMembership : AnyObject?
    var consultantIdsWithPrice : AnyObject?
    var convertedFinalAmount : AnyObject?
    var couponId : AnyObject?
    var creationTime : Int?
    var currencyCode : String?
    var deviceType : AnyObject?
    var finalAmount : Int?
    var flow : AnyObject?
    var gst : Int?
    var gstRate : AnyObject?
    var id : Int?
    var ip : String?
    var ipAPILocationId : AnyObject?
    var isActive : AnyObject?
    var isCashBackPercentage : AnyObject?
    var isChecked : Bool?
    var isFirstRecharge : Bool?
    var isForeign : AnyObject?
    var isFromChat : Bool?
    var isPartiallyRefunded : AnyObject?
    var isPaytmApp : Bool?
    var isRapa : AnyObject?
    var isRefunded : AnyObject?
    var isSecondOpinion : Bool?
    var isToShowNewPaymentFailedView : Bool?
    var isToi : AnyObject?
    var languageIds : AnyObject?
    var locationId : AnyObject?
    var membershipMessage : AnyObject?
    var membershipType : AnyObject?
    var membershipTypeToBuy : AnyObject?
    var noOfRecharge : AnyObject?
    var orderMRP : AnyObject?
    var payUFailUrl : String?
    var payURedirectionUrl : String?
    var payUSuccessUrl : String?
    var paymentGatewayId : Int?
    var paymentGatewayTransactionId : AnyObject?
    var paymentPgCompleteTime : AnyObject?
    var paymentType : AnyObject?
    var paymentTypeId : Int?
    var pgMethodName : AnyObject?
    var productOrderId : AnyObject?
    var questionId : AnyObject?
    var razorPayLink : AnyObject?
    var razorpayOrderId : AnyObject?
    var recommendedPaymentMethod : [PaymentLogRecommendedPaymentMethod]?
    var refundStatus : AnyObject?
    var registerDays : Int?
    var reportId : AnyObject?
    var status : String?
    var statusReason : AnyObject?
    var stripeChargeTxId : AnyObject?
    var stripeCustomerAddressId : AnyObject?
    var stripePaymentDTO : AnyObject?
    var subscriptionId : AnyObject?
    var timeZone : String?
    var transactionHash : AnyObject?
    var transactionId : String?
    var updationTime : AnyObject?
    var user : AnyObject?
    var userId : Int?
    var version : AnyObject?
    var walletAmount : AnyObject?
    var walletId : AnyObject?
    var webhookHitCompleteTimeInMs : AnyObject?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        currencyConversionFactor = dictionary["currencyConversionFactor"] as? Double
        amount = dictionary["amount"] as? Int
        appId = dictionary["appId"] as? Int
        businessId = dictionary["businessId"] as? Int
        cashBackPercentage = dictionary["cashBackPercentage"] as? AnyObject
        completeApiHitTimeInMs = dictionary["completeApiHitTimeInMs"] as? AnyObject
        consultantId = dictionary["consultantId"] as? AnyObject
        consultantIdToBuyMembership = dictionary["consultantIdToBuyMembership"] as? AnyObject
        consultantIdsWithPrice = dictionary["consultantIdsWithPrice"] as? AnyObject
        convertedFinalAmount = dictionary["convertedFinalAmount"] as? AnyObject
        couponId = dictionary["couponId"] as? AnyObject
        creationTime = dictionary["creationTime"] as? Int
        currencyCode = dictionary["currencyCode"] as? String
        deviceType = dictionary["deviceType"] as? AnyObject
        finalAmount = dictionary["finalAmount"] as? Int
        flow = dictionary["flow"] as? AnyObject
        gst = dictionary["gst"] as? Int
        gstRate = dictionary["gstRate"] as? AnyObject
        id = dictionary["id"] as? Int
        ip = dictionary["ip"] as? String
        ipAPILocationId = dictionary["ipAPILocationId"] as? AnyObject
        isActive = dictionary["isActive"] as? AnyObject
        isCashBackPercentage = dictionary["isCashBackPercentage"] as? AnyObject
        isChecked = dictionary["isChecked"] as? Bool
        isFirstRecharge = dictionary["isFirstRecharge"] as? Bool
        isForeign = dictionary["isForeign"] as? AnyObject
        isFromChat = dictionary["isFromChat"] as? Bool
        isPartiallyRefunded = dictionary["isPartiallyRefunded"] as? AnyObject
        isPaytmApp = dictionary["isPaytmApp"] as? Bool
        isRapa = dictionary["isRapa"] as? AnyObject
        isRefunded = dictionary["isRefunded"] as? AnyObject
        isSecondOpinion = dictionary["isSecondOpinion"] as? Bool
        isToShowNewPaymentFailedView = dictionary["isToShowNewPaymentFailedView"] as? Bool
        isToi = dictionary["isToi"] as? AnyObject
        languageIds = dictionary["languageIds"] as? AnyObject
        locationId = dictionary["locationId"] as? AnyObject
        membershipMessage = dictionary["membershipMessage"] as? AnyObject
        membershipType = dictionary["membershipType"] as? AnyObject
        membershipTypeToBuy = dictionary["membershipTypeToBuy"] as? AnyObject
        noOfRecharge = dictionary["noOfRecharge"] as? AnyObject
        orderMRP = dictionary["orderMRP"] as? AnyObject
        payUFailUrl = dictionary["payUFailUrl"] as? String
        payURedirectionUrl = dictionary["payURedirectionUrl"] as? String
        payUSuccessUrl = dictionary["payUSuccessUrl"] as? String
        paymentGatewayId = dictionary["paymentGatewayId"] as? Int
        paymentGatewayTransactionId = dictionary["paymentGatewayTransactionId"] as? AnyObject
        paymentPgCompleteTime = dictionary["paymentPgCompleteTime"] as? AnyObject
        paymentType = dictionary["paymentType"] as? AnyObject
        paymentTypeId = dictionary["paymentTypeId"] as? Int
        pgMethodName = dictionary["pgMethodName"] as? AnyObject
        productOrderId = dictionary["productOrderId"] as? AnyObject
        questionId = dictionary["questionId"] as? AnyObject
        razorPayLink = dictionary["razorPayLink"] as? AnyObject
        razorpayOrderId = dictionary["razorpayOrderId"] as? AnyObject
        recommendedPaymentMethod = [PaymentLogRecommendedPaymentMethod]()
        if let recommendedPaymentMethodArray = dictionary["recommendedPaymentMethod"] as? [[String:Any]]{
            for dic in recommendedPaymentMethodArray{
                let value = PaymentLogRecommendedPaymentMethod(fromDictionary: dic)
                recommendedPaymentMethod?.append(value)
            }
        }
        refundStatus = dictionary["refundStatus"] as? AnyObject
        registerDays = dictionary["registerDays"] as? Int
        reportId = dictionary["reportId"] as? AnyObject
        status = dictionary["status"] as? String
        statusReason = dictionary["statusReason"] as? AnyObject
        stripeChargeTxId = dictionary["stripeChargeTxId"] as? AnyObject
        stripeCustomerAddressId = dictionary["stripeCustomerAddressId"] as? AnyObject
        stripePaymentDTO = dictionary["stripePaymentDTO"] as? AnyObject
        subscriptionId = dictionary["subscriptionId"] as? AnyObject
        timeZone = dictionary["timeZone"] as? String
        transactionHash = dictionary["transactionHash"] as? AnyObject
        transactionId = dictionary["transactionId"] as? String
        updationTime = dictionary["updationTime"] as? AnyObject
        user = dictionary["user"] as? AnyObject
        userId = dictionary["userId"] as? Int
        version = dictionary["version"] as? AnyObject
        walletAmount = dictionary["walletAmount"] as? AnyObject
        walletId = dictionary["walletId"] as? AnyObject
        webhookHitCompleteTimeInMs = dictionary["webhookHitCompleteTimeInMs"] as? AnyObject
    }
}
