//
//  File.swift
//  
//
//  Created by Astrotalk on 30/09/24.
//

import Foundation
import KeychainSwift

public enum NetworkEnvironment: String, CaseIterable {
    case production = "Production"
    case dev1 = "dev1"
    case dev2 = "dev2"
    case dev3 = "dev3"
    case dev4 = "dev4"
    case dev5 = "dev5"
    case dev6 = "dev6"
    case dev6IP = "dev6IP"
    case dev7 = "dev7"
    case dev8 = "dev8"
    case dev8IP = "dev8IP"
    case dev9 = "dev9"
    case dev10 = "dev10"
    case dev11 = "dev11"
    case dev12 = "dev12"
    case dev13 = "dev13"
    case dev14 = "dev14"
    case dev15 = "dev15"
    case preprod1 = "preprod1"
    case preprod2 = "preprod2"
}
 
public extension NetworkManager {
    static var isReleaseMode: Bool {
        #if DEV
        return false
        #else
        return true
        #endif
    }
    
    static let keychain = KeychainSwift()
    static let selectedEnvironmentKey = "selectedEnvironment"
    static let astrotalkUUID = "astrotalkUUID"
    static let userWithoutLoginId = "userWithoutLoginId"


    public static var selectedEnvironment: NetworkEnvironment {
        get {
            return .dev1
            guard !isReleaseMode else {
                return .production
            }
            
            if let savedEnvironmentRawValue = keychain.get(selectedEnvironmentKey),
               let savedEnvironment = NetworkEnvironment(rawValue: savedEnvironmentRawValue) {
                return savedEnvironment
            } else {
                let defaultEnvironment = NetworkEnvironment.production
                keychain.set(defaultEnvironment.rawValue, forKey: selectedEnvironmentKey)
                return defaultEnvironment
            }
        }
        set {
            guard !isReleaseMode else {
                return
            }
            keychain.set(newValue.rawValue, forKey: selectedEnvironmentKey)
        }
    }
    
    static var baseURL: String {
        return "https://dev1.api.astrotalk.in/AstroTalk/"
        switch selectedEnvironment {
        case .production:
            return "https://api.prod.astrotalk.in/AstroTalk/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroTalk/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstroTalk/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstroTalk/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroTalk/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstroTalk/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroTalk/"
        case .dev6IP:
            return "http://43.204.1.244:8080/AstroTalk/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstroTalk/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstroTalk/"
        case .dev8IP:
            return "http://65.0.15.170:8080/AstroTalk/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroTalk/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroTalk/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroTalk/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroTalk/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroTalk/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroTalk/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroTalk/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstroTalk/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstroTalk/"
        }
    }
    
    static var kundliBaseURL: String {
        switch selectedEnvironment {
        case .production:
            return "http://api.kundali.astrotalk.com/"
        case .dev1:
            return "https://dev1.api.astrotalk.in"
        case .dev2:
            return "https://dev2.api.astrotalk.in"
        case .dev3:
            return "https://dev3.api.astrotalk.in"
        case .dev4:
            return "https://dev4.api.astrotalk.in"
        case .dev5:
            return "https://dev5.api.astrotalk.in"
        case .dev6:
            return "https://dev6.api.astrotalk.in"
        case .dev6IP:
            return "http://api.kundali.astrotalk.com"
        case .dev7:
            return "https://dev7.api.astrotalk.in"
        case .dev8:
            return "https://dev8.api.astrotalk.in"
        case .dev8IP:
            return "http://api.kundali.astrotalk.com"
        case .dev9:
            return "https://dev9.api.astrotalk.in"
        case .dev10:
            return "https://dev10.api.astrotalk.in"
        case .dev11:
            return "https://dev11.api.astrotalk.in"
        case .dev12:
            return "https://dev12.api.astrotalk.in"
        case .dev13:
            return "https://dev13.api.astrotalk.in"
        case .dev14:
            return "https://dev14.api.astrotalk.in"
        case .dev15:
            return "https://dev15.api.astrotalk.in"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/"
        }
    }
    
    static var matchMakingBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "http://api.kundali.astrotalk.com/"
        case .dev1:
            return "https://dev1.api.astrotalk.in"
        case .dev2:
            return "https://dev2.api.astrotalk.in"
        case .dev3:
            return "https://dev3.api.astrotalk.in"
        case .dev4:
            return "https://dev4.api.astrotalk.in"
        case .dev5:
            return "https://dev5.api.astrotalk.in"
        case .dev6:
            return "https://dev6.api.astrotalk.in"
        case .dev6IP:
            return "http://api.kundali.astrotalk.com"
        case .dev7:
            return "https://dev7.api.astrotalk.in"
        case .dev8:
            return "https://dev8.api.astrotalk.in"
        case .dev8IP:
            return "http://api.kundali.astrotalk.com"
        case .dev9:
            return "https://dev9.api.astrotalk.in"
        case .dev10:
            return "https://dev10.api.astrotalk.in"
        case .dev11:
            return "https://dev11.api.astrotalk.in"
        case .dev12:
            return "https://dev12.api.astrotalk.in"
        case .dev13:
            return "https://dev13.api.astrotalk.in"
        case .dev14:
            return "https://dev14.api.astrotalk.in"
        case .dev15:
            return "https://dev15.api.astrotalk.in"
        case .preprod1:
            return "https://preprod1.api.astrotalk"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in"
        }
    }
    
    static var kundliReportBaseURL: String {
        switch selectedEnvironment {
        case .production:
            return "http://api.kundali.astrotalk.com/"
        case .dev1:
            return "https://dev1.api.astrotalk.in"
        case .dev2:
            return "https://dev2.api.astrotalk.in"
        case .dev3:
            return "https://dev3.api.astrotalk.in"
        case .dev4:
            return "https://dev4.api.astrotalk.in"
        case .dev5:
            return "https://dev5.api.astrotalk.in"
        case .dev6:
            return "https://dev6.api.astrotalk.in"
        case .dev6IP:
            return "http://api.kundali.astrotalk.com"
        case .dev7:
            return "https://dev7.api.astrotalk.in"
        case .dev8:
            return "https://dev8.api.astrotalk.in"
        case .dev8IP:
            return "http://api.kundali.astrotalk.com"
        case .dev9:
            return "https://dev9.api.astrotalk.in"
        case .dev10:
            return "https://dev10.api.astrotalk.in"
        case .dev11:
            return "https://dev11.api.astrotalk.in"
        case .dev12:
            return "https://dev12.api.astrotalk.in"
        case .dev13:
            return "https://dev13.api.astrotalk.in"
        case .dev14:
            return "https://dev14.api.astrotalk.in"
        case .dev15:
            return "https://dev15.api.astrotalk.in"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in"
        }
    }

    static var agoraBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.live.astrotalk.com/AstrotalkLive/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstrotalkLive/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstrotalkLive/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstrotalkLive/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstrotalkLive/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstrotalkLive/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstrotalkLive/"
        case .dev6IP:
            return "http://13.233.202.15:8080/AstrotalkLive/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstrotalkLive/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstrotalkLive/"
        case .dev8IP:
            return "http://43.205.190.15:8080/AstrotalkLive/"
        case .dev9:
            return "http://35.154.193.172:8080/AstrotalkLive/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstrotalkLive/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstrotalkLive/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstrotalkLive/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstrotalkLive/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstrotalkLive/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstrotalkLive/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstrotalkLive/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstrotalkLive/"
        }
    }
    
    
    static var placeApiBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "http://api.kundali.astrotalk.com/"
        case .dev1:
            return "http://api.dev1.astrotalk.com/"
        case .dev2:
            return "http://api.kundali.astrotalk.com/"
        case .dev3:
            return "http://api.kundali.astrotalk.com/"
        case .dev4:
            return "http://api.dev4.astrotalk.com/"
        case .dev5:
            return "http://api.kundali.astrotalk.com/"
        case .dev6:
            return "http://api.kundali.astrotalk.com/"
        case .dev6IP:
            return "http://api.kundali.astrotalk.com/"
        case .dev7:
            return "http://api.kundali.astrotalk.com/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/"
        case .dev8IP:
            return "http://api.kundali.astrotalk.com/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/"
        case .preprod1:
            return "http://dev9.api.astrotalk.in/"
        case .preprod2:
            return "http://api.kundali.astrotalk.com/"
        }
    }
    
    
    static var MainChatBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.paidchat.astrotalk.com/AstrotalkChat/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstrotalkChat/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstrotalkChat/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstrotalkChat/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstrotalkChat/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstrotalkChat/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstrotalkChat/"
        case .dev6IP:
            return "http://13.127.135.156:8080/AstrotalkChat/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstrotalkChat/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstrotalkChat/"
        case .dev8IP:
            return "http://3.7.44.97:8080/AstrotalkChat/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstrotalkChat/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstrotalkChat/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstrotalkChat/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstrotalkChat/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstrotalkChat/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstrotalkChat/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstrotalkChat/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstrotalkChat/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstrotalkChat/"
        }
    }
    
    
    static var supportChatBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.supportchat.astrotalk.com/AstroChat/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroChat/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstroChat/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstroChat/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroChat/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstroChat/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroChat/"
        case .dev6IP:
            return "http://35.154.183.253:8080/AstroChat/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstroChat/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstroChat/"
        case .dev8IP:
            return "http://3.108.204.215:8080/AstroChat/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroChat/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroChat/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroChat/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroChat/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroChat/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroChat/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroChat/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstroChat/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstroChat/"
        }
    }
    
    static var kGetAsstrologerDetail_WebView_Url: String {
        switch selectedEnvironment {
        case .production:
            return "http://astrotalk.com/best-astrologer/"
        case .dev1, .dev2, .dev3, .dev4, .dev5, .dev6, .dev6IP, .dev7, .dev8, .dev8IP, .dev9, .dev10, .dev11, .dev12, .dev13, .dev14, .dev15, .preprod1, .preprod2:
            return "https://dev.astrotalk.in/best-astrologer/"
        }
    }
    
    static var kwebDomainChat: String {
        switch selectedEnvironment {
        case .production:
            return "https://astrotalk.com/shared/chat-history/"
        case .dev1, .dev2, .dev3, .dev4, .dev5, .dev6, .dev6IP, .dev7, .dev8, .dev8IP, .dev9, .dev10, .dev11, .dev12, .dev13, .dev14, .dev15, .preprod1, .preprod2:
            return "https://angular6.astrotalk.in/shared/chat-history/"
        }
    }
    
    static var kwebDomainCall: String {
        switch selectedEnvironment {
        case .production:
            return "https://astrotalk.com/shared/call-recording/"
        case .dev1, .dev2, .dev3, .dev4, .dev5, .dev6, .dev6IP, .dev7, .dev8, .dev8IP, .dev9, .dev10, .dev11, .dev12, .dev13, .dev14, .dev15, .preprod1, .preprod2:
            return "https://angular6.astrotalk.in/shared/call-recording/"
        }
    }
    
    static var kwebDomain: String {
        switch selectedEnvironment {
        case .production:
            return "https://astrotalk.com/"
        case .dev1, .dev2, .dev3, .dev4, .dev5, .dev6, .dev6IP, .dev7, .dev8, .dev8IP, .dev9, .dev10, .dev11, .dev12, .dev13, .dev14, .dev15, .preprod1, .preprod2:
            return "https://dev.astrotalk.in/"
        }
    }
    
    static var astromallNewBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.astromall.astrotalk.com/AstroMall/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroMall/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstroMall/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstroMall/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroMall/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstroMall/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroMall/"
        case .dev6IP:
            return "http://3.7.96.178:8080/AstroMall/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstroMall/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstroMall/"
        case .dev8IP:
            return "http://3.6.152.82:8080/AstroMall/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroMall/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroMall/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroMall/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroMall/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroMall/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroMall/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroMall/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstroMall/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstroMall/"
        }
    }
    
    static var dailyHoroScopeBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.supportchat.astrotalk.com/AstroChat/horoscope/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroChat/horoscope/"
        case .dev2:
            return "http://api.dev2supportchat.astrotalk.com:8080/AstroChat/horoscope/"
        case .dev3:
            return "http://api.dev3supportchat.astrotalk.com:8080/AstroChat/horoscope/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroChat/horoscope/"
        case .dev5:
            return "http://api.dev5.supportchat.astrotalk.in:8080/AstroChat/horoscope/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroChat/horoscope/"
        case .dev6IP:
            return "https://dev6.api.astrotalk.in/AstroChat/horoscope/"
        case .dev7:
            return "http://15.206.95.102:8080/AstroChat/horoscope/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/v1/"
        case .dev8IP:
            return "http://15.206.95.102:8080/AstroChat/horoscope/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroChat/horoscope/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroChat/horoscope/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroChat/horoscope/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroChat/horoscope/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroChat/horoscope/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroChat/horoscope/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroChat/horoscope/"
        case .preprod1:
            return "https://dev1.api.astrotalk.in/v1/"
        case .preprod2:
            return "http://15.206.95.102:8080/AstroChat/horoscope/"
        }
    }
    
    static var assitantChatNewBaseUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.supportchat.astrotalk.com/AstroChat/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroChat/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstroChat/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstroChat/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroChat/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstroChat/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroChat/"
        case .dev6IP:
            return "http://35.154.183.253:8080/AstroChat/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstroChat/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstroChat/"
        case .dev8IP:
            return "http://3.108.204.215:8080/AstroChat/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroChat/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroChat/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroChat/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroChat/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroChat/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroChat/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroChat/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstroChat/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstroChat/"
        }
    }
    
    static var AstrologerListUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.consultant.list.astrotalk.com/AstroTalk/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/AstroTalk/"
        case .dev2:
            return "https://dev2.api.astrotalk.in/AstroTalk/"
        case .dev3:
            return "https://dev3.api.astrotalk.in/AstroTalk/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/AstroTalk/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/AstroTalk/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/AstroTalk/"
        case .dev6IP:
            return "http://65.0.241.62:8080/AstroTalk/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/AstroTalk/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/AstroTalk/"
        case .dev8IP:
            return "https://dev8.api.astrotalk.in/AstroTalk/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/AstroTalk/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/AstroTalk/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/AstroTalk/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/AstroTalk/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/AstroTalk/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/AstroTalk/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/AstroTalk/"
        case .preprod1:
            return "https://preprod1.api.astrotalk.in/AstroTalk/"
        case .preprod2:
            return "https://preprod2.api.astrotalk.in/AstroTalk/"
        }
    }
        
    static var historyProdUrl: String {
        switch selectedEnvironment {
        case .production:
            return "https://api.orderview.astrotalk.in/OrderView/"
        case .dev1:
            return "https://dev1.api.astrotalk.in/OrderView/"
        case .dev2:
            return "http://65.0.35.137:8080/OrderView/"
        case .dev3:
            return "http://65.0.35.137:8080/OrderView/"
        case .dev4:
            return "https://dev4.api.astrotalk.in/OrderView/"
        case .dev5:
            return "https://dev5.api.astrotalk.in/OrderView/"
        case .dev6:
            return "https://dev6.api.astrotalk.in/OrderView/"
        case .dev6IP:
            return "https://dev6.api.astrotalk.in/OrderView/"
        case .dev7:
            return "https://dev7.api.astrotalk.in/OrderView/"
        case .dev8:
            return "https://dev8.api.astrotalk.in/OrderView/"
        case .dev8IP:
            return "https://dev8.api.astrotalk.in/OrderView/"
        case .dev9:
            return "https://dev9.api.astrotalk.in/OrderView/"
        case .dev10:
            return "https://dev10.api.astrotalk.in/OrderView/"
        case .dev11:
            return "https://dev11.api.astrotalk.in/OrderView/"
        case .dev12:
            return "https://dev12.api.astrotalk.in/OrderView/"
        case .dev13:
            return "https://dev13.api.astrotalk.in/OrderView/"
        case .dev14:
            return "https://dev14.api.astrotalk.in/OrderView/"
        case .dev15:
            return "https://dev15.api.astrotalk.in/OrderView/"
        case .preprod1:
            return "https://preprod-orderview.api.astrotalk.in/OrderView/"
        case .preprod2:
            return "https://preprod-orderview.api.astrotalk.in/OrderView/"
        }
    }

    static func clearEnvironmentData() {
        keychain.delete(selectedEnvironmentKey)
    }
    
    static func setKeyChainUUID(hardwareId:String) {
        if self.getKeyChainUUID().isEmpty {
            keychain.set(hardwareId, forKey: astrotalkUUID)
        }
    }
    
    static func getKeyChainUUID() -> String {
        if let astrotalkUUID = keychain.get(astrotalkUUID) {
           return astrotalkUUID
        }
        return ""
    }
    
    static func setUserWithoutLoginID(userId: String) {
        if self.getUserWithoutLoginID().isEmpty {
            keychain.set(userId, forKey: userWithoutLoginId)
        }
    }
    
    static func getUserWithoutLoginID() -> String {
        if let userId = keychain.get(userWithoutLoginId) {
           return userId
        }
        return ""
    }
}

