//
//  PayoneerWebViewModel.swift
//  AstroYeti
//
//  Created by Astrotalk on 03/11/23.
//  Copyright © 2023 Puneet Gupta. All rights reserved.
//

import Foundation

final class PayoneerWebViewModel {
    let payoneerSuccessStringUrl: String
    let payoneerFailStringUrl: String
    let payoneerRedirectUrl: String
    
    init(payoneerSuccessStringUrl: String, payoneerFailStringUrl: String, payoneerRedirectUrl: String) {
        self.payoneerSuccessStringUrl = payoneerSuccessStringUrl
        self.payoneerFailStringUrl = payoneerFailStringUrl
        self.payoneerRedirectUrl = payoneerRedirectUrl
    }
    
    func getPayoneerWebViewUrlRequest() -> URLRequest? {
        if let url = URL(string: payoneerRedirectUrl) {
            var request = URLRequest(url: url)
            return request
        }
        return nil
    }
       
    
        
}
