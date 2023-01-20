//
//  UIViewAnimation.swift
//  Paymob Wallet
//
//  Created by mac on 14/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit
struct ViewAnimation {
    func removeTermsAndConditions(controller:UIViewController){
        UIView.transition(with: controller.view, duration: 0.50, options: [.transitionCrossDissolve], animations: {
            controller.removeFromParent()
            controller.view.removeFromSuperview()
            
        }, completion: nil)
        
    }
}
