//
//  Util.swift
//  RevoxTv
//
//  Created by Ahmed Aldaly on 7/24/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit

class Util{
    
    
    
    static func debugMsg<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        let debug:Bool = Bool (Util.getValue(for: "debug", pList: "Settings"))!
        if debug {
            let value = object()
            let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
            let queue = Thread.isMainThread ? "UI" : "BG"
            
            print("<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
        }
    }
    
    // for retriving APIkeys from info.plist
    static func getValue(for Key:String,pList:String) -> String {
        // Get the file path for keys.plist
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        let filePath = bundle?.path(forResource: pList, ofType: "plist")
        
        // Put the keys in a dictionary
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        // Pull the value for the key
        let value:String = plist?.object(forKey: Key) as! String
        
         return value
    }

    
    
    // for retriving APIkeys from info.plist
    static func get(pList:String) -> NSDictionary? {
        // Get the file path for keys.plist
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        let filePath = bundle?.path(forResource: pList, ofType: "plist")
        
        // Put the keys in a dictionary
        return NSDictionary(contentsOfFile: filePath!)
        
    }
   
    static func color(fromHex value: UInt) -> UIColor{
        return Util.color(fromHex: value, alpha: 1.0)
    }
    
    // gets A UIColor object from a hex value and alpha
    static func color(fromHex value: UInt,alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static func convertArDigitToEn (digit: String) -> Double {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = Formatter.number(from: digit)
        if let num = final {
            print("\(num)")
            return Double(num)
        }
        return 0.0
    }
    


}
