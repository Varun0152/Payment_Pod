//
//  Extensions.swift
//  MyPodLibrary
//
//  Created by Varun Bagga on 11/10/24.
//

import Foundation

extension Float {
    /// Rounds the double to decimal places value
    public func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places)).rounded(.up)
        return (self * divisor).rounded(.up) / divisor
    }
    public func roundToGst(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

//
//let k_PayuKey = "g1tT0E" //Prod
//let k_PayuURL = "https://secure.payu.in/_payment" //prod
//let kPrimaryColor = hexStringToUIColor(hex: kPrimaryColorStr)
//
//let kRazorPayKey_codeyetiTest = kRazorNewDevKey // development
//let kRazorPayKey_AstrotalkTest = kRazorNewDevKeyAstro // development
//let kRazorPayKey_maskyetiTest = kRazorDevelopmentKey // development
//let RAZORPAY_APP_LOGO = "https://aws.astrotalk.com/assets/images/logo/icon.png"
//var kDollarSymbol = "USD"
//let kPrimaryColorStr = "F0DF20"  // yellow color
//
//let GMSAPiKeyFor_PlaceApi = "AIzaSyD3sw24ewiSgiy12D8YpmhXs-9jc4WPixg" //Production
//let kGMSServicesKey = "AIzaSyDrHdKpxrPozUV6i7bSlg7EL64_m2wP4-I"
//let kGMSPlacesClientKey = "AIzaSyDrHdKpxrPozUV6i7bSlg7EL64_m2wP4-I"
//let kRaorpay_codeyetiLive = "rzp_live_nbFIyWp9PWCqNl" // codeyeti
//let kRazorPayKey_AstrotalkLive = "rzp_live_Mw6ZYXea2k4yyj" // Astrotalk
//let kRazorPayKeyNew_MaskyetiLive = "rzp_live_idcMSOkCdvdxCB" // maskyeti
//private let kRazorDevelopmentKey = "rzp_test_mnLQsJF2nkRjsg"
//private let kRazorNewDevKey = "rzp_test_K2FmWkyeoXIGD3"
//private let kRazorNewDevKeyAstro = "rzp_test_8z4JnWLwdNHC3e" //AstrotalkAccountKey

func addPressState(_ view: UIView, callBackAction:(()->())?){
    UIView.animate(withDuration: 0.1,
                   animations: {
        view.alpha = 0.95
        view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    },
                   completion: { _ in
        //UIView.animate(withDuration: 0.1) {
        view.alpha = 1.0
        view.transform = CGAffineTransform.identity
        callBackAction?()
        // }
    })
}
