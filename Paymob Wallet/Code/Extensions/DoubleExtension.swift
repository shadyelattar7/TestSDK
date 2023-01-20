//
//  DoubleExtension.swift
//  Paymob Wallet
//
//  Created by Al-attar on 03/10/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
