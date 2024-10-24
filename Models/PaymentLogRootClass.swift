//
//  PaymentLogRootClass.swift
//  MyPodLibrary
//
//  Created by Varun Bagga on 11/10/24.
//

import Foundation

class PaymentLogRootClass : NSObject{
    
    var data : PaymentLogData?
    var status : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = PaymentLogData(fromDictionary: dataData)
        }
        status = dictionary["status"] as? String
    }
}
