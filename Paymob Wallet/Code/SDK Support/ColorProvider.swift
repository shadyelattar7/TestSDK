//
//  ColorProvider.swift
//  Paymob Wallet
//
//  Created by Al-attar on 15/01/2023.
//  Copyright © 2023 mahmoud. All rights reserved.
//

import Foundation
import UIKit

public class ColorProvider {
    // for any color located in bundle where this class has built
    public static func color(named: String) -> UIColor? {
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        return UIColor(named: named, in: bundle, compatibleWith: nil)
    }
}
