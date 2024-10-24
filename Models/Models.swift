//
//  Models.swift
//  FBSnapshotTestCase
//
//  Created by Varun Bagga on 11/10/24.
//

import Foundation



public struct PaymentMethodNameType {
    var Gateway_name: String?
    var PG_method: String?
    var PG_Name: String?
    var PG_category: String?
}


public struct FallBackMethod {
    var icon: String?
    var viewType: String?
    var isRecommended: Bool?
    var methodName: String?
    var typeId: Int?
    var id: Int?
    var type: String?
    var gatewayId: Int?
}


enum PaymentType {
    case razorpay
    case paytm
    case paypal
    case paypal2
    case inapp
    case payu
    case stripe
    case payoneer
    case upi
    case hdfc
}

enum TransectionStatus: String {
    case completed = "COMPLETED"
    case failed = "FAILED"
    case canceled = "CANCELED"
}

enum OrderType: String {
    case question = "QUESTION"
    case report = "REPORT"
    case call = "CALLING"
    case chat = "CHAT"
    case wallet = "WALLET"
    case shop = "SHOP"
    case video_call = "VIDEO_CALL"
}


class PaymentLogRecommendedPaymentMethod : NSObject{

    var cashBackPercentage : Int?
    var category : AnyObject?
    var descriptionField : AnyObject?
    var gatewayId : Int?
    var icon : String?
    var isRecommended : Bool?
    var methodName : String?
    var offerDescription : AnyObject?
    var placeholderDesc : String?
    var recommendedPaymentPlaceHolder : String?
    var type : String?
    var typeId : Int?
    var viewType : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cashBackPercentage = dictionary["cashBackPercentage"] as? Int
        category = dictionary["category"] as? AnyObject
        descriptionField = dictionary["description"] as? AnyObject
        gatewayId = dictionary["gatewayId"] as? Int
        icon = dictionary["icon"] as? String
        isRecommended = dictionary["isRecommended"] as? Bool
        methodName = dictionary["methodName"] as? String
        offerDescription = dictionary["offerDescription"] as? AnyObject
        placeholderDesc = dictionary["placeholderDesc"] as? String
        recommendedPaymentPlaceHolder = dictionary["recommendedPaymentPlaceHolder"] as? String
        type = dictionary["type"] as? String
        typeId = dictionary["typeId"] as? Int
        viewType = dictionary["viewType"] as? String
    }
}
