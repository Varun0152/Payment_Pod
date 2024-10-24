//
//  AstrotalkNetworkManager.swift
//  AstrotalkNetworkManager
//
//  Created by Astrotalk on 05/09/24.
//
import Foundation
import Alamofire

public class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    public var authToken: String?
    public var userId: String?
    
    public var businessId: String?
    public var appId: String?
    public var version: String?
    public var timezone: String?
    public var appName: String?
    public let deviceType = "iOS"
    
    private let kAuth_String = "Bearer "
    private let k_RequestTimeoutTime = 10
    
    
    public enum MyError: Error, LocalizedError {
        private static let SESSION_EXPIRED_DESC = "Due to the security issue You have to login again"
        private static let SESSION_EXPIRED_TITLE = "Session Expired"
        
        case customError
        public var errorDescription: String? {
            switch self {
            case .customError:
                return NSLocalizedString(MyError.SESSION_EXPIRED_DESC, comment: MyError.SESSION_EXPIRED_TITLE)
            }
        }
    }

    public let sessionError: Error = MyError.customError
    
    // Methods without oauth that send no headers
    public func getRequest(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
//        printLog(log: url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                // Check status code 403 for authentication
                
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
                        if let _ = self.userId {
//                        showLoginExpiredAlert()
                            result(nil, self.sessionError as NSError, 403)
                        }
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                                       switch (response.error!._code){
                                            case NSURLErrorTimedOut:
                                                //Manager your time out error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                            case NSURLErrorNotConnectedToInternet:
                                                //Manager your not connected to internet error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                           default:
                                                //manager your default case
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                            break
                                            }
                    
                    }
                }
        }
    }


    // Methods without oauth that send no headers
    public func getRequestWithApplicationJson(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                // Check status code 403 for authentication
                
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
                        if let _ = self.userId {
//                        showLoginExpiredAlert()
                            result(nil, self.sessionError as NSError, 403)
                        }
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                                       switch (response.error!._code){
                                            case NSURLErrorTimedOut:
                                                //Manager your time out error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                            case NSURLErrorNotConnectedToInternet:
                                                //Manager your not connected to internet error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                           default:
                                                //manager your default case
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                            break
                                            }
                    
                    }
                }
        }
    }



    // Methods without oauth that send no headers
    public func getRequestForGuest(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                // Check status code 403 for authentication
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        self.showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                                       switch (response.error!._code){
                                            case NSURLErrorTimedOut:
                                                //Manager your time out error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                            case NSURLErrorNotConnectedToInternet:
                                                //Manager your not connected to internet error
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                                break
                                           default:
                                                //manager your default case
                                                result(nil, response.result.error as NSError?, response.result.error!._code)
                                            break
                                            }
                    
                    }
                }
        }
    }


    public func get_FB_Request(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: nil)
            .responseData { response in
                // Check status code 403 for authentication
                print("\(response)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }

    public func postRequest(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .post, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }


    public func postRequestWithApplicationJson(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .post, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }

    public func putRequest(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .put, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }

    public func putRequestWithJson(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }

    public func deleteRequest(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .delete, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }


    // Methods without oauth and with JSON object
    func getRequestWithJSON(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }

    public func postRequestWithJSON(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }


    public func postRequestWithJSONWithApplicationJ(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
        }
    }


    public func deleteRequestWithJSON(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
            }
    }


    public func postRequestWithImage(url: String, params: [String: AnyObject]?,imageData: Array<Data>, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
        print( url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData[0], withName: "file", fileName: "file", mimeType: "image/jpg")
            
            for (key, value) in params! {
                multipartFormData.append(value.data!(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: url, encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    
                    if (response.result.value != nil)
                    {
                        let jsonResponse = JSON(data: response.data!)
                        print(jsonResponse)
                        result(jsonResponse, nil, response.response!.statusCode)
                    }
                    else
                    {
                        result(nil, response.result.error as NSError?, response.result.error!._code)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }


    // MARK: Post Request
    public func postRequestDic(for url: String, with parameters: [String: Any]?, oauth: Bool, completion: @escaping ([String: Any]?, Error?) -> Void) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(), headers: header).responseJSON { (response) in
            if let error = response.result.error {
                completion(nil, error)
            } else if let resultvalue = response.result.value as? [String: Any] {
                completion(resultvalue, nil)
            }
        }
    }

    public func postRequestDicWithParam(for url: String, with parameters: [String: Any]?, oauth: Bool, completion: @escaping ([String: Any]?, Error?) -> Void) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(), headers: header).responseJSON { (response) in
            if let error = response.result.error {
                completion(nil, error)
            } else if let resultvalue = response.result.value as? [String: Any] {
                completion(resultvalue, nil)
            }
        }
    }



    public func postRequestWithJSON(for url: String, with parameters: [String: Any]?, oauth: Bool, completion: @escaping ([String: Any]?, Error?) -> Void) {
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(), headers: header).responseJSON { (response) in
            if let error = response.result.error {
                completion(nil, error)
            } else if let resultvalue = response.result.value as? [String: Any] {
                completion(resultvalue, nil)
            }
        }
    }


    public func getRequestToGetJSONData(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (Data?, _ error: NSError?, _ statuscode: Int) -> ()){
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                // Check status code 403 for authentication
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        print(jsonResponse)
                        result(response.data, nil, response.response!.statusCode)
                    } else {
                        if let _ = self.userId {
//                            showLoginExpiredAlert()
                            result(nil, self.sessionError as NSError, 403)
                        }
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        switch (response.error!._code){
                        case NSURLErrorTimedOut:
                            //Manager your time out error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        case NSURLErrorNotConnectedToInternet:
                            //Manager your not connected to internet error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        default:
                            //manager your default case
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        }
                        
                    }
                }
            }
    }


    func getRequestToGetJSONDataWithApplictionJ(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (Data?, _ error: NSError?, _ statuscode: Int) -> ()){
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                // Check status code 403 for authentication
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        print(jsonResponse)
                        result(response.data, nil, response.response!.statusCode)
                    } else {
                        if let _ = self.userId {
//                            showLoginExpiredAlert()
//                            result(nil, self.sessionError as NSError, 403)
                        }
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        switch (response.error!._code){
                        case NSURLErrorTimedOut:
                            //Manager your time out error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        case NSURLErrorNotConnectedToInternet:
                            //Manager your not connected to internet error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        default:
                            //manager your default case
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        }
                        
                    }
                }
            }
    }



    public func getRequestToGetJSONDict(_ url: String, params: [String: AnyObject]?, oauth: Bool, result: @escaping (JSON?, _ error: NSError?, _ statuscode: Int) -> ()){
        var header: [String: String] = [:]
        if oauth {
            if let authToken = authToken {
                header = [:]
                header["Authorization"] = kAuth_String + authToken
            }
            if let userId = userId {
                header["id"] = userId
            }
        }
        
        header["business_id"] = businessId ?? ""
        header["app_id"] = appId ?? ""
        header["version"] = version ?? ""
        
        print(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(k_RequestTimeoutTime)
        manager.request(url, method: .get, parameters: params, headers: header)
            .responseData { response in
                debugPrint("Response Time \(response.timeline.totalDuration) - \(url)")
                // Check status code 403 for authentication
                if response.result.error?._code == nil {
                    if response.response!.statusCode != 403 {
                        let jsonResponse = JSON(data: response.data!)
                        print(jsonResponse)
                        
                        result(jsonResponse, nil, response.response!.statusCode)
                    } else {
                        if let _ = self.userId {
//                            showLoginExpiredAlert()
                            result(nil, self.sessionError as NSError, 403)
                        }
                    }
                } else {
                    if response.result.error!._code == 403 {
//                        showLoginExpiredAlert()
                        result(nil, self.sessionError as NSError, 403)
                    } else {
                        switch (response.error!._code){
                        case NSURLErrorTimedOut:
                            //Manager your time out error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        case NSURLErrorNotConnectedToInternet:
                            //Manager your not connected to internet error
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        default:
                            //manager your default case
                            result(nil, response.result.error as NSError?, response.result.error!._code)
                            break
                        }
                        
                    }
                }
            }
    }
}

