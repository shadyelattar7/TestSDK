//
//  UIColor.swift
//  Paymob Wallet
//
//  Created by Mohamad el mohamady Ghonem on 6/21/22.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // You can directly make some static color using this way.
//    static let kAppTheme = UIColor(red: 123, green: 56, blue: 243)

    convenience init(netHex:Int) {
        self.init(red:CGFloat((netHex >> 16) & 0xff), green:CGFloat((netHex >> 8) & 0xff), blue:CGFloat(netHex & 0xff), alpha: 1.0)
    }

    class func colorWithHex(hex: String) -> UIColor {

        var colorString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove prefix if contain # at 0th position.
        if colorString.hasPrefix("#") { colorString.remove(at: colorString.startIndex) }
        if colorString.count != 6 { return UIColor.gray }

        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)

        return UIColor (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }

    struct AppColor {
        static let ButtonBackgroundInvalidGray = ColorProvider.color(named: "ButtonBackgroundInvalidGray")
        static let ButtonBackgroundValidGreen = ColorProvider.color(named: "ButtonBackgroundValidGreen")
        static let ButtonTextValidWhite = ColorProvider.color(named: "ButtonTextValidWhite")
        static let ButtonTextInvalidGray = ColorProvider.color(named: "ButtonTextInvalidGray")
        static let LabelGray = ColorProvider.color(named: "LabelGray")
        static let LabelGreen = ColorProvider.color(named: "LabelGreen")
        static let LabelLightGreenBackground = ColorProvider.color(named: "LabelLightGreenBackground")
        static let LabelLightRedBackground = ColorProvider.color(named: "LabelLightRedBackground")
        static let LabelLightYellowBackground = ColorProvider.color(named: "LabelLightYellowBackground")
        static let LabelRed = ColorProvider.color(named: "LabelRed")
        static let mainText = ColorProvider.color(named: "mainText")
        static let OffWhiteBackground = ColorProvider.color(named: "OffWhiteBackground")
        static let subMainText = ColorProvider.color(named: "subMainText")
        static let seperator = ColorProvider.color(named: "Seperator")

    }

}


