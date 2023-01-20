//
//  UIImageView.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 28/06/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

extension UIImageView {
    
    @IBInspectable var IsFlippable:Bool {
        get{return true}
        set{
            if newValue{
                self.flipImage()
            }
        }
    }

    func flipImage(){
           if EntryPoint.langId == "en" {
               self.transform = CGAffineTransform(scaleX: -1, y: 1)
           }
           
       }
}
