//
//  ApiManager.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/22/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireObjectMapper
import RxReachability
import ObjectMapper



class ApiManager {
    static var aes:(iv:Data?,key:Data?,session:String)?
    
    private var currentParams = Dictionary<String,Any>()
    
    public var privateKey:Data?
    
    private var responseJson: Any?
    
    private let ResetPinResponseCode = "1662"
    
    private var Headers:Dictionary<String,String> = ["Content-Type":"application/json","Accept":"application/json"]
    
    // each of the inhearting objects should set this var to request it's type of ecryption
    internal var currentEncryptionState:EncryptionState = .none
    
    
    private var AppAccount:String{
        get {
            return self.settings.appAccount!
        }
    }
    
    
    var settings:Settings {
        return Settings.getStettings()
    }
    
    
    enum EncryptionState {
        case none
        case AES
        case RSA
    }
    
    internal var disposeBag = DisposeBag()
    
    init() {
        let userManager = AuthLocalManager()
        if userManager.userExist {
            if let iv = userManager.user?._iv, let aesKey = userManager.user?._aesKey, let session = userManager.user?._session {
                ApiManager.aes = (iv, aesKey, session)
            }
        }
        
    }
    
    internal func connect<T:Mappable>(with params:Dictionary<String,Any>) -> Observable<T>{
        
        // create the params to be sent
        var fParams = params
        fParams["REQUEST_GATEWAY_CODE"] = self.AppAccount
        fParams["REQUEST_GATEWAY_TYPE"] = self.AppAccount
        fParams["LOGIN"] = self.AppAccount
        fParams["PASSWORD"] = self.AppAccount
        if EntryPoint.langId == "ar" {
            fParams["LANGUAGE1"] = "2"
            //for audi
            //fParams["LANGUAGE1"] = "0"
        } else {
            fParams["LANGUAGE1"] = "1"
        }
        // if we have an app id
        //if self.settings.appId != nil {
        //  fParams["APP_ID"] = self.settings.appId
        //}
        
        Util.debugMsg(self.settings.mainUrl)
        Util.debugMsg(self.settings.mainUrlSecure)
        
        let userManger = AuthLocalManager()
        if userManger.userExist {
            if let appId = userManger.user?._AppId {
                fParams["APP_ID"] = appId
            }
        }
        
        
        Util.debugMsg(fParams)
        self.currentParams = fParams
        
        return Observable<T>.create{ (observable) -> Disposable in
            
            // guard against internet connnection
            guard self.settings.reachability.isReachable else {
                observable.onError(Response(errorMsg: "No Connection", txn: "00"))
                return Disposables.create()
            }
            
            
            switch self.currentEncryptionState {
                
            case .none :
                self.plainRequest(observable: observable)
                break
            case .RSA:
                self.RSARequest(observable: observable)
            case .AES :
                self.AESRequest(observable: observable)
                break
            }
            return Disposables.create()
        }
    }
    
    private func plainRequest<T:Mappable>(observable:AnyObserver<T>){
        Alamofire.request(self.settings.mainUrl, method: .post, parameters: self.currentParams, encoding: JSONEncoding.default, headers: self.Headers)
            .responseString(completionHandler: { (response:DataResponse<String>) in
                Util.debugMsg(response.result.value)
            })
            .responseObject { [weak self](response:DataResponse<T>) in
                guard let self = self else {return}
                if let object = response.result.value {
                    let res = object as? Response
                    print("\n\n\n\n\n\n")
                    if res?.txn == self.ResetPinResponseCode{
                        self.goToPinExpiryScreen(res: res!)
                    }
                    observable.onNext(response.result.value!)
                    observable.onCompleted()
                    return
                }
                
                if (response.response?.statusCode ?? 500) >= 500{
                    observable.onError(Response(errorMsg: "serverError".localized, txn: "500"))
                    print("\nServer Error \(response.response?.statusCode ?? 0)\n")
                    return
                }
                
                observable.onError(Response(errorMsg: "No Connection", txn: "001"))
                
        }
    }
    
    private func RSARequest<T:Mappable>(observable:AnyObserver<T>){
        Alamofire.request(self.settings.mainUrl, method: .post, parameters: self.currentParams, encoding: JSONEncoding.default, headers: self.Headers)
            .responseJSON { (response) in
                Util.debugMsg(response.value)
                
                guard response.response != nil  else{
                    observable.onError(Response(errorMsg: "No Connection", txn: "001"))
                    return
                }
                
                let tag = "RSA".data(using: .utf8)
                let responseValue = response.result.value! as! String
                let decodedData = Data(base64Encoded: responseValue, options: Data.Base64DecodingOptions.init(rawValue: 0))
                
                let (decryptedData, _ ) = try! CC.RSA.decrypt(decodedData!, derKey: self.privateKey! , tag: tag!, padding: .pkcs1, digest: .none)
                
                let jsonString = String(data: decryptedData, encoding: .utf8)!
                
                if let mappedObject = Mapper<T>().map(JSONString: jsonString) {
                    observable.onNext(mappedObject)
                    return
                }else {
                    observable.onError(Response(errorMsg: "Can't map the decrypted JSON", txn: "002"))
                    return 
                }
                
                observable.onError(Response(errorMsg: "No Connection", txn: "001"))
        }
        
    }
    
    
    private func AESRequest<T:Mappable>(observable:AnyObserver<T>){
        
        let request = try! URLRequest(url: self.settings.mainUrlSecure, method: .post, headers: self.Headers)
        
        let encodedRequest = try!  AESEncoding().encode(request,with: self.currentParams)
        
        Alamofire.request(encodedRequest).responseJSON { (response) in
            
            Util.debugMsg(response.value)
            self.responseJson = response.value
        }
        .responseString { (stringResponse) in
            
            let tag = "AES".data(using: .utf8)
            
            guard stringResponse.response != nil  else{
                observable.onError(Response(errorMsg: "No Connection", txn: "001"))
                return
            }
            
            let responseValue = stringResponse.result.value! as! String
            
            if (stringResponse.response?.statusCode ?? 500) >= 500{
                observable.onError(Response(errorMsg: "serverError".localized, txn: "500"))
                print("\nServer Error \(stringResponse.response?.statusCode ?? 0)\n")
                print("\n\n\(stringResponse)\n\n")
                return
            }

            //if response is not encrypted
            Util.debugMsg(self.responseJson)
            if let json = self.responseJson as? [String: Any] {
                if let txn = json["TXNSTATUS"] as? String {
                    Util.debugMsg(txn)
//                    let topVc = UIApplication.shared.delegate?.window??.rootViewController
//                    topVc?.dismiss(animated: true, completion: nil)
                    let router = Router()
                    router.sweetAlertWarningWithOneButton(message: json["MESSAGE"] as! String, afterMsg: {
                        router.anotherApplicationActivated()
                    })
                }
                return
            }
            
            
            let decodedData = Data(base64Encoded: responseValue, options: NSData.Base64DecodingOptions.init(rawValue: 0))
            
            Util.debugMsg(ApiManager.aes?.key)
            Util.debugMsg(ApiManager.aes?.iv)
            Util.debugMsg(ApiManager.aes?.key)
            
            let decryptedData = try! CC.cryptAuth(.decrypt, blockMode: .gcm, algorithm: .aes, data: decodedData!, aData: Data(), key: ApiManager.aes!.key!, iv: ApiManager.aes!.iv!, tagLength: 16)
//            let decryptedData = try! CC.crypt(.decrypt, blockMode: .cbc, algorithm: .aes, padding: CC.Padding.pkcs7Padding, data: decodedData!, key: ApiManager.aes!.key!, iv: ApiManager.aes!.iv!)
            
            let decryptedJSON = String(data: decryptedData, encoding: .utf8)
            
            Util.debugMsg(decryptedJSON)
            
            let object = Mapper<T>().map(JSONString: decryptedJSON!)
            let res = object as? Response
            
//            if res?.txn == "1033" {
//                let topVc = UIApplication.shared.delegate?.window??.rootViewController
//                topVc?.dismiss(animated: true, completion: nil)
//                let router = Router()
//                router.sweetAlertWarningWithOneButton(message: (res?.msg)!, afterMsg: {
//                    //router.globalGoToSetPin()
//                    let toVC = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
//                    let aRouter = AuthRouter(goToSetPin: true)
//                    let vc = aRouter.goToSetPin()
//                    toVC?.pushViewController(vc, animated: true)
//                    return
//                })
//            }
            
            if res?.txn == "622" {
                let topVc = UIApplication.shared.delegate?.window??.rootViewController
                topVc?.dismiss(animated: true, completion: nil)
                let router = Router()
                router.sweetAlertWarningWithOneButton(message: (res?.msg)!, afterMsg: {
                    router.anotherApplicationActivated()
                    return
                })
            }
            
            if res?.txn == self.ResetPinResponseCode{
                
                self.goToPinExpiryScreen(res: res!)
            }
            
            observable.onNext(object!)
            
        }
        
    }
    
    
    
    struct AESEncoding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            
            let json = try JSONSerialization.data(withJSONObject: parameters!, options: .init(rawValue:0))
            
            var encrypted:Data?
            do {
                encrypted = try CC.cryptAuth(.encrypt, blockMode: .gcm, algorithm: .aes, data: json , aData: Data(), key: ApiManager.aes!.key!, iv:ApiManager.aes!.iv!, tagLength: 16)
//                encrypted = try CC.crypt(.encrypt, blockMode: .cbc, algorithm: .aes, padding:CC.Padding.pkcs7Padding, data: json , key: ApiManager.aes!.key!, iv:ApiManager.aes!.iv!)
            } catch let error{
                Util.debugMsg(error.localizedDescription)
            }
            
            let encryptedString =  encrypted!.base64EncodedString(options: .init(rawValue: 0))
            
            let session = ApiManager.aes!.session
            let index = session.startIndex
            let first16 = session.substring(to:session.index(index, offsetBy: 16))
            let last16 = session.substring(from: session.index(index, offsetBy: 16))
            
            Util.debugMsg("Session::\(session)")
            Util.debugMsg("First16::\(first16)")
            Util.debugMsg("Last16::\(last16)")
            
            let finalString = "\(first16)\(encryptedString)\(last16)"
            
            Util.debugMsg(finalString)
            
            var request = try! urlRequest.asURLRequest()
            request.httpBody = finalString.data(using: .utf8)
            
            return request
        }
    }
    
    
    private func goToPinExpiryScreen(res:Response){
        let topVc = UIApplication.shared.delegate?.window??.rootViewController
        topVc?.dismiss(animated: true, completion: nil)
        let router = Router()
        router.sweetAlertWarningWithOneButton(message: (res.msg), afterMsg: {
            //router.globalGoToSetPin()
            AuthRouter(withLogout: true).openLogin()
            let toVC = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
            let aRouter = AuthRouter(goToSetPin: true)
            let vc = aRouter.goToSetPin(forPinExpiry: true)
            toVC?.pushViewController(vc, animated: true)
            return
        })
    }
    
    public func getNumOfUnreadNotification(mobile: String) -> Observable<Response>{
        let params=[
            "TYPE": "GETUNRDNOTI",
            "MSISDN": mobile,
            "BLOCKSMS": "N",
            "SERVICECODE": "ACSOT"
        ]
        return   self.connect(with: params)
    }
    
}


