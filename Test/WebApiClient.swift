////
////  WebApiClient.swift
////  SwiftTest
////
////  Created by Pankaj Kumar on 10/02/17.
////  Copyright © 2017 Pankaj Kumar. All rights reserved.
////
//
import UIKit
import Alamofire
import KVNProgress
import AlamofireImage

var sampleKey = "qdIK6Sc0prFrRdOKJbZMsLnrCqZzwSBp"

class WebApiClient: NSObject {
    // Production
    static let shared: WebApiClient = WebApiClient(baseURL:URL.init(string: "http://api.nytimes.com/svc/mostpopular/v2/")!)

    
    let baseURL: URL
//    var headers: HTTPHeaders
    let decoder = JSONDecoder()
    var net = NetworkReachabilityManager()
    var isNetworkNotReachable : Bool {
        get {
            if self.net?.networkReachabilityStatus == .notReachable {
                self.net = NetworkReachabilityManager()
                self.net?.startListening()
                KVNProgress.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first

                    AlertController.actionSheet("", message: "No internet connection available.", sourceView: keyWindow?.rootViewController?.presentedViewController?.view as Any, buttons: ["Try Again"], tapBlock: nil)
                }

                return true
            }else {
                return false
            }
        }
    }
    
    
    
    // Initialization
    private init(baseURL: URL) {
        self.baseURL = baseURL
        self.net?.startListening()

//        if AppDelegate.instance.AppUser != nil {
//            self.headers = [
//                "Accept": "application/json",
//                "Content-Type": "application/x-www-form-urlencoded",
//                "authorization": AppDelegate.instance.AppUser.token?.auth_token ?? ""
//            ]
//        }else {
//            self.headers = [
//                "Accept": "application/json",
//                "Content-Type": "application/x-www-form-urlencoded"
//            ]
//        self.headers = [
//            "Accept": "application/json",
//            "Content-Type": "application/json"
//        ]

//        }
        
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringCacheData
        //        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 30
    }
    


    
    
    
    
    
    
    
    
    
    
    
    //     MARK:- Print Module
    func getData(period: String, completion:@escaping (_ result:[Product]?) -> Void) {
        if isNetworkNotReachable { return}
        
        KVNProgress.show()
        Alamofire.request(URL(string: "viewed/\(period).json?api-key=\(sampleKey)", relativeTo: baseURL)!, method: .get, encoding: JSONEncoding.default, headers: [:]).response { (resposne) in
            KVNProgress.dismiss()
//            self.printRequest(resposne)
            do {
                let data = try self.decoder.decode(DataModel.self, from: resposne.data ?? Data())
                if data.status == "OK" {
                    completion(data.results)
                }else {
                    self.handleError(data: resposne.data)
                }

            } catch let error {
                self.handleError(data: resposne.data, error: error)
            }

                
        }
    }
    

    
    
    


}


































extension WebApiClient {
    // to hadle error of api on response
    private func handleError(data: Data?, error:Error? = nil){
        if (data == nil || data?.count == 0 ){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if KVNProgress.isVisible() { return }
                let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

                AlertController.actionSheet("", message: "Internet connection failed.", sourceView: keyWindow?.rootViewController?.presentedViewController?.view as Any, buttons: ["Try Again"], tapBlock: nil)
            }
            return
        }
        
        guard let errorV = try? self.decoder.decode(ErrorModel.self, from:data! ) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if KVNProgress.isVisible() { return }
                let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

                AlertController.actionSheet("", message: "Json parsing error.", sourceView: keyWindow?.rootViewController?.presentedViewController?.view as Any, buttons: ["Try Again"], tapBlock: nil)
            }
            return
        }
        printDebug(errorV)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if KVNProgress.isVisible() { return }
                let msg = errorV.msg?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                AlertController.alert(msg ?? "error")
            }
    }

    // To print request
     private func printRequest(_ response: DefaultDataResponse) {
        #if DEBUG
        // debug only code
        printDebug(
            """
            \n
            API Request:-
            --------------
            URL         : \(response.request?.url?.absoluteString ?? "")
            Headers     : \(response.request?.allHTTPHeaderFields ?? [:])
            HTTP Method : \(response.request?.httpMethod ?? "")
            Parameters  : \(String(bytes: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "")
            StatusCode  : \(response.response?.statusCode ?? 0)
            Response    : \n\(String(bytes: response.data ?? Data(), encoding: .utf8) ?? "")
            \n\n
            """
        )
        #else
        // release only code
        #endif
    }
    

}



//MARK:- Comment Line to disable all logs
func printDebug<T>(_ obj: T) {
    #if DEBUG
    // debug only code
    print(obj)
    #else
    // release only code
    #endif
}





func jsonObject(from object:Data) -> Any? {

//    guard let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) else {
//        return nil
//    }

    guard let json = try? JSONSerialization.jsonObject(with: object , options: []) else {
        return nil
    }
    return json
}

func jsonString(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}




func jsonStringToModel<T : Codable>(_ jsonString: String, type: T.Type) -> T? {
    guard let json = try? JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) else {
        return nil
    }
    
    guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
        return nil
    }

    do {
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    } catch let error {
        printDebug(error.localizedDescription)
        return nil
    }

}


func jsonToModel<T : Codable>(_ json: Any, type: T.Type) -> T? {
    guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
        return nil
    }
    
    do {
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    } catch let error {
        printDebug(error.localizedDescription)
        return nil
    }
    
}



func jsonFromModel<T : Codable>(_ model: T) -> Any? {
    do {
        let jsonData = try JSONEncoder().encode(model)
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            return nil
        }
        return json
    } catch let error {
        printDebug(error.localizedDescription)
        return nil
    }
}





class MyError: NSError {
    var customDescription: String = ""
    init() {
        super.init(domain: "MyError", code: 100, userInfo: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
    static var PDF: [UInt8] = [0x25]
    static var PLAIN: [UInt8] = [0x46]
}

enum mimeType : String {
    case Unknown = ""
    case PNG = "image/png"
    case JPEG = "image/jpeg"
    case GIF = "image/gif"
    case TIFF = "image/tiff"
    case PDF = "application/pdf"
    case PLAIN = "text/plain"
}


extension Data{
    var imageFormat: mimeType {
        var buffer = [UInt8](repeating: 0, count: 1)
        (self as NSData).getBytes(&buffer, range: NSRange(location: 0,length: 1))

        if buffer == ImageHeaderData.PNG
        {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG
        {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF
        {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .TIFF
        } else if buffer == ImageHeaderData.PDF
        {
            return .PDF
        }else if buffer == ImageHeaderData.PLAIN
        {
            return .PLAIN
        } else{
            return .Unknown
        }
    }
}

