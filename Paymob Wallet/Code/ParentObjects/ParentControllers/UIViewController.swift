//
//  UIViewController.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 12/12/21.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    
    
    func back(animated: Bool = true) {
        
        //HAndle back in notidication view controllers
        //        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        //        let viewController = appDelegate.window?.rootViewController
        //        if (viewController == self) {
        //            let defaultViewController = SplashViewController.instance()
        //            defaultViewController.modalPresentationStyle = .fullScreen
        //            present(defaultViewController, animated: false, completion: nil)
        //            return
        //        }
        
        if let nav = self.navigationController {
            nav.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
}
