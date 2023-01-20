
//
//  File.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/18/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift
import Realm
import Reachability


class Settings:Object {
    
    static private var settings:Settings?
    
    
    private var settingsDict: NSDictionary?
    private var settingsName = "Settings"
    
   // cached data
    @objc dynamic var _appId:String?
    
    
    var debug:Bool {
    return Bool(self.settingsDict!["debug"] as! String)!
}
    
    private var _reachability:Reachability?
    var reachability:Reachability{
        get{
       
            guard self._reachability != nil else {
                do{
                    try self._reachability = Reachability()
                }catch{}
                try! self._reachability!.startNotifier()
                return self._reachability!
            }
            return self._reachability!
        }
    }

    var appId:String?{
        get{
            guard self._appId != nil else {
                return nil
            }
            return _appId!
        }
        set{
            try! self.realm?.write {
                self._appId = newValue
            }
            
        }
    }
    var appAccount:String?{
        if debug{
            return settingsDict!["appAccStaging"] as! String
        }else{
            return settingsDict!["appAccProduction"] as! String
        }
        
    }
    
    
    var webViewLink:String{
        if debug{
            return settingsDict!["webViewStaging"] as! String
        }else{
            return settingsDict!["webViewProduction"] as! String
        }
        
    }
    
    

    var imageBase: String {
        //let normalSegment = settingsDict!["normal"] as! String
        
        if debug {
            let url = settingsDict!["debugURL"] as! String
            //url.append(normalSegment)
            return url
        }
        let url = settingsDict!["productionURL"] as! String
        //url.append(normalSegment)
        return url
    }
    var mainUrl:String {
        let normalSegment = settingsDict!["normal"] as! String
        
        if debug {
            var url = settingsDict!["debugURL"] as! String
            url.append(normalSegment)
            return url
        }
        var url = settingsDict!["productionURL"] as! String
        url.append(normalSegment)
        return url
    }
    
    var mainUrlSecure:String {
        let secureSegment = settingsDict!["secure"] as! String
        
        if debug {
            var url = settingsDict!["debugURL"] as! String
            url.append(secureSegment)
            return url
        }
        var url = settingsDict!["productionURL"] as! String
        url.append(secureSegment)
        return url
    }
    
    
    
    var primaryColor: UIColor {
        get{
            guard self.settingsDict?.value(forKey: "primaryColor") != nil else {
                return Util.color(fromHex: 0x0097E1)
            }
            let hexString = self.settingsDict?.value(forKey: "primaryColor") as! String
            let hex = UInt(hexString, radix: 16)
            
            return Util.color(fromHex: hex!)
        }
    }
    var secColor: UIColor {
        get{
            guard self.settingsDict?.value(forKey: "secondaryColor") != nil else {
                return Util.color(fromHex: 0x000000)
            }
            let hexString = self.settingsDict?.value(forKey: "secondaryColor") as! String
            let hex = UInt(hexString, radix: 16)
            
            return Util.color(fromHex: hex!)
        }
    }
    var bottomBarColor: UIColor {
        get{
            guard self.settingsDict?.value(forKey: "bottomBarColor") != nil else {
                return Util.color(fromHex: 0x000000)
            }
            let hexString = self.settingsDict?.value(forKey: "bottomBarColor") as! String
            let hex = UInt(hexString, radix: 16)
            
            return Util.color(fromHex: hex!)
        }
    }
    
    internal required init(){
        super.init()
        self.settingsDict = Util.get(pList: settingsName)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public func get(key:String) -> Any?{
        return self.settingsDict?[key]
    }
    // settings is a singilton so we are sure that changes in settngs values probagate instantly
    static func getStettings() -> Settings{
        guard self.settings != nil else {
            self.settings = Settings()
            return self.settings!
        }
        return self.settings!
        
    }
    
   
    
    
    
}
