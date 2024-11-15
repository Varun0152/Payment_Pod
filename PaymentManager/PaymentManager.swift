//
//  PaymentManager.swift
//  AstroYeti
//
//  Created by Varun Bagga on 13/08/24.
//  Copyright © 2024 Puneet Gupta. All rights reserved.
//
//


import UIKit
import Razorpay
import StoreKit
import PayPalCheckout
import StripePaymentSheet
import Stripe

protocol PaymentManagerPaymentStatusDelegate: AnyObject {
    func handleFailureCases(error: String)
    func handleSuccessCases(registeredDaysForEvents: Int,isFirstRecharge: Bool)
}

protocol WalletAmountUpdateDelegate: AnyObject {
    func handleSuccess()
}

 
//
public enum UPIPaymentMethod: String {
    case phonepe = "PhonePe"
    case googlePay = "GPay"
    case paytm = "Paytm"
    case bhim = "BHIM"

    var appIntent: String {
        switch self {
        case .phonepe:
            return "phonepe"
        case .googlePay:
            return "tez"
        case .paytm:
            return "paytmmp"
        case .bhim:
            return "bhim"
        }
    }
}

enum UpiPackageName: String, CaseIterable {
    case phonepe = "com.phonepe.app"
    case googlePay = "com.google.android.apps.nbu.paisa.user"
    case paytm = "net.one97.paytm"
    case bhim = "in.org.npci.upiapp"
    case cred = "com.dreamplug.androidapp"

    static var allPackageNames: [String] {
          return UpiPackageName.allCases.map { $0.rawValue }
      }
}

protocol WalletPaymentProtocol : AnyObject {
    func sendDataToEventList(eventId : Int, position:Int)
}

protocol AstroTalkGoldProtocol : AnyObject {
    func sendDataToAstroTalkGold(isFromWalletPayementVc: Bool)
}
protocol LoyalMembershipPayment : AnyObject {
    func loyalMeberhipPaymentDone(iscomeFromWalletRecrahe:Bool)
}


public class PaymentManager {
    var giftSelectedIndex:Int = -1
    var controllerOBJ = UIViewController()
    var controllerString = String()
    
    private var razorpay : RazorpayCheckout!
//    var payPalConfig = PayPalConfiguration()
    var newAmountPayable: Float = 0.0
    var newAmountWithGST: Float = 0.0
    var coupanID = ""
    var userName = ""
    var usedCredit: Float = 0.0
    var usdPerRupee:Float = 0.0143
    var walletAmount:Float = 0.0
    var gstAmount:Float = 0.0
    var userId = ""
    var timeZone = "Asia/Kolkata"
    var paymentGatewayId: Int = 0
    var transactionID = ""
    var amountPayable: Float = 0.0
    var gstamountPayable: Float = 0.0
    var isBillingAddressPresent: Bool?
    var APP_ID:String = ""
    var BUSINESS_ID:String = ""
    var report_id = ""
    var consultantID = ""
    var txtOffer = Int()
    var kI_MOBILE:String = ""
    var paymentOptionArray:[AnyObject] = []
    var paymentOptionSelectArray:[Bool] = [Bool]()
    var selectedIndex:Int = -1
    var paymentTypestr = String()
    var paymentTypeId = String()
    internal var viewType = String()
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    var inappID = String()
    var isinappshow = Bool()
    var upiPaymentURL = String()
    weak var delegate : WalletPaymentProtocol?
    weak var GoldDelegate: AstroTalkGoldProtocol?
    weak var PaymentStatusDelegate : PaymentManagerPaymentStatusDelegate?
    weak var walletAmountUpdateDelegate: WalletAmountUpdateDelegate?
    var paymentMethodNameType : PaymentMethodNameType?
    var VERSION:String = ""
    private var networkManager = NetworkManager.shared
//    var QuickPaymentStatusDelegate: QuickRechargeBottomSheetDelegate?
    //weak var loyalMembershipDelegate: LoyalMembershipPayment?
    
    var eventId = -1
    var postionFromEventList = 0
//    private let appInvoke = AIHandler()  //Simulator Aman
    
    // @IBOutlet weak var heightTableView: NSLayoutConstraint!
    var tableViewHeight: CGFloat = 0
    var recoPaymentOptionArray:[AnyObject] = []
    var recoPaymentOptionSelectArray:[Bool] = [Bool]()
    var selectedSection:Int = Int()
    
    var paymentSheet: PaymentSheet?

    var fallBackMethod: FallBackMethod?
    internal var walletOptionArray:[AnyObject] = []
    internal var walletOptionSelectArray:[Bool] = [Bool]()
    internal var showWalletUI:Bool = Bool()
    internal var isExpandWallet:Bool = Bool()
    var user_mobile = String()
    internal var paymentLogRootData:PaymentLogRootClass?
    internal var callType:String = String()
    internal var isPaymentFromChatWindow:Bool = Bool()
    var UPIPaymentAppsPaymentInfo: [AnyObject] = []
    let upiIdArray = UpiPackageName.allPackageNames

    internal var isFirstRecharge: Bool = false
    internal var noOfDaysFromFirstRecharge: Int = -1
    internal var razorpayOrderId: String = ""
    internal var razorpayCustomerId = String()
    var viewController: UIViewController?
    var navController: UINavigationController?
    var paymentInProcess = false
    internal var autopayPositiveCta: String = ""
    internal var autoPayDescription: String = ""
    internal var autopayNegativeCta: String = ""
    internal var recurringPaymentsStatus: String = ""
    internal var recurringMandate: Bool = false
    var isCustomRecharge: Bool = false

    
    public static let shared = PaymentManager()
    
    public init() {}
  
    public func startPayment(withDetail Details: PaymentInfo, viewController: UIViewController?,navigationController: UINavigationController?) {
        
        let paymentGateWayDetails = Details.paymentGateWayDetails
        let amountDetails = Details.amoutDetails
        let generalDetails = Details.generalDetails
        let upiInfo = Details.upiInfo
        self.usdPerRupee = Details.amoutDetails.usdPerRupee
        self.APP_ID = Details.appDetails.appId
        self.BUSINESS_ID = Details.appDetails.bussinessId
        self.gstAmount = amountDetails.gstAmount
        self.newAmountPayable = amountDetails.amountPayable / usdPerRupee
        self.newAmountWithGST = amountDetails.newAmountWithGST
        self.coupanID = amountDetails.couponId
        self.timeZone = generalDetails.timeZone
        self.userId = generalDetails.userId
        self.walletAmount = amountDetails.walletAmount
        self.user_mobile = generalDetails.mobileNumber
        self.viewController = viewController
        self.navController = navigationController
        self.recurringPaymentsStatus = generalDetails.recurringPaymentsStatus
        self.paymentMethodNameType = PaymentMethodNameType(
            PG_method: paymentGateWayDetails.type,
            PG_Name: paymentGateWayDetails.methodName,
            PG_category: paymentGateWayDetails.category
        )
        self.kI_MOBILE = generalDetails.kiMobileNumber
        self.fallBackMethod = upiInfo?.fallBack
        self.paymentTypeId = paymentGateWayDetails.typeId
        self.paymentTypestr = paymentGateWayDetails.type
        self.viewType = paymentGateWayDetails.viewType
        self.VERSION = Details.appDetails.version
        self.userName = generalDetails.userName
        proceedPayment(
            index: Int(paymentGateWayDetails.gatewayId) ?? 0,
            methodName: paymentGateWayDetails.methodName
        )
        
    }
    
    private func handleUPIActions(upiMethod: UPIPaymentMethod) {
        if let index = UPIPaymentAppsPaymentInfo.firstIndex(where: { $0["methodName"] as? String == upiMethod.rawValue}) {
            print("Index found: \(index)")

            var gatewayId: String = String()
            var type: String = String()
            var typeId: String = String()
            var viewType: String = String()
            var methodName = String()

            gatewayId = self.UPIPaymentAppsPaymentInfo[index]["gatewayId"] as? String ?? String()
            type = self.UPIPaymentAppsPaymentInfo[index]["type"] as? String ?? String()
            typeId = self.UPIPaymentAppsPaymentInfo[index]["typeId"] as? String ?? String()
            methodName = self.UPIPaymentAppsPaymentInfo[index]["methodName"] as? String ?? ""
            viewType = self.UPIPaymentAppsPaymentInfo[index]["viewType"] as? String ?? ""

            self.paymentTypeId = typeId
            self.paymentTypestr = type
            self.viewType = viewType.uppercased()
            self.proceedPayment(index: Int(gatewayId) ?? 0, methodName: methodName)
        }
    }
    
    private func createAndOpenUPIIntent(razorpayIntentURL: String, razorpayTxId: String, methodName: String) {
        if let method = UPIPaymentMethod(rawValue: methodName) {
            if isAppInstalled(appName: method.appIntent) {
                let vc = DirectUPILoadingController(intentURL: razorpayIntentURL, razorpayTxId: razorpayTxId)
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                viewController?.present(vc, animated: true)
            }
        }
    }
    
    private func isAppInstalled(appName: String) -> Bool {
        let appScheme = "\(appName)://app"
        
        guard let appURL = URL(string: appScheme) else {
            return false
        }
        
        return UIApplication.shared.canOpenURL(appURL)
    }

    func proceedPayment(index: Int, methodName: String) {
        print(index)
//        if (index == 1 || index == 8) && (recurringPaymentsStatus == "inactive" || recurringPaymentsStatus == "expired") && timeZone != "Asia/Kolkata"  {
//            let vc = AutoPayBottomSheet(autoPayText: self.autoPayDescription, firstCTAText: self.autopayNegativeCta, secondCTAText: self.autopayPositiveCta)
//            
//            vc.autoPayCallback = {[weak self] in
//                guard let self = self else { return }
//                self.recurringMandate = true
//                self.handlePayment(index: index, methodName: methodName)
//            }
//            
//            vc.withoutAutoPayCallback = {[weak self] in
//                guard let self = self else { return }
//                self.handlePayment(index: index, methodName: methodName)
//            }
//            
//            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            viewController?.present(vc, animated: true, completion: nil)
//        } else {
            handlePayment(index: index, methodName: methodName)
//        }
    }

    private func handlePayment(index: Int, methodName: String) {
        newAmountWithGST = newAmountWithGST.roundToGst(places: 2)
        if newAmountWithGST > 0.0 {
            initializePaymentGateways(index: index, upiMethodName: methodName)
        } else {
//            showAlertView(title: "Error", message: "Something went wrong please contact Live Support Chat", ref: viewController ?? UIViewController())
        }
    }
    
    func initializePaymentGateways(index: Int, upiMethodName: String? = "") {
        if paymentMethodNameType?.PG_category?.uppercased() == "UPI" {
            paymentGatewayId = index
            self.paymentMethodNameType?.Gateway_name = "UPI"
            paymentLog(paymentType: .upi, index: index, upiMethodName: upiMethodName)
        }else {
            switch index {
            case 1:
                self.paymentMethodNameType?.Gateway_name = "Razorpay"
                paymentGatewayId = index
                paymentLog(paymentType: .razorpay, index: index)
                break
            case 2:
                self.paymentMethodNameType?.Gateway_name = "Razorpay"
                paymentGatewayId = index
                paymentLog(paymentType: .razorpay, index: index)
                break
            case 8:
                paymentGatewayId = index
                self.paymentMethodNameType?.Gateway_name = "Razorpay"
                paymentLog(paymentType: .razorpay, index: index)
                break
            case 4:
                self.paymentMethodNameType?.Gateway_name = "Paypal"
                paymentGatewayId = index
                paymentLog(paymentType: .paypal, index: index)
                break
                
            case 6:
                self.paymentMethodNameType?.Gateway_name = "Paytm"
                paymentGatewayId = index
//                self.newPaytmApihit()
                break
                
            case 3:
                self.paymentMethodNameType?.Gateway_name = "Inapp"
                paymentGatewayId = index
                paymentLog(paymentType: .inapp, index: index)
                break
                
            case 10:
                self.paymentMethodNameType?.Gateway_name = "Paypal12"
                paymentGatewayId = index
                paymentLog(paymentType: .paypal2, index: index)
                break
                
            case 9:
                self.paymentMethodNameType?.Gateway_name = "PayU"
                paymentGatewayId = index
                paymentLog(paymentType: .payu, index: index)
                break
                
            case 11:
                self.paymentMethodNameType?.Gateway_name = "Stripe"
                paymentGatewayId = index
                paymentLog(paymentType: .stripe, index: index)
               
            case 12:
                self.paymentMethodNameType?.Gateway_name = "Payoneer"
                if !(isBillingAddressPresent ?? false) {
                    let vc = PayoneerFillAddressVC()
                    vc.submitCompletionhandler = {[weak self] in
                        self?.paymentGatewayId = index
                        self?.paymentLog(paymentType: .payoneer, index: index)
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    viewController?.present(vc, animated: true)
                }else {
                    paymentGatewayId = index
                    paymentLog(paymentType: .payoneer, index: index)
                }
            default:
                break
            }
        }
    }

    var couponString = String()
    
    

    func paymentLog(paymentType: PaymentType,index: Int,txnToken:String = "",cutomerId:String = "",orderId:String = "", upiMethodName: String? = "") {
        
        //Clever tap event
   // MARK : - To change
//        if let userId = kUserDefault.string(forKey: kUSER_ID) {
//            AnalyticsManager.shared.logEvent(forDatabaseType: [.appsFlyer, .cleverTap], eventName: EventName.FinalPaymentPvClick, parameters: ["PG_source": "PG_main_flow", "PG_method": self.paymentMethodNameType?.PG_method ?? "", "amount":"\(newAmountWithGST)", "PG_Name": self.paymentMethodNameType?.PG_Name ?? "", "GatewayName": self.paymentMethodNameType?.Gateway_name ?? "", "userId": userId, "Currency_actual": kDollarSymbol])
//        }
        var params = [
            "userId":userId,
            "amount":((self.newAmountPayable).roundToGst(places: 2)),
            "timeZone":timeZone,
            "discount":0,
            "appId":APP_ID,
            "paymentGatewayId":paymentGatewayId,
            "gst":gstAmount,
            "businessId":BUSINESS_ID,
            "paymentTypeId":self.paymentTypeId,
            "recurringMandate": self.recurringMandate
        ] as [String : Any]
        
        if isCustomRecharge {
            params["isCustomRechargeAmount"] = isCustomRecharge
        }
        switch paymentType {
        case .paytm:
            params["transactionId"] = orderId
            if coupanID != "" {
                params["couponId"] = coupanID
            }
            if self.paymentGatewayId == 4 {
                if self.newAmountPayable < 35 {
                    params["amount"] = 35
                }
                params["isForeignPaypal"] = true
                params["paymentGatewayId"] = "8"
            }else if self.paymentGatewayId == 10 {
                if self.newAmountPayable < 35 {
                    params["amount"] = 35
                }
                params["isForeignPaypal"] = true
                params["paymentGatewayId"] = "10"
            }else{
                params["isForeignPaypal"] = false
            }
            
        default :
            if coupanID != "" {
                params["couponId"] = coupanID
            }
            if self.paymentGatewayId == 4 {
                if self.newAmountPayable < 35 {
                    params["amount"] = 35
                }
                params["isForeignPaypal"] = true
                params["paymentGatewayId"] = "8"
            }else if self.paymentGatewayId == 10 {
                if self.newAmountPayable < 35 {
                    params["amount"] = 35
                }
                params["isForeignPaypal"] = true
                params["paymentGatewayId"] = "10"
            }else if self.paymentGatewayId == 11 {
                if self.newAmountPayable < 35 {
                    params["amount"] = 35
                }
                params["isForeignStripe"] = true
                params["isForeignPaypal"] = false
                params["paymentGatewayId"] = "11"
            } else{
                params["isForeignPaypal"] = false
            }
            
        }
        
        if self.isPaymentFromChatWindow{
            params["isPaymentFromChatWindow"] = self.isPaymentFromChatWindow
        }
//        printLog(log: params)
        networkManager.postRequest(kPostPaymentLog_url,
                    params: params as [String : AnyObject]?,
                    oauth: true,
                    result:
                        {
            (response: JSON?, error: NSError?, statuscode: Int) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.PaymentStatusDelegate?.handleFailureCases(error: error?.localizedDescription ?? "")
//                    self.viewController?.view.makeToast(error?.localizedDescription, duration: 2.0, position: CSToastPositionCenter)
                }
                return
            }
            debugPrint(response)
            guard let response = response else { return }
            if response["status"].stringValue == "fail" {
                print(response["reason"].stringValue)
                self.PaymentStatusDelegate?.handleFailureCases(error: error?.localizedDescription ?? "")
//                self.viewController?.view.makeToast(response["reason"].stringValue, duration: 2.0, position: CSToastPositionBottom)
            } else {
                if statuscode == 200 || statuscode == 201 {
                    let dataObject = response
//                    printLog(log: dataObject)
                    self.isFirstRecharge = response["data"]["isFirstRecharge"].boolValue
                    self.noOfDaysFromFirstRecharge = response["data"]["noOfDaysFromFirstRecharge"].int ?? -1
                    self.paymentLogRootData = PaymentLogRootClass(fromDictionary: response.dictionaryObject ?? [:])
                    self.transactionID = dataObject["data"]["transactionId"].stringValue
                    self.razorpayOrderId = dataObject["data"]["razorpayOrderId"].stringValue
                    self.razorpayCustomerId = dataObject["data"]["razorpayCustomerId"].stringValue
                    if let currency = self.paymentLogRootData?.data?.currencyCode,
                       let conversionFactor = self.paymentLogRootData?.data?.currencyConversionFactor {
                        var selectedPrice: Float = Float(conversionFactor)
                        if selectedPrice >= 1 {
                            selectedPrice = 1/selectedPrice
                        }
//                        kUserDefault.set(selectedPrice.roundTo(places: 8), forKey: kUSD_PER_RUPEE)
//                        kUserDefault.set(currency, forKey: k_Dollar_Symbol)
//                        kDollarSymbol = currency
                    }
                    
                    //   kDollarSymbol = self.paymentLogRootData?.data?.currencyCode ?? "INR"
                    //   self.usdPerRupee = Float(self.paymentLogRootData?.data?.currencyConversionFactor ?? Double())
                    
                    // self.branch_Event_Report(paymentGatewayTxID:"", branchEvent: .initiatePurchase, username: self.userId, amount:self.amountPayable, gstamount:self.gstAmount, description: "Wallet Recharge")
                    
                    switch paymentType {
                    case .paytm:
                        self.initilizePayTm(txnToken: txnToken, cutomerId: cutomerId, orderId: orderId)
                        break
                    case .paypal:
                        // self.initilizePayPal()
                        self.initializeRazorPay(index: index, transactionID: self.transactionID, paymentTypestr: self.paymentTypestr)
                        break
                        
                    case .paypal2:
                        // self.initilizePayPal()
                        print("HIT PAYPAL SDK...")
                        let f_amount =  dataObject["data"]["finalAmount"].stringValue
                        
                        let paymentGatewayTransactionId = dataObject["data"]["paymentGatewayTransactionId"].stringValue
                        
                        print(paymentGatewayTransactionId)
                        self.triggerPayPalCheckout(index: index, transactionID: paymentGatewayTransactionId, paymentTypestr: self.paymentTypestr,amount: f_amount)
                        break
                    case .razorpay:
                        self.initializeRazorPay(index: index, transactionID: self.transactionID, paymentTypestr: self.paymentTypestr)
                        break
                    case .inapp:
//                        self.initiateInAppPayment()
                        break
                    case .payu:
                        // self.initiateInAppPayment()
                        self.payuDataSetup(response: dataObject["data"].dictionaryValue)
                        break
                    case .stripe:
                        self.stripePaymentServerDict = dataObject["data"].dictionaryValue
                        self.stripeAddressSheet(response: dataObject["data"].dictionaryValue)
                        break
                    case .payoneer:
                        self.payoneerDataSetup(response: dataObject["data"].dictionaryValue)
                    case .upi:
                        if let method = UPIPaymentMethod(rawValue: upiMethodName ?? ""),
                           self.isAppInstalled(appName: method.appIntent) {
                            let upiPaymentURL = dataObject["data"]["upiPaymentLink"].stringValue
                            if !upiPaymentURL.isEmpty {
                                self.createAndOpenUPIIntent(razorpayIntentURL: upiPaymentURL, razorpayTxId:  self.transactionID, methodName: upiMethodName ?? "")
                            }else {
                                self.createAndOpenUPIIntent(razorpayIntentURL:  dataObject["data"]["iOSRazorPayLink"].stringValue, razorpayTxId:  self.transactionID, methodName: upiMethodName ?? "")
                            }
                        }else {
                            
                            self.paymentTypeId = String(self.fallBackMethod?.typeId ?? -1)
                            self.paymentTypestr = self.fallBackMethod?.type ?? ""
                            self.paymentMethodNameType = PaymentMethodNameType(PG_method: self.fallBackMethod?.type ?? "", PG_Name: self.fallBackMethod?.methodName ?? "")
                            self.viewType = self.fallBackMethod?.viewType?.uppercased() ?? ""
                            self.proceedPayment(index: self.fallBackMethod?.gatewayId ?? 0, methodName: self.fallBackMethod?.methodName ?? "")
//                            self.initializeRazorPay(index: index, transactionID: self.transactionID, paymentTypestr: self.paymentTypestr)
                        }
                    case .hdfc:
                        /// Need to handle hdfc
                        break
                        
                    }
                } else {
                    let errorResponse = response["error"].stringValue
                    print(error?.localizedDescription)
                    print(errorResponse)
                    if (errorResponse != "") {
                        //                                        showAlertView(title: "Error", message: errorResponse ?? "", ref: self)
//                        self.viewController?.view.makeToast(errorResponse, duration: 2.0, position: CSToastPositionCenter)
                        
                    }else{
                        DispatchQueue.main.async {
//                            self.viewController?.view.makeToast(error?.localizedDescription ?? "\(ApiNotWorking)", duration: 2.0, position: CSToastPositionCenter)
                        }
                    }
                }
            }
        })
    }
    
    var addressDetails : AddressViewController.AddressDetails?
    var addressViewController: AddressViewController?
    var stripePaymentServerDict: [String:JSON]?
    //MARK: ************************************ Spripe Data Sutup **************************************
    func stripeAddressSheet(response: [String:JSON]) {
        let payDict = response["stripePaymentDTO"]?.dictionaryValue
        
        let publishableKey = payDict?["stripePublishKey"]?.stringValue ?? "0"
        StripeAPI.defaultPublishableKey = publishableKey
        STPAPIClient.shared.publishableKey = publishableKey
        
        let address = payDict?["address"]?.dictionaryValue
        if address?.keys.count ?? 0 > 0 {
            
            let city = address?["city"]?.stringValue ?? "Delhi"
            let country = address?["country"]?.stringValue ?? "INDIA"
            let line1 = address?["line1"]?.stringValue ?? ""
            let postalCode = address?["postalCode"]?.stringValue ?? ""
            let state = address?["state"]?.stringValue ?? ""
            let name = address?["name"]?.stringValue ?? ""
            let phone = address?["phone"]?.stringValue ?? ""
            
            let addressConfiguration = AddressViewController.Configuration(defaultValues: .init(address: PaymentSheet.Address.init(city: city, country: country, line1: line1, line2: "", postalCode: postalCode, state: state), name: name, phone: phone, isCheckboxSelected: false),
                                                                           additionalFields: .init(phone: .required),
                                                                           allowedCountries: [],
                                                                           title: "Billing Address"
            )
            addressViewController = AddressViewController(configuration: addressConfiguration, delegate: self)
            let navigationController = UINavigationController(rootViewController: addressViewController ?? AddressViewController(configuration: addressConfiguration, delegate: self))
            
            viewController?.dismiss(animated: true, completion: {
                self.viewController?.present(navigationController, animated: true)
            })
            
        } else {
            let addressConfiguration = AddressViewController.Configuration(
                additionalFields: .init(phone: .required),
                allowedCountries: [],
                title: "Billing Address"
            )
            addressViewController = AddressViewController(configuration: addressConfiguration, delegate: self)
            let navigationController = UINavigationController(rootViewController: addressViewController ?? AddressViewController(configuration: addressConfiguration, delegate: self))
            viewController?.dismiss(animated: true, completion: {
                self.viewController?.present(navigationController, animated: true)
            })
        }
    }
    
    func stripeDataSetup(response: [String:JSON]) {
        
        let payDict = response["stripePaymentDTO"]?.dictionaryValue
        if payDict?.keys.count ?? 0 > 0 {
            
            //            let customerId = payDict?["customerId"]?.stringValue ?? "0"
            //            let customerEphemeralKeySecret = payDict?["ephemeralSecret"]?.stringValue ?? "0"
            let paymentIntentClientSecret = payDict?["clientSecret"]?.stringValue ?? "0"
            let publishableKey = payDict?["stripePublishKey"]?.stringValue ?? "0"
            
            let city = self.addressDetails?.address.city ?? "Delhi"
            let country = self.addressDetails?.address.country ?? "INDIA"
            let line1 = self.addressDetails?.address.line1 ?? ""
            let postalCode = self.addressDetails?.address.postalCode ?? ""
            let state = self.addressDetails?.address.state ?? ""
            let name = self.addressDetails?.name ?? ""
            let phone = self.addressDetails?.phone ?? ""
            
            STPAPIClient.shared.publishableKey = publishableKey
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            
            configuration.merchantDisplayName = "Astrotalk"
            //            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            
            configuration.defaultBillingDetails.address = .init(city: city, country: country, line1: line1, line2: "", postalCode: postalCode, state: state)
            configuration.defaultBillingDetails.name = name
            
            let shippingDetail = AddressViewController.AddressDetails.init(address: .init(city: city, country: country, line1: line1, line2: "", postalCode: postalCode, state: state), name: name, phone: phone, isCheckboxSelected: false)
            configuration.shippingDetails = { [weak self] in
                return shippingDetail
            }
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = false
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        }
        
        DispatchQueue.main.async {
            
            self.transactionID = response["transactionId"]?.stringValue ?? "0"
            let paymentGatewayTxID = payDict?["transactionId"]?.stringValue ?? "0"
            self.paymentTypeId = response["paymentTypeId"]?.stringValue ?? "0"
            
            self.paymentSheet?.present(from: self.viewController ?? UIViewController()) { paymentResult in
                // MARK: Handle the payment result
                switch paymentResult {
                case .completed:
                    print("Your order is confirmed")
//                    self.QuickPaymentStatusDelegate?.showSuccessDialog()
                    self.completePayment(txStatus: .completed, paymentGatewayTxID: paymentGatewayTxID, receiptIos: "")
                case .canceled:
                    print("Canceled!")
                    self.completePayment(txStatus: .failed, paymentGatewayTxID: paymentGatewayTxID, receiptIos: "")
                case .failed(let error):
                    print("Payment failed: \(error)")
                    self.completePayment(txStatus: .failed, paymentGatewayTxID: paymentGatewayTxID, receiptIos: "")
                }
            }
        }
    }
    
    func payuDataSetup(response:[String:JSON]) {
        var postdata = [String:String]()
        postdata["amount"] = String(format: "%.2f", newAmountWithGST * usdPerRupee)//"\(newAmountWithGST.roundToGst(places: 2))"
        postdata["surl"] = response["payURedirectionUrl"]?.stringValue
        postdata["txnid"] = response["transactionId"]?.stringValue
        postdata["furl"] = response["payURedirectionUrl"]?.stringValue
        postdata["hash"] = response["transactionHash"]?.stringValue
        postdata["email"] = kI_MOBILE
        postdata["lastname"] = ""
        postdata["firstname"] = self.userName
        postdata["productinfo"] = self.getProductInfo(orderType: .wallet)
        postdata["phone"] = kI_MOBILE
//        printLog(log: postdata)
        let vc = PayUWebView()
        vc.payuData = postdata
        vc.eventId = self.eventId
        vc.postionFromEventList = self.postionFromEventList
        vc.delegate = self.delegate
        vc.GoldDelegate = GoldDelegate
        vc.controllerOBJ = self.controllerOBJ
        vc.controllerString = self.controllerString
        vc.walletDelegate = self
        navController?.pushViewController(vc, animated: true)
    }
    
    func payoneerDataSetup(response:[String:JSON]) {
        debugPrint(response)
        if let payoneerSuccessUrl = response["payoneerSuccessUrl"]?.stringValue,
           let payoneerFailUrl = response["payoneerFailUrl"]?.stringValue,
           let payoneerRedirectUrl = response["payoneerRedirectUrl"]?.stringValue {
            let vm = PayoneerWebViewModel(payoneerSuccessStringUrl: payoneerSuccessUrl,
                                          payoneerFailStringUrl: payoneerFailUrl,
                                          payoneerRedirectUrl: payoneerRedirectUrl)
            let vc = PayoneerWebView(viewModel: vm)
            vc.delegate = self
            navController?.pushViewController(vc, animated: true)
        }
    }
    
    func getProductInfo(orderType:OrderType) -> String{
        switch orderType {
        case .wallet:
            return  "Astrotalk - Wallet Recharge"
            
        case .report:
            return "Astrotalk - Report Purchase"
            
        case .shop:
            return "Astrotalk - Pooja Purchase"
            
        case .call:
            return "Astrotalk - Wallet Recharge"
            
        case .chat:
            return "Astrotalk - Wallet Recharge"
            
        case .question:
            return "Astrotalk - Question Purchase"
            
        case .video_call:
            return "Astrotalk - Wallet Recharge"
        }
    }
    
    func completePayment(txStatus: TransectionStatus, paymentGatewayTxID: String,receiptIos:String) {
//        MyLoader.showLoading(viewController?.view)
        var txStatus = txStatus
        var params:[String: Any] = [
            "txID":transactionID,
            "txStatus":txStatus.rawValue,
            "paymentGatewayTxID":paymentGatewayTxID,
            "paymentTypeId":self.paymentTypeId,
            "appVersion":VERSION,
            "receiptIos":receiptIos,
            "productIdIos":self.inappID,
            "appId": APP_ID
        ]
        
        if self.paymentGatewayId == 4 || self.paymentGatewayId == 10 {
            params["isForeignPaypal"] = true
        } else if self.paymentGatewayId == 11 {
            params["isForeignStripe"] = true
            params["isForeignPaypal"] = false
        } else {
            params["isForeignPaypal"] = false
        }
        //        let params:[String: Any] = ["txID": "PTM-1642591437345-2379748", "receiptIos": "", "isForeignPaypal": false, "appVersion": "11.2.93", "productIdIos": "", "paymentGatewayTxID": "PTM-1642591437345-2379748", "txStatus": "COMPLETED", "paymentTypeId": "10"]
//        printLog(log: params)
        networkManager.postRequest(kPostPaymentComplete_url, params: params as [String : AnyObject]?,oauth: true, result:
                        {
            (response: JSON?, error: NSError?, statuscode: Int) in
//            MyLoader.hideLoadingView()
            guard error == nil else {
                DispatchQueue.main.async {
                    self.PaymentStatusDelegate?.handleFailureCases(error: error?.localizedDescription ?? "")
//                    self.viewController?.view.makeToast(error?.localizedDescription, duration: 2.0, position: CSToastPositionCenter)
                }
                return
            }
            guard let response = response else { return }
            if response["status"].stringValue == "fail" {
                debugPrint(response)
                self.PaymentStatusDelegate?.handleFailureCases(error:response["reason"].stringValue)

//                AnalyticsManager.shared.logEvent(forDatabaseType: [.cleverTap, .appsFlyer], eventName: .PaymentFailedCheckStatus, parameters: ["source" : "Wallet_Recharge_Page"])
                
                let isToShowNewPaymentFailedView = self.paymentLogRootData?.data?.isToShowNewPaymentFailedView ?? Bool()
                
                if isToShowNewPaymentFailedView{
//                    
//                    AnalyticsManager.shared.logEvent(forDatabaseType: [.appsFlyer, .cleverTap], eventName: EventName.PaymentFailPopupView,parameters: ["PG_method": self.paymentMethodNameType?.PG_method ?? "", "PG_Name": self.paymentMethodNameType?.PG_Name ?? "", "GatewayName": self.paymentMethodNameType?.Gateway_name ?? ""])
//                    
//                    let myAlert = FailedPaymentPopupViewC()
//                    myAlert.paymentMethodNameType = self.paymentMethodNameType
//                    myAlert.callBackSuccess = { [weak self] (info) in
//                        guard let this = self else {return}
//                        
//                        var gatewayId:String = String()
//                        var type:String = String()
//                        var typeId:String = String()
//                        var viewType: String = String()
//                        var methodName = String()
//                        
//                        gatewayId = "\(info.gatewayId ?? Int())"
//                        type = "\(info.type ?? String())"
//                        typeId = "\(info.typeId ?? Int())"
//                        methodName = "\(info.methodName ?? String())"
//                        viewType = "\(info.viewType ?? String())"
//                        
//                        this.paymentTypeId = typeId
//                        this.paymentTypestr = type
//                        this.viewType = viewType.uppercased()
//                        this.paymentMethodNameType = PaymentMethodNameType(PG_method: type, PG_Name: methodName)
//                        this.proceedPayment(index: Int(gatewayId) ?? 0, methodName: methodName)
//                        
//                    }
//                    myAlert.paymentLogRootData = self.paymentLogRootData
//                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                    self.viewController?.dismiss(animated: true){
//                        self.viewController?.present(myAlert, animated: true, completion: nil)
//                    }
//                    
                    
                }else{
                    self.viewController?.dismiss(animated: true){
//                        self.viewController?.presentAlertClass(paymentMethodName: self.paymentMethodNameType ?? PaymentMethodNameType())
                    }
                }
                
                
            } else {
                if statuscode == 200 || statuscode == 201 {

//                    printLog(log: response)
                    
                    let data = response["data"].dictionaryValue
                    let registerDays = data["registerDays"]?.intValue
                    
                    let transactionStatus = response["data"]["status"].stringValue
                    
                    if !transactionStatus.isEmpty,
                       let status =  TransectionStatus(rawValue: transactionStatus) {
                        txStatus = status
                    }
                   
                    if txStatus == .completed {
//                        kUserDefault.set(true, forKey: "TipMinutes")
//                        self.showSuccessfullDialoge()
                        self.PaymentStatusDelegate?.handleSuccessCases(registeredDaysForEvents: registerDays ?? -1,isFirstRecharge: self.isFirstRecharge)
//                        self.logComopleteEventAccordingToLogic(response: response, isFirstRecharge: self.isFirstRecharge)
                    } else {
//                        
//                        AnalyticsManager.shared.logEvent(forDatabaseType: [.cleverTap, .appsFlyer], eventName: .PaymentFailedCheckStatus, parameters: ["source" : "Wallet_Recharge_Page"])
                        
                        let isToShowNewPaymentFailedView = self.paymentLogRootData?.data?.isToShowNewPaymentFailedView ?? Bool()
                        
                        if isToShowNewPaymentFailedView{
//                            AnalyticsManager.shared.logEvent(forDatabaseType: [.appsFlyer, .cleverTap], eventName: EventName.PaymentFailPopupView,parameters: ["PG_method": self.paymentMethodNameType?.PG_method ?? "", "PG_Name": self.paymentMethodNameType?.PG_Name ?? "", "GatewayName": self.paymentMethodNameType?.Gateway_name ?? ""])
//                            let myAlert = FailedPaymentPopupViewC()
//                            myAlert.paymentMethodNameType = self.paymentMethodNameType
//                            myAlert.callBackSuccess = { [weak self] (info) in
//                                guard let this = self else {return}
//                                
//                                var gatewayId:String = String()
//                                var type:String = String()
//                                var typeId:String = String()
//                                var viewType: String = String()
//                                var methodName = String()
//                                
//                                gatewayId = "\(info.gatewayId ?? Int())"
//                                type = "\(info.type ?? String())"
//                                typeId = "\(info.typeId ?? Int())"
//                                methodName = "\(info.methodName ?? String())"
//                                viewType = "\(info.viewType ?? String())"
//                                
//                                this.paymentTypeId = typeId
//                                this.paymentTypestr = type
//                                this.viewType = viewType.uppercased()
//                                this.paymentMethodNameType = PaymentMethodNameType(PG_method: type, PG_Name: methodName)
//                                this.proceedPayment(index: Int(gatewayId) ?? 0, methodName: methodName)
//                                
//                            }
//                            self.PaymentStatusDelegate?.handleFailureCases(error: "Payment Failed.")
//                            myAlert.paymentLogRootData = self.paymentLogRootData
//                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                            self.viewController?.present(myAlert, animated: true, completion: nil)
                            
                            
                        }else{
                            self.PaymentStatusDelegate?.handleFailureCases(error: "Payment Failed.")
                            self.viewController?.dismiss(animated: true, completion: {
//                                self.viewController?.presentAlertClass(paymentMethodName: self.paymentMethodNameType ?? PaymentMethodNameType())
                            })
                           
                        }
                        
                        // showAlertView(title: "Failed", message: "", ref: self)
                    }
                } else {
                    //showAlertView(title: "Error", message: "Something went Wrong.We are working on it.", ref: self)
                }
            }
        })
    }

    
//    func showSuccessfullDialoge() {
//        NotificationCenter.default.post(name: Notification.Name("RecharheDone"), object: nil)
//        navController?.navigationBar.barTintColor = AppColors.appNavBarColor
//        navController?.navigationBar.backgroundColor = AppColors.appNavBarColor
//        navController?.setStatusBar(backgroundColor: AppColors.appStatusBarColor)
//        viewController?.view.makeToast("Payment success", duration: 3.0, position: CSToastPositionBottom)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            
//            if (self.controllerString == "QUICK_RECHARGE"){
//                AppSharedVariables.shared.setQuickRechargeDesignNumber(designNumber: 0)
//                let deviceToken = kUserDefault.object(forKey: kDEVICE_TOKEN) as? String ?? ""
//                let userId = kUserDefault.object(forKey: kUSER_ID) as? String ?? ""
//                self.postDeviceTokenToServer(user_id: userId, deviceToken: deviceToken, voipToken: "")
//                self.walletAmountUpdateDelegate?.handleSuccess()
//                self.QuickPaymentStatusDelegate?.showSuccessDialog()
//            }else if self.controllerString.isEmpty == false {
//                if self.controllerString == "EventList"{
//                    self.delegate?.sendDataToEventList(eventId: self.eventId,position: self.postionFromEventList)
//                    self.navController?.popViewController(animated: true)
//                } else if self.controllerString == "VoIPCall"{
//                    if SharedVariables.getIsCallInProgress(){
//                        self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                    } else{
//                        let delegate = UIApplication.shared.delegate as? AppDelegate
//                        delegate?.notificationDict.removeAll()
//                        delegate?.onBoardingSucess_Home()
//                    }
//                } else if self.controllerString == "Astrotalk Gold" {
//                    self.GoldDelegate?.sendDataToAstroTalkGold(isFromWalletPayementVc: true)
//                    //                    NotificationCenter.default.post(name: Notification.Name("AstroTalkGoldRecharge"), object: nil, userInfo: ["isRecharge": true])
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                } else if self.controllerString == "chat" {
//                    NotificationCenter.default.post(name: NSNotification.Name("chatRefrestAfterLowBalenchRecharge"), object: nil)
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }else if self.controllerString == "LIVE_EVENT"{
//                    // YAHA MOD LAGANA HAI
//                    
////                    if JoinWaitlist_OpneIntakeFormMod.sharedInstance.isOpenIntake {
////                        NotificationCenter.default.post(name: Notification.Name("JOIN_WATILIST_AFTER_RECHARGE"), object:self.callType, userInfo: [:])
////                    }
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }else if self.controllerString ==  "LIVE_EVENT_SO"{
//                    NotificationCenter.default.post(name: Notification.Name("HIDE_POPUP_SO_CONTINUE_CALL"), object:nil, userInfo: [:])
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }else if self.controllerString ==  "CALL_HOLD"{
//                    
//                    NotificationCenter.default.post(name: Notification.Name("CALL_HOLD_AND_CALL"), object:nil, userInfo: [:])
//                    
//                } else if self.controllerString == "ASTROLOGERLIST_LOWBALANCE" {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                        // your code here
//                        self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                        NotificationCenter.default.post(name: Notification.Name("connectPopupAfterLowBalenchRecharge"), object:nil, userInfo: [:])
//                    }
//                } else if self.controllerString == "history" {
//                    
//                    // YAHA...!
//                    
//                    // YAHA MOD LAGANA HAI
////                    if JoinWaitlist_OpneIntakeFormMod.sharedInstance.isOpenIntake {
////                        NotificationCenter.default.post(name: Notification.Name("JOIN_WATILIST_AFTER_RECHARGE_HISTORY"), object:nil, userInfo: [:])
////                    }
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                } else if self.controllerString == "Profile" {
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                    NotificationCenter.default.post(name: Notification.Name("profileRefreshAfterLowBalenchRecharge"), object:nil, userInfo: [:])
//                } else if self.controllerString == "LiveStreamVC" {
//                    NotificationCenter.default.post(name: Notification.Name("RERUN_LIVE_EVENT"), object:self.giftSelectedIndex, userInfo: [:])
////                    self.navController?.popToViewController(ofClass: LiveStreamSlideVC.self)
////                    popBackToControllerCount(3, self: self.viewController ?? UIViewController())
//                } else if self.controllerString == "membership" {
//                    NotificationCenter.default.post(name: Notification.Name("payMemberShipLowBalance"), object:nil, userInfo: [:])
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                } else if self.controllerString == "loyal" {
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }else if self.controllerString == "loyalProfileMembership" {
//                    NotificationCenter.default.post(name: Notification.Name("refreshAstrologerProfile"),object:nil, userInfo: ["iscomeFromWallet":true])
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }else if self.controllerString == "loyalClubMembership" {
//                    NotificationCenter.default.post(name: Notification.Name("refreshLoyalClubProfile"),object:nil, userInfo: ["iscomeFromWallet":true])
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }
//                else if self.controllerString == "loyalClubList" {
//                    NotificationCenter.default.post(name: Notification.Name("refreshLoyalClubList"),object:nil, userInfo: ["iscomeFromWallet":true])
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                } else if self.controllerString == "loyalClubSearch" {
//                    NotificationCenter.default.post(name: Notification.Name("refreshLoyalClubSearch"),object:nil, userInfo: ["iscomeFromWallet":true])
//                    
//                    self.navController?.popToViewController(self.controllerOBJ, animated: true)
//                }
//                //                else if self.controllerString == "Astrologerlist" {
//                //                    self.tabBarController?.selectedIndex = 1
//                //                }
//                else{
//                    //                    let vc = WListDetailsVC()
//                    //                    vc.selectionTag = 1
//                    //                    self.navigationController?.pushViewController(vc, animated: true)
//                    //                    self.navigationController?.popToViewController(self.controllerOBJ, animated: true)
//                    NotificationCenter.default.post(name: Notification.Name("onBoardingPaymentSucess"), object:nil, userInfo: ["value":0])
//                }
//            }else{
//                //                let navController = UINavigationController(rootViewController:  WListDetailsVC())
//                //                self.revealViewController().setFront(navController, animated: true)
//                //                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
//                //                let vc = WListDetailsVC()
//                //                vc.selectionTag = 1
//                //                self.navigationController?.pushViewController(vc, animated: true)
//                NotificationCenter.default.post(name: Notification.Name("onBoardingPaymentSucess"), object:nil, userInfo: ["value":0])
//                
//            }
//            //})
//            //        alertController.addAction(okAction)
//            //        self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logCompleteTutorialEvent(contentData : String, contentId : String, success : String) {
//        if NetworkManager.selectedEnvironment == .production {
//            Settings.shared.isAutoLogAppEventsEnabled = true
//            Settings.shared.isAdvertiserTrackingEnabled = true
//            Settings.initialize()
//
//            let userid = kUserDefault.value(forKey: kUSER_ID) ?? ""
//            let ammount = Int(amountPayable.roundToGst(places: 2))
//            let parameters: [AppEvents.ParameterName: String] = [AppEvents.ParameterName.content:contentData,
//                                                                 AppEvents.ParameterName.contentID:self.transactionID,
//                                                                 AppEvents.ParameterName.success:success,
//                                                                 .init(rawValue: "UserId"):"\(userid)",
//                                                                 AppEvents.ParameterName.currency:("INR"),]
//            AppEvents.shared.logEvent(.purchased, valueToSum:Double(ammount), parameters: parameters)
//        }
    }
    func logCompleteTutorialEvent_SPENT_CREDITS(contentData : String, contentId : String, success : String) {
//        if NetworkManager.selectedEnvironment == .production {
//            Settings.shared.isAutoLogAppEventsEnabled = true
//            Settings.shared.isAdvertiserTrackingEnabled = true
//            Settings.initialize()
//            let userid = kUserDefault.value(forKey: kUSER_ID) ?? ""
//            let ammount = Int((self.newAmountPayable).roundToGst(places: 2))
//            let parameters: [AppEvents.ParameterName: String] = [AppEvents.ParameterName.content:contentData,
//                                                                 AppEvents.ParameterName.contentID:self.transactionID,
//                                                                 AppEvents.ParameterName.success:success,
//                                                                 .init(rawValue: "UserId"):"\(userid)",
//                                                                 AppEvents.ParameterName.currency:("INR")]
////            AppEvents.shared.logEvent(.spentCredits, valueToSum:Double(ammount), parameters: parameters)
//        }
    }
    
    //MARK: razorpay /////////////////////////////////////////////////////
    
    func initializeRazorPay(index: Int,transactionID:String,paymentTypestr:String) {
        if NetworkManager.selectedEnvironment == .production {
            switch index {
            case 1: //Codeyeti
                razorpay = RazorpayCheckout.initWithKey(kRaorpay_codeyetiLive, andDelegate: self)
            case 2: //Maskyeti
                razorpay = RazorpayCheckout.initWithKey(kRazorPayKeyNew_MaskyetiLive, andDelegate: self)
            default: //Astrotalk
                 razorpay = RazorpayCheckout.initWithKey(kRazorPayKey_AstrotalkLive, andDelegate: self)
            }
        }else{
            switch index {
            case 1: //Codeyeti
                razorpay = RazorpayCheckout.initWithKey(kRazorPayKey_codeyetiTest, andDelegate: self)
            case 2: //Maskyeti
                razorpay = RazorpayCheckout.initWithKey(kRazorPayKey_maskyetiTest, andDelegate: self)
            default: //Astrotalk
                razorpay = RazorpayCheckout.initWithKey(kRazorPayKey_AstrotalkTest, andDelegate: self)
            }
        }
        showPaymentForm(transactionID: transactionID, paymentTypestr: paymentTypestr)
    }
    
    func showPaymentForm(transactionID:String,paymentTypestr:String) {
        var ammount = Int((self.newAmountWithGST * 100).rounded())
        // let user_email = kUserDefault.value(forKey: kUSER_EMAIL) as! String
        // let user_mobile =  "9999999999"
        //        let user_name = kUserDefault.value(forKey: kUSER_NAME) as? String ?? ""
        let userId = self.userId
        if self.paymentGatewayId == 4 {
            if ammount > 3500 {
                ammount = Int((Float(ammount) * self.usdPerRupee).rounded())
                var options = [
                    "amount" : ammount,
                    "currency": kDollarSymbol,
                    "image" : RAZORPAY_APP_LOGO,
                    "name" : "Astrotalk",
                    "description" : "",
                    "prefill" : ["method":self.viewType == "METHOD" ? paymentTypestr : "",
                                 "contact": "\(user_mobile)",
                                 "wallet":false] as [String : Any],
                    "theme" : ["color":kPrimaryColorStr],
                    "notes" : ["astro_order_id":transactionID,"user_id":userId]
                ] as [String : Any]
                
                if paymentTypestr.uppercased() == "CRED"{      ///CRED PAY
                    var configJson:[String : Any] = [String : Any]()
                    var display:[String : Any] = [String : Any]()
                    var blocks:[String : Any] = [String : Any]()
                    var custom:[String : Any] = [String : Any]()
                    custom["name"] = "Pay with Apps"
                    var instrumentsArray:[Any] = [Any]()
                    var methodJson:[String : Any] = [String : Any]()
                    methodJson["method"] = "app"
                    methodJson["providers"] = ["cred"]
                    instrumentsArray.append(methodJson)
                    custom["instruments"] = instrumentsArray
                    blocks["custom"] = custom
                    display["blocks"] = blocks
                    display["sequence"] = ["block.custom"]
                    display["preferences"] = ["show_default_blocks":false]
                    configJson["display"] = display
                    options["prefill"] = ["contact": user_mobile]
                    options["config"] = configJson
                    
                }
                
                if !razorpayOrderId.isEmpty {
                    options["order_id"] = razorpayOrderId
                }
                
                if !razorpayCustomerId.isEmpty {
                    options["customer_id"] = razorpayCustomerId
                }
                
                if self.recurringMandate {
                    options["recurring"] = "1"
                }
                
                print("\(options)")

                self.razorpay.open(options)
                
                
            }else{
                self.loadAlert_For_paypal_payment { (isPreceed) in
                    if isPreceed == true && ammount < 3500{
                        ammount = 3500
                        ammount = Int((Float(ammount) * self.usdPerRupee).rounded())
                        var options = [
                            "amount" : ammount,"currency":kDollarSymbol,"image" : RAZORPAY_APP_LOGO, "name" : "Astrotalk","description" : "","prefill" : ["method":self.viewType == "METHOD" ? paymentTypestr : "","contact": "\(self.user_mobile)","wallet":false] as [String : Any], "theme" : ["color":kPrimaryColorStr], "notes" : ["astro_order_id":transactionID,"user_id":userId]
                        ] as [String : Any]
                        if paymentTypestr.uppercased() == "CRED"{ ///CRED PAY
                            var configJson:[String : Any] = [String : Any]()
                            var display:[String : Any] = [String : Any]()
                            var blocks:[String : Any] = [String : Any]()
                            var custom:[String : Any] = [String : Any]()
                            custom["name"] = "Pay with Apps"
                            var instrumentsArray:[Any] = [Any]()
                            var methodJson:[String : Any] = [String : Any]()
                            methodJson["method"] = "app"
                            methodJson["providers"] = ["cred"]
                            instrumentsArray.append(methodJson)
                            custom["instruments"] = instrumentsArray
                            blocks["custom"] = custom
                            display["blocks"] = blocks
                            display["sequence"] = ["block.custom"]
                            display["preferences"] = ["show_default_blocks":false]
                            configJson["display"] = display
                            options["prefill"] = ["contact": self.user_mobile]
                            
                            options["config"] = configJson
                        }
                        
                        
                        if !self.razorpayOrderId.isEmpty {
                            options["order_id"] = self.razorpayOrderId
                        }
                        
                        if !self.razorpayCustomerId.isEmpty {
                            options["customer_id"] = self.razorpayCustomerId
                        }
                        
                        if self.recurringMandate {
                            options["recurring"] = "1"
                        }
                        
                        print("\(options)")
                        self.razorpay.open(options)
                    }else{
//                        MyLoader.hideLoading(self.viewController?.view)
                    }
                }
            }
        }else{
            ammount = Int((Float(ammount) * self.usdPerRupee).rounded())
            var prefilldic = [String : Any]()
            if self.timeZone == "Asia/Kolkata"{
                prefilldic = ["method":self.viewType == "METHOD" ? paymentTypestr : "","contact": self.user_mobile]
            }else
            {
                prefilldic = ["method":self.viewType == "METHOD" ? paymentTypestr : "","contact": self.user_mobile]
            }
            var options = [
                "amount" : ammount,"currency":kDollarSymbol,"image" : RAZORPAY_APP_LOGO, "name" : "Astrotalk","description" : "","prefill" : prefilldic, "theme" : ["color":kPrimaryColorStr], "notes" : ["astro_order_id":transactionID,"user_id":userId]
            ] as [String : Any]
            if paymentTypestr.uppercased() == "CRED"{ ///CRED PAY
                var configJson:[String : Any] = [String : Any]()
                var display:[String : Any] = [String : Any]()
                var blocks:[String : Any] = [String : Any]()
                var custom:[String : Any] = [String : Any]()
                custom["name"] = "Pay with Apps"
                var instrumentsArray:[Any] = [Any]()
                var methodJson:[String : Any] = [String : Any]()
                methodJson["method"] = "app"
                methodJson["providers"] = ["cred"]
                instrumentsArray.append(methodJson)
                custom["instruments"] = instrumentsArray
                blocks["custom"] = custom
                display["blocks"] = blocks
                display["sequence"] = ["block.custom"]
                display["preferences"] = ["show_default_blocks":false]
                configJson["display"] = display
                options["prefill"] = ["contact": user_mobile]
                options["config"] = configJson
            }
            options["method"] = ["wallet":["paypal":false]]
            
            if !self.razorpayOrderId.isEmpty {
                options["order_id"] = self.razorpayOrderId
            }
            
            if !razorpayCustomerId.isEmpty {
                options["customer_id"] = razorpayCustomerId
            }
            
            if self.recurringMandate {
                options["recurring"] = "1"
            }
            
            print("\(options)")
            razorpay.open(options)
        }
    }

    //MARK: paytm /////////////////////////////////////////////////////
    
    func initilizePayTm(txnToken:String = "",cutomerId:String = "",orderId:String = "") {
        //        let paytmInstance = PaytmGateway.sharedInstance
        //paytmInstance.createOrderWith(sender: self, customerID: userId, finalAmount: "\(newAmountWithGST.roundToGst(places: 2))", amount: newAmountPayable.roundToGst(places: 2), discount: 0, gstAmount: gstAmount, paymentGatewayId: "\(paymentGatewayId)", coupanID: coupanID, orderType: .wallet, orderMRP: newAmountPayable.roundToGst(places: 2), paymentType: self.paymentTypestr)
//        self.appInvoke.openPaytm(
//            merchantId: k_PaytmMerchantId,
//            orderId: orderId,
//            txnToken: txnToken,
//            amount: "\(newAmountWithGST.roundToGst(places: 2))",
//            callbackUrl: "\(k_PaytmPaymentUrl)\(orderId)",
//            delegate: self,
//            environment: .production,
//            urlScheme: k_PaytmurlScheme
//        ) //Simulator Aman
    }
}

extension PaymentManager: RazorpayPaymentCompletionProtocol {
    
    public func onPaymentSuccess(_ payment_id: String) {
        //showAlertView(title: "Payment Successful", message: payment_id, ref: self)
        //        self.finalPaymentCall(transactionId: payment_id, transactionType: "RAZORPAY", paytmOrderId: "")
        self.completePayment(txStatus: .completed, paymentGatewayTxID: payment_id, receiptIos: "")
    }
    
    public func onPaymentError(_ code: Int32, description str: String) {
        //        showAlertView(title: "Error", message: str, ref: self)
        self.completePayment(txStatus: .failed, paymentGatewayTxID: "", receiptIos: "")
    }
}

//Simulator AMAN
//extension PaymentManager:  AIDelegate { //Simulator Aman
//    func paytm_NotificationPost()  {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.statusRecievedPAYTM), name: Notification.Name("PayTm_Notification"), object: nil)
//    }
//    func paytm_NotificationRemoved()  {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PayTm_Notification"), object: nil)
//    }
//    @objc func statusRecievedPAYTM(notyfn:NSNotification) {
//        printLog(log: notyfn)
//        let notificationObject = notyfn.object as? [String:AnyObject] ?? [:]
//        let payTmOrderid = notificationObject["orderId"] as? String ?? ""
//        let response = notificationObject["response"] as? String ?? ""
//        if response.isEmpty {
//            self.completePayment(txStatus: .failed, paymentGatewayTxID: payTmOrderid, receiptIos: "")
//        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                // Put your code which should be executed with a delay here
//                self.completePayment(txStatus: .completed, paymentGatewayTxID: payTmOrderid, receiptIos: "")
//
//            }
//        }
//    }
////    //MARK: PaytmNewIntegration
//    func newPaytmApihit(){
//        let emailid = kUserDefault.value(forKey: RazorPayEmail) as? String ?? ""
//        var params = [
//            "userId":userId,
//            "email":emailid,
//            "PAYMENT_TYPE_ID":paymentTypestr,
//            "appId": APP_ID
//        ] as [String : Any]
//        params["amount"] = (newAmountWithGST * 100)/100
//        printLog(log: params)
//        postRequest(k_PaytmAPi, params: params as [String : AnyObject]?,oauth: true, result:
//                        {
//            (response: JSON?, error: NSError?, statuscode: Int) in
//
//            guard error == nil else {
//                /*DispatchQueue.main.async {
//                 self.view.makeToast(error!.localizedDescription, duration: 2.0, position: CSToastPositionCenter)
//                 }*/
//                self.PaymentStatusDelegate?.handleFailureCases(error: error!.localizedDescription)
//                return
//            }
//            guard let response = response else { return }
//            if response["status"].stringValue == "fail" {
//                self.viewController?.view.makeToast(response["reason"].stringValue, duration: 2.0, position: CSToastPositionBottom)
//                self.PaymentStatusDelegate?.handleFailureCases(error: response["reason"].stringValue)
//            } else {
//                if statuscode == 200 || statuscode == 201 {
//                    let dataObject = response
//                    printLog(log: dataObject)
//                    let txnToken = dataObject["txnToken"].stringValue
//                    let cutomerId = dataObject["cutomerId"].stringValue
//                    let orderId = dataObject["orderId"].stringValue
//                    let paytmCallbackUrl = dataObject["callbackUrl"].stringValue
//                    if !paytmCallbackUrl.isEmpty {
//                        k_PaytmPaymentUrl = paytmCallbackUrl
//                    }
//                    self.paymentLog(paymentType: .paytm, index: 0,txnToken: txnToken ,cutomerId:cutomerId,orderId: orderId)
//
//                } else {
//                    let errorResponse = response["error"].stringValue
//                    if (errorResponse != "") {
//                        //                                        showAlertView(title: "Error", message: errorResponse ?? "", ref: self)
////                        self.view.makeToast(errorResponse, duration: 2.0, position: CSToastPositionCenter)
//                        self.PaymentStatusDelegate?.handleFailureCases(error: errorResponse)
//
//                    }else{
//                        self.PaymentStatusDelegate?.handleFailureCases(error: error?.localizedDescription ?? "\(ApiNotWorking)")
//                    }
//                }
//            }
//        })
//    }
//    //Paytm_Delegate Function
//    func openPaymentWebVC(_ controller: UIViewController?) {
//        if let vc = controller {
//            DispatchQueue.main.async {[weak self] in
//                vc.isModalInPresentation = true
//                self?.viewController?.present(vc, animated: true, completion: nil)
//                //self?.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
//
//    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
//        debugPrint(response)
//        let TXNID = response["ORDERID"] as? String ?? ""
//        let RESPCODE = response["RESPCODE"] as? String ?? "0"
//        let response = response["response"] as? String ?? ""
//        if RESPCODE == "141" || RESPCODE == "1006" || response == "Transaction has been canceled" || TXNID == ""{   self.completePayment(txStatus: .failed, paymentGatewayTxID: TXNID, receiptIos: "")
//        }else{
//            self.completePayment(txStatus: .completed, paymentGatewayTxID: TXNID, receiptIos: "")
//        }
//    }
//}


// MARK: - EXTENSION FOR PAYPAL CHECKOUT
extension PaymentManager{
    // TODO: START PAYMENT SDK
    func triggerPayPalCheckout(index: Int,transactionID:String,paymentTypestr:String,amount:String) {
        Checkout.start(
            createOrder: { createOrderAction in
                
                /* let amount = PurchaseUnit.Amount(currencyCode: .usd, value: amount)
                 let purchaseUnit = PurchaseUnit(amount: amount)
                 let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])
                 
                 createOrderAction.create(order: order) */
                createOrderAction.set(orderId: transactionID)
                
                
            }, onApprove: { approval in
                
                self.completePayment(txStatus: .completed, paymentGatewayTxID: transactionID, receiptIos: "")
                
                /*  approval.actions.capture { (response, error) in
                 print("Order successfully captured: \(response?.data)")
                 print(response?.data.id)
                 print(response?.data.status)
                 print(response?.data.orderData)
                 if let paymentId = response?.data.id{
                 self.completePayment(txStatus: .completed, paymentGatewayTxID: paymentId, receiptIos: "")
                 
                 }
                 
                 
                 
                 } */
                
            }, onCancel: {
                
                // Optionally use this closure to respond to the user canceling the paysheet
                self.completePayment(txStatus: .failed, paymentGatewayTxID: "", receiptIos: "")
                
                
            }, onError: { error in
                
                // Optionally use this closure to respond to the user experiencing an error in
                // the payment experience
                self.completePayment(txStatus: .failed, paymentGatewayTxID: "", receiptIos: "")
                
            }
        )
    }
}


extension PaymentManager : WalletPayuDelegate{
    func isPaymentFail() {
        
        let isToShowNewPaymentFailedView = self.paymentLogRootData?.data?.isToShowNewPaymentFailedView ?? Bool()
        
        if isToShowNewPaymentFailedView{
//            let myAlert = FailedPaymentPopupViewC()
//            myAlert.callBackSuccess = { [weak self] (info) in
//                guard let this = self else {return}
//
//                var gatewayId:String = String()
//                var type:String = String()
//                var typeId:String = String()
//                var viewType: String = String()
//                var methodName = String()
//
//                gatewayId = "\(info.gatewayId ?? Int())"
//                type = "\(info.type ?? String())"
//                typeId = "\(info.typeId ?? Int())"
//                methodName = "\(info.methodName ?? String())"
//                viewType = "\(info.viewType ?? String())"
//
//                this.paymentTypeId = typeId
//                this.paymentTypestr = type
//                this.viewType = viewType.uppercased()
//                this.proceedPayment(index: Int(gatewayId) ?? 0, methodName: methodName)
//
//            }
//            myAlert.paymentLogRootData = self.paymentLogRootData
//            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            self.viewController?.present(myAlert, animated: true, completion: nil)


        }else{
            self.viewController?.dismiss(animated: true)
//            viewController?.presentAlertClass()
        }
    }
    
    func isPaymentSusscess() {
//        self.showSuccessfullDialoge()
    }
    
}


extension PaymentManager: AddressViewControllerDelegate {
    public func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?) {
        self.addressDetails = address
        self.addressViewController?.dismiss(animated: true, completion: {
            if address != nil {
                self.stripeDataSetup(response: self.stripePaymentServerDict ?? [:])
            } else {
                self.completePayment(txStatus: .failed, paymentGatewayTxID: "", receiptIos: "")
            }
        })
    }
}

extension PaymentManager: PayoneerWebViewDelegate {
    func paymentSuccessful() {
        let successView = PaymentSuccessView(frame: UIScreen.main.bounds)
        viewController?.view.addSubview(successView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            successView.removeFromSuperview()
            self.navController?.popToRootViewController(animated: true)
        }
        
    }
    
    func paymentFailed() {
        self.viewController?.dismiss(animated: true)
//        viewController?.presentAlertClass()
    }
}

extension PaymentManager: UpiPaymentStatus {
    func upiPaymentSuccess(transactionId: String) {
        self.completePayment(txStatus: .completed, paymentGatewayTxID: transactionId, receiptIos: "")
    }
    
    func upiPaymentFailed() {
        self.completePayment(txStatus: .failed, paymentGatewayTxID: "", receiptIos: "")
    }
}



extension PaymentManager {
    //MARK:loadPromotionalPopUp
    func loadAlert_For_paypal_payment(completionHandler: @escaping (_ isProceed:Bool) -> Void)  {
        let alertController = UIAlertController(title: "", message: "Paypal doesn't allow a recharge of less than USD 0.5. Can we do a USD 0.5 recharge & let the balance stay in your wallet?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { alert -> Void in
            completionHandler(false)
        })
        let saveAction = UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            completionHandler(true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
}
