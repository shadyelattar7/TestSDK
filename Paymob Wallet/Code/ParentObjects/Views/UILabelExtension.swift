//
//  UILabelExtension.swift
//  RevoxTv
//
//  Created by Ahmed Aldaly on 8/5/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
extension UILabel {
    
   
    func fontStyle(){
        //self.textColor = self.settings.primaryColor
//        self.textColor = self.settings.primaryColor
        
//        if self.state == .primary {
//            self.textColor = self.settings.primaryColor
//        } else {
//            self.textColor = self.settings.primaryColor
//        }
        
        //TODO:: add the needed font
    }
   }


class PaymobUILabel:UILabel {
    var customStyle:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !customStyle{
            fontStyle()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !customStyle{
            fontStyle()
        }
    }


}
