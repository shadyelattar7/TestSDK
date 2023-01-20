//
//  EntryPoint.swift
//  Paymob Wallet
//
//  Created by Al-attar on 11/01/2023.
//  Copyright © 2023 mahmoud. All rights reserved.
//

import Foundation
import UIKit
import Sentry
import DrawerController
import RealmSwift

public class EntryPoint{
    
    public static var window: UIWindow?
    static var settings:Settings?
    public static var inApp = false
    var appActive = false
    var deactivateTime: Date?
    
    public static let langId = Locale.current.languageCode
    
    public init(){}
    
    
    private func AppDelegateSetup(window: UIWindow){
        EntryPoint.window = window
        EntryPoint.settings = Settings()
        
        //Get rid of black bar underneath nav bar
        NavigationSetup()
        
        //Get min version
        getMinVersion()
        
        //Setup sentry
        setupSentry()
        
        //Setup Realm
        //setupRealm()
        
        //Load Fonts
        loadFonts()
        
    }
    
    public func startPoint(window: UIWindow, VC: UIViewController){
        EntryPoint.window = window
        EntryPoint.settings = Settings()
        
        AppDelegateSetup(window: window)
        
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        let vc = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        vc.modalPresentationStyle = .fullScreen
        VC.present(vc, animated: true)
    }
    
    //MARK: - Get rid of black bar underneath nav bar
    
    private func NavigationSetup(){
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK: - Get min version
    
    private func getMinVersion(){
        let authManager = AuthLocalManager()
        if authManager.userExist {
            let backTask = BackTaskRouter()
            backTask.presenter.getMinVersion()
        }
    }
    
    //MARK: - Setup sentry
    
    private func setupSentry(){
        SentrySDK.start { options in
            options.dsn = "https://dda29cd342704a83b0adbc9297f5c1a0@o1052249.ingest.sentry.io/6699135"
            options.debug = true // Enabled debug when first installing is always helpful
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
    }
    
    //MARK: - Setup Realm
    
    private func setupRealm(){
        var lastSchemaVesion: UInt64 = 0
        let configCheck = Realm.Configuration();
        do {
            lastSchemaVesion = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(lastSchemaVesion)")
        } catch  {
            print("error in founding fileURl -> ", error)
        }
        
        let newSchemaVersion = lastSchemaVesion + 1
        
        let config = Realm.Configuration( schemaVersion: newSchemaVersion,
                                          migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < newSchemaVersion {
                migration.enumerateObjects(ofType: Settings.className(), { (oldObject, newObject) in
                    newObject!["appId"] = oldObject!["appId"] as! String
                })
            }
        }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK: - Load Fonts
    
    private func loadFonts(){
        UIFont.registerFont(withFilenameString: "GE_SS_Two_Bold.ttf")
        UIFont.registerFont(withFilenameString: "GE_SS_Two_Light.ttf")
        UIFont.registerFont(withFilenameString: "DIN Next LT Arabic Medium.ttf")
        UIFont.registerFont(withFilenameString: "DIN Next LT Arabic Bold.ttf")
        UIFont.registerFont(withFilenameString: "GE_SS_Two_Medium.ttf")
    }
    
}
