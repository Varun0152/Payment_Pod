//
//  PayoneerFillViewModel.swift
//  AstroYeti
//
//  Created by Astrotalk on 30/10/23.
//  Copyright © 2023 Puneet Gupta. All rights reserved.
//

import Foundation
import UIKit

final class PayoneerFillViewModel {
    var countryIsoCode = ""
    var name = ""
    var address = ""
    var city = ""
    var pin = ""
    var state = ""
    var phoneNumber = ""
    var addressExt = ""
    private var networkManager = NetworkManager.shared
    var shouldSaveButtonEnable: Bool {
        return !(countryIsoCode.isEmpty || name.isEmpty || address.isEmpty || city.isEmpty || pin.isEmpty || state.isEmpty || phoneNumber.isEmpty)
    }
}

extension PayoneerFillViewModel {
    func submitBillingAddressDetails(successHandler: @escaping ()->Void, failureHandler: @escaping ()->Void) {
        let params: [String: Any] = [
                                     "name" : name,
                                     "line1" : address,
                                     "line2" : addressExt,
                                     "city" : city,
                                     "postalCode" : pin,
                                     "state" : state,
                                     "country" : countryIsoCode,
                                     "phone" : phoneNumber
        ]
        debugPrint(params)
        networkManager.postRequestWithJSON(kSendPaymentAdddress, params: params as [String : AnyObject], oauth: true) { json, error, statuscode in
            if statuscode == 200 {
                successHandler()
            }else {
                failureHandler()
            }
        }
    }
}
