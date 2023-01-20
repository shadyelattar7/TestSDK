//
//  AlertableStack.swift
//  Paymob Wallet
//
//  Created by Al-attar on 19/09/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AlertableStack: UIStackView{
   
    
    private lazy var alert = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackConfiguration()
        
    }
    
    private func stackConfiguration(){
        alert = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        alert.text = "custom alert"
        alert.font = UIFont.systemFont(ofSize: 12)
        alert.textColor = .red
        self.spacing = 2.0
        self.addArrangedSubview(alert)
    }
    
   
}
