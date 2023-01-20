//
//  UIButton.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 04/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
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
            self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    func centerTextAndImage(spacing: CGFloat) {
           let insetAmount = spacing / 2
           let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
           if isRTL {
              imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
              titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
              contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
           } else {
              imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
              titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
              contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
           }
       }
    
    
    
    func disableBtn(){
        self.backgroundColor = UIColor.AppColor.ButtonBackgroundInvalidGray
        self.setTitleColor(UIColor.AppColor.ButtonTextInvalidGray, for: .normal)
        self.isEnabled = false
    }
    
    func enableBtn(){
        self.backgroundColor = UIColor.AppColor.ButtonBackgroundValidGreen
        self.setTitleColor(UIColor.AppColor.ButtonTextValidWhite, for: .normal)
        self.isEnabled = true
    }
    
    func disableBtnWithImg(_ imageView: UIImageView ,_ image: UIImage){
        self.backgroundColor = UIColor.AppColor.ButtonBackgroundInvalidGray
        self.setTitleColor(UIColor.AppColor.ButtonTextInvalidGray, for: .normal)
        imageView.image = image
        self.isEnabled = false
    }
    
    func enableBtnWithImg(_ imageView: UIImageView ,_ image: UIImage){
        self.backgroundColor = UIColor.AppColor.ButtonBackgroundValidGreen
        self.setTitleColor(UIColor.AppColor.ButtonTextValidWhite, for: .normal)
        imageView.image = image
        self.isEnabled = true
    }
}
