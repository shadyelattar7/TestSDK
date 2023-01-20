//
//  File.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/14/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import RxSwift
class UpperViewPresenter: Presenter {
    
    var router:UpperViewRouter?
    var nameObserver = BehaviorSubject<String>(value:"")
    var balanceObserver = BehaviorSubject<String>(value:"")
    var imageObserver = BehaviorSubject<UIImage>(value:UIImage())
    override init() {
        super.init()
        
        guard self.userManager.userExist else{
            nameObserver.onNext("Error")
            balanceObserver.onNext("0.0.0")
            imageObserver.onNext(ImageProvider.image(named:"man")!)
            return
        }
        
        nameObserver.onNext(self.userManager.user!._name)
        balanceObserver.onNext("\(self.userManager.user!._balance!) \("egp".localized)")
        //imageObserver.onNext(UIImage(named:self.userManager.user!._image)!)
        if let image = self.userManager.user?._image {
            imageObserver.onNext(UIImage(data:image)!)
        } else {
            imageObserver.onNext(ImageProvider.image(named:"man")!)
        }
    }
    
}
