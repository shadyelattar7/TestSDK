//
//  DeviceExtension.swift
//  Paymob Wallet
//
//  Created by Al-attar on 26/09/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    static var hsNotch: Bool{
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
