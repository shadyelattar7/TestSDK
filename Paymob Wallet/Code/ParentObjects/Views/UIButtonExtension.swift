//
//  UIButtonExtension.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 9/7/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PaymobUIButton: UIButton {
    
    var disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = self.settings.secColor
        self.titleLabel?.font =  UIFont(name: "Helvetica-Neue", size: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.backgroundColor = self.settings.secColor
        
        self.rx.tap.subscribe(onNext: {
            self.superview?.endEditing(true)
        })
        .disposed(by: disposeBag)
    }
    

}
