//
//  UILabel.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 26/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.text = newValue.localized
//            self.text = NSLocalizedString(newValue, comment: "")
        }
    }
}
