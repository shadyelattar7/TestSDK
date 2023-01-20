//
//  PayMobViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxKeyboard
import RxSwift

class PayMobViewController: UIViewController {
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        
    }
    let tap = UITapGestureRecognizer()
    let disposeBag = DisposeBag()
    var settings:Settings {
        get {
            return Settings.getStettings()
            
        }
    }
    
    func keyBoard(withPush:Bool = true){
        
        RxKeyboard.instance.visibleHeight.drive(onNext: { (height) in
            Util.debugMsg(height)
            if withPush {
                self.view.frame.origin.y = -1*height
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        self.view.addGestureRecognizer(tap)
        self.tap.cancelsTouchesInView = false
        self.tap.addTarget(self, action: #selector(dismissTapped))
    }
    
    @objc func dismissTapped() {
        self.view.endEditing(true)
    }
    
    var viewDidLoadObserver:Observable<Void> {
    
        return self.rx.sentMessage(#selector(PayMobViewController.viewDidLoad)).map{ _ in Void()  }
    }
    
    
    
}
