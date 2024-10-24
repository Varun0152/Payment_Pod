import Foundation

let facebookAppID = "706056846556355"
let k_PaytmMerchantId = "CODEYE84459150770958"//Prod
var k_PaytmPaymentUrl = "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID="//prod
let k_PaytmurlScheme = "paytm1CODEYE84459150770958"//prod

let kPrimaryColorStr = "F0DF20"  // yellow color
let kPrimaryColor = hexStringToUIColor(hex: kPrimaryColorStr)
//let k_PayuKey = "8TDnxS" //dev
//let k_PayuURL = "https://test.payu.in/_payment" //dev


let k_PayuKey = "g1tT0E" //Prod
let k_PayuURL = "https://secure.payu.in/_payment" //prod


//let k_PaytmMerchantId = "CODEYE70146993422767"//dev
//let k_PaytmPaymentUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID="//dev
//let k_PaytmurlScheme = "paytmCODEYE70146993422767"//dev
let k_reCAPTCHAGoogle = "6LcJr4MlAAAAAPFLI50muE9Xx55CTPA8uEUdm34t"
let k_AppsFlyerTamplateID = "zO5Q" //Apssflyer Tamplate Id For Refer & Earn
let K_AdjustSdkTokenID = "70j0m2r6qveo" // Adjust SDK App Token
let k_AppsFlyerAuthenticationKey = "Y7dYxxg4U9DSs7hg3tj5JC"
let k_LocationAPiKey = "pk.e8a0a377dd1df522d510716ba61eaeab" //ProdKay
//let k_LocationAPiKey = "pk.5b5d10cf2e0bad03a58a45c1f19a0eea"
let k_RequestTimeoutTime = 10
let k_LocalRechargeMinTime = 8
let kAuth_String = "Bearer "
let kDimainLink = "https://astrotalk.page.link"
let NO_DATA = "No Data Found"
let NO_VIDEO_DATA = "No Video Available"
let LOW_BALANCE = "You need minimum balance of \(kRupeeSymbol) 200 to start a call"
let LOW_BALANCE_DOLLAR = "You need minimum balance of $ 3 to start a call"
let ASTROLOGER_BUSY_CHAT = "This astrologer is busy on another chat. Please check after some time"
let ASTROLOGER_BUSY_CALL = "This astrologer is busy on another call. Please check after some time"
let ASTROLOGER_OFFLINE = "This astrologer is offline"
let NOTIFICATION_CHECK_TITLE = "Notification Alert"
//let NOTIFICATION_CHECK_DESC = "Please enable notifications to start chat and relaunch Application again"
let NOTIFICATION_CHECK_DESC = "To start chat, we need permission to send notifications. Please allow it as mentioned below: Go To Settings-> Notifications -> Allow Notification and relaunch Application again"
let ReportSupportText = "For any issues or enquiries, you can always reach out to customer support on text or call."
let ReportTimeText = "Your report shall be answered within 24-48 hours."
let ReportPopUpText = "Your report details has been sent to the Astrologer successfully. You will receive a response within 24 to 48 hours. In case of any queries, please contact our customer support."
let CouponText = "cashback in wallet after recharge"
let CouponTextInReport = "cashback in wallet"

let TipForMinutesRecharge = "You can also avail one free session with astrologer from here"
let TipForHomeScreenBanner = "You can also avail one free session with astrologer from home screen bannner"
//let SomthingWent_Wrong = "Something went wrong.We are working on it."
let SomthingWent_Wrong = "Something went wrong. Please wait for us to fix the issue. You can report it at cst@astrotalk.com"
let SomthingWent_WrongTryAgain = "Something went wrong. Please try again"

let ApiNotWorking = "Server not working. Please wait for us to fix the issue. You can report it at cst@astrotalk.com"

let SESSION_EXPIRED_TITLE = "Session Expired"
let SESSION_EXPIRED_DESC = "Due to the security issue You have to login again"
let T_C_TITLE = "By signing up, you agree to our Terms of use and Privacy Policy"
let RAZORPAY_APP_LOGO = "https://aws.astrotalk.com/assets/images/logo/icon.png"
let FreeBannerUrl = "https://astrotalk.s3.amazonaws.com/images/ecf54c50-43e8-47ab-bf9c-934849b41b76.jpg"
 
let BUSINESS_ID = 1
let APP_ID = 2
var VERSION: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "11.2.290"
var CountryCode = "countryCode"
let DEVICE_TYPE = "iOS"
let APP_NAME = "ASTROTALK"
let CHAT_VERSION = "v2"
let kRupeeSymbol = "₹"
var kDollarSymbol = "USD"
var kGSTPrice: Float = 18
let kSecondOpenionDiscount: Float = 20
var ServiceIDforHistory: Int = 0

//RazorpayConstaintValue
let RazorpayMobileNumber = "\(kUserDefault.value(forKey:kI_MOBILE) as? String ?? "")"
let RazorPayEmail = "\(kUserDefault.value(forKey: kUSER_EMAIL) as! String)"

// SDK keys
let GMSAPiKeyFor_PlaceApi = "AIzaSyD3sw24ewiSgiy12D8YpmhXs-9jc4WPixg" //Production
let kGMSServicesKey = "AIzaSyDrHdKpxrPozUV6i7bSlg7EL64_m2wP4-I"
let kGMSPlacesClientKey = "AIzaSyDrHdKpxrPozUV6i7bSlg7EL64_m2wP4-I"
let kRaorpay_codeyetiLive = "rzp_live_nbFIyWp9PWCqNl" // codeyeti
let kRazorPayKey_AstrotalkLive = "rzp_live_Mw6ZYXea2k4yyj" // Astrotalk
let kRazorPayKeyNew_MaskyetiLive = "rzp_live_idcMSOkCdvdxCB" // maskyeti
private let kRazorDevelopmentKey = "rzp_test_mnLQsJF2nkRjsg"
private let kRazorNewDevKey = "rzp_test_K2FmWkyeoXIGD3"
private let kRazorNewDevKeyAstro = "rzp_test_8z4JnWLwdNHC3e" //AstrotalkAccountKey

//let kRazorPayKey = kRazorPayKeyOld // Production
//let kRazorPayKey = kRazorPayKeyOld // development
let kRazorPayKey_codeyetiTest = kRazorNewDevKey // development
let kRazorPayKey_AstrotalkTest = kRazorNewDevKeyAstro // development
let kRazorPayKey_maskyetiTest = kRazorDevelopmentKey // development

//public static String CODEYETI_RAZOR_PAY_LIVE = "rzp_live_nbFIyWp9PWCqNl";
//public static String CODEYETI_RAZOR_PAY_TEST = "rzp_test_K2FmWkyeoXIGD3";
//
//
//public static String MASKYETI_RAZOR_PAY_LIVE = "rzp_live_idcMSOkCdvdxCB";
//public static String MASKYETI_RAZOR_PAY_TEST = "rzp_test_mnLQsJF2nkRjsg";
//
//
//public static String ASTROTALK_RAZOR_PAY_LIVE = "rzp_live_Mw6ZYXea2k4yyj";
//public static String ASTROTALK_RAZOR_PAY_TEST = "rzp_test_8z4JnWLwdNHC3e";

//let kPaypalKeySandBox = "AZed86BPDUjm4LBiq3G0N_IN9LTgWJgCyS3wCNtvbyjlfNDV7EaI1LeTDrYwthVhE1xc5VseYxBCUnRz"
//let kPaypalKeySandBox = "AVBnnAbm0BrZ4oACqc532-XwCFIeVsyTnq9IADfYTvBc7KGH8WqYiuZjOOh9c8asrYyaVuTChAAqDNOh"
let kPaypalKeySandBox = "AV5wmzFoZ5-3qTUNt2J_sHwSrBcKexfpb7Iv0w2rGtRSjzVUv1uGwb6d5QgHgI-oZx6zVGHOLnVKPdJf"
//let kPaypalKeySandBox = "AaunAS50aYeeKuMDuNENw6kAIt0A4T4LGnYezPk-n6l1ARM1okCFboecCix0Q8TKVJ5bWjX0uI_HBy1n"

let kPaypalKey = "AXcfQe-af8zaTrrfPYHwXDcVZ1CwkamtBa-VXBwbqP4cJBhni3_34Zy8t4mxyA3sjudNpXexeqe50XcP"
let kInAPPIndentifier_Slot = "inapp1_codeyeti.com.AstroYeti"
let kInAPPIndentifier_Ques = "inappQuestion_codeyeti.com.AstroYeti"
let kInAPPIndentifier_Report = "inappReport_codeyeti.com.AstroYeti"
//let kGoogleAnalyticsKey = "UA-74480986-3"
let kGoogleAnalyticsKey = "UA-74480986-9"

let kInstamozoKey = ""

let kSCEILEN_NOTIFICATION = "scilentNotification"
let kCHAT_NOTIFICATION = "chatNotification"
let kSTATUS_NOTIFICATION = "statusNotification"
let KPIP_SHOWING = "pipShow"
let tabBarControllerScrollTop = "tabBarControllerScrollTop"
let kTimer_NOTIFICATION = "statusTimer"
let kwebView_NOTIFICATION = "webView"
let kDataNOTIFICATION = "NotificationInfo"
let kGROUP_CHAT_NOTIFICATION = "GroupChat"
let kisToHideEPooja = "istoHideEPooja"
let kPOOJATABBAR_NOTIFICATION = "poojaTabBar"
let kHandleNotificationClickToOpenApp = "HANDLE_NOTIFICATION_CLICK_TO_OPEN_APP"

//constaint url
let yourstory = "https://yourstory.com/2019/11/startup-astrology-delhi-astrotalk-privacy"
let businessstandard = "https://www.business-standard.com/article/news-ani/astrotalk-stands-tall-with-most-accurate-and-foolproof-future-predictions-119101801010_1.html"
let dailyhunt = "https://m.dailyhunt.in/news/india/english/newsvoir-epaper-newsvoir/astrotalk+stands+tall+with+the+most+accurate+and+foolproof+future+predicts-newsid-142646512"
let e27 = "https://e27.co/astrology-agnostic-wait-heres-a-startup-that-can-predict-whether-your-startup-will-fail-or-not-20190215/"
let aninews = "https://www.aninews.in/news/business/astrotalk-stands-tall-with-most-accurate-and-foolproof-future-predictions20191018175912/"
let startupsuccessstories = "https://startupsuccessstories.in/how-this-noida-based-startup-is-changing-the-face-of-astrology-industry/"
let uniindia = "http://www.uniindia.com/astrotalk-stands-tall-with-the-most-accurate-and-foolproof-future-predicts/newsvoir/news/1762628.html"
let blogUrl = "https://astrotalk.com/astrology-blog/astrotalk-for-online-astrology-predictions/"
//let blogYoutubUrl = "https://www.youtube.com/watch?v=7QiDA8Wpv9c"
let blogYoutubUrl = "https://www.youtube.com/watch?v=_iynIcK-dS0"


let kUserDefault = UserDefaults.standard
let kPRIVACY_ON = "privacy_on"
let kUSER_ID = "user_id"
let kUSER_EMAIL = "user_email"
let kUSER_NAME = "user_name"
let kUSER_TIMEZONE = "timeZone"
let kUSER_CREDITS = "creditPoints"
let kUSER_WALLET = "wallets"
let KGUEST_ID = "GUEST_ID"
let KTOKEN = "K_TOKEN"
let kDEVICE_TOKEN = "deviceToken"
let kUUID_TOKEN = "uuidstringToken"
let kAUTH_TOKEN = "authToken"
let kVOIP_TOKEN = "voipToken"
let kUSD_PER_RUPEE = "usdPerRupee"
let k_Dollar_Symbol = "kDollarSymbol"
let kCountryImage = "CountryImage"
let kCountryCode = "CountryCode"
let kpopUp = "popUpBool"
let K_iosVoipDeviceToken = "iosVoipDeviceToken"
let kUseFilter = "useFilter"
let kProfilePic = "profilePic"
let kI_NAME = "I_name"
let kI_LAST_NAME = "I_LastName"
let kI_CCODE = "I_countryCode"
let kI_MOBILE = "I_mobile"
let kRazorpayMobile = "RazorPay_mobile"
let kI_GENDER = "I_gender"
let kUserGender = "FEMALE"
let kI_DOB = "I_dob"
let kI_TOB = "I_tob"
let kI_CITY = "I_city"
let kI_STATE = "I_state"
let kI_COUNTRY = "I_country"
let kI_PROBLEM = "I_problem"
let kI_QUESTION = "I_question"
let kchat_id = "chat_id"

let K_PANCHANG_LAT = "PANCHANG_LAT"
let K_PANCHANG_LONG = "PANCHANG_LONG"
let K_PANCHANG_LOC_NAME = "PANCHANG_LOC_NAME"
let K_PANCHANG_TZONE = "PANCHANG_TZONE"
let k_POBannerCancel = "pobanner"

let k_isShowRandom_PO = "isRandompoUiShow"
let k_isToShowNewChatScreen = "isToShowNewChatScreen"

let kRecommendedPopup = "RecommendedPopup"
let kSupportLayerId = "404"
let kSupportLayerText = "Issue with the previous order"
let K_isTwilioActive = "isTwilioActive"
let K_firebaseAppInstanceId = "firebaseAppInstanceId"
let kChildCallCheck = "childCallCheck"
//let kCeoCardTextId = 122
let kCeoCardTextId = 263
let kAssistantTextId = 277

let kKundliId = 286

let kNonPoId = 297
let kPoId = 296

let kanonymousId = 580 // id290
let kMaintenanceAPi = 321
let kCeoInstagramUrl = "https://www.instagram.com/ipuneetgupta/"
let kCeoLinkedinUrl = "https://www.linkedin.com/in/puneet-gupta-13ba9713/"
let kCeoTwitterUrl = "https://twitter.com/iPuneetGupta"
let krecommendationValue = 141
let kPromotionalCode = "promotionalCode"
let kIstoShowingSupportNumber = "SupportNumberShwoingOrNot"
let kLastCallChatForIntakeForm = "lastCallChatForIntakeForm"

var k_KundliParam = [String:Any]()
var k_KundliId = Int()
var k_TransitParam = [String:Any]()
var kKundliCount = "KundliCount"

var k_KundliParam_Manglik = [String:Any]()

var k_KundliName = ""
var k_KundliPlace = ""

var m_k_id = Int()
var f_k_id = Int()

var k_HoroscopeMatchingParam = [String:Any]()
var k_HoroscopeMatchingParamNew = [String:Any]()
//let AgoraAppID: String = "deffb360ba114f51aa749ac0d01a17c4" //Dev
let AgoraAppID: String = "68904093e3cc4cc696d77821e8b9570b" // prod
let k_isDoubleTap = "userClickedDobleTap"
let KOfferStatus = "offerStatus"
let KISPo_On = "ispo"
let kNumberOfRecharge = "noOfRecharge"
let KISPo_OnPopup = "isPoPopup"
let KofferString = "offerstring"
let KofferForCallText = "callText"
let KofferForChatText = "chatText"
//let ASTROLOGER_ANDROID_SHARE_AUDIO_VERSION = 197
//let ASTROLOGER_IOS_SHARE_AUDIO_VERSION = 9.6
let walletOfferPopupShowCount = "walletOfferPopupShowCount"
let walltetOfferPopupLastShownTimestampKey = "walltetOfferPopupLastShownTimestampKey"
let isToShowNewOrderHistory = kUserDefault.value(forKey: "showOrderHistoryNewUI") as? Bool ?? Bool()
let callingCode = "callingCode"
let isLanguageSelected = "isLanguageSelected"
let freeChatRedeemed = "freeChatRedeemed"
let isToHideLiveButton = "isToHideLiveButton"



let kPostPaymentComplete_url = NetworkManager.baseURL + "payment-log/complete"
let kPostPaymentLog_url = NetworkManager.baseURL + "payment-log/submit"
let k_upi_payment_status = NetworkManager.baseURL + "payment-log/get/upi-payment/status"
let kSendPaymentAdddress = NetworkManager.baseURL + "stripe/payment"
