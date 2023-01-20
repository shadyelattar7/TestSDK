//
//  Get Image .swift
//  Paymob Wallet
//
//  Created by Al-attar on 15/01/2023.
//  Copyright © 2023 mahmoud. All rights reserved.
//

import Foundation
import UIKit

public class ImageProvider {
    // for any image located in bundle where this class has built
    public static func image(named: String) -> UIImage? {
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        return UIImage(named: named, in: bundle, with: nil)
    }
}
