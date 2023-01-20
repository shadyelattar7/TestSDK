//
//  FontProvider.swift
//  Paymob Wallet
//
//  Created by Al-attar on 16/01/2023.
//  Copyright © 2023 mahmoud. All rights reserved.
//

import UIKit
import Foundation


public extension UIFont {
    
     static func registerFont(withFilenameString filenameString: String, bundle: Bundle = Bundle(identifier: "Al-attar.HalanFramework")!) {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
     
