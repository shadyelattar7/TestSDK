//
//  Presenter.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/29/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift

class Presenter: NSObject {
    //var currentModule = ""
    var preDisposeBag = DisposeBag()
    private var _userManager:AuthLocalManager?
    static var bankAlis: String = ""
    static var isFav: Bool = false
    
    public var settings: Settings {
        get {
            return Settings.getStettings()
        }
    }
    
    public var userManager:AuthLocalManager{
        get{
            guard self._userManager != nil else {
                self._userManager = AuthLocalManager()
                self._userManager?.userExist
                return self._userManager!
            }
            return self._userManager!
        }
    }
    
    override init(){
    }
    
    
    
    internal func confirm(transaction:Transaction) -> Observable<String>{
        return Observable.create({ (pinObserver) -> Disposable in
            ConfirmationRouter(pinObserver: pinObserver, transaction: transaction)
            return Disposables.create()
        })
    }
    
    func goToDashboard() {
        _ = NavigationRouter()
    }
    func goToNotifications()  {
        _ = NotificationRouter()
    }

    
}
