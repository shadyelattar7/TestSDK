//
//  AppDelegate.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 8/13/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import DrawerController
import UserNotifications
//import FirebaseInstanceID
//import FirebaseMessaging
//import Firebase
import RxSwift
import RealmSwift
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settings:Settings?
    static var inApp = false
    var appActive = false
    var deactivateTime: Date?
    
    public static let langId = Locale.current.languageCode
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      //  FirebaseApp.configure()
        
        
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        self.window?.makeKeyAndVisible()
        
//        let config = Realm.Configuration( schemaVersion: 2,
//                                          migrationBlock: { migration, oldSchemaVersion in
//                                            if oldSchemaVersion < 2 {
//                                                migration.enumerateObjects(ofType: Settings.className(), { (oldObject, newObject) in
//                                                    newObject!["appId"] = oldObject!["appId"] as! String
//                                                })
//                                            }
//        }
//        )
//        Realm.Configuration.defaultConfiguration = config
        
        
        
        // get rid of black bar underneath nav bar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions, completionHandler: {_,_ in })
        } else {
            // Fallback on earlier versions
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
//
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
        
//        UNUserNotificationCenter.current().delegate = self


        let authManager = AuthLocalManager()
        if authManager.userExist {
            let backTask = BackTaskRouter()
            backTask.presenter.getMinVersion()
        }
        
        self.settings = Settings()
        
       /* if let firstTime = UserDefaults.standard.object(forKey: "firstTime") as? Bool {
            if firstTime {
                _ = RegRouter()
            } else {
                //_ = AuthRouter()
                _ = IntroRouter()
            }
        } else {
            _ = IntroRouter()
        }*/
        
//        if isDeviceJailbroken() || isJailBroken() || canWriteOutsideSandbox() {
//            fatalError("Jailbroken device")
//        }
        
//        if #available(iOS 13.0, *) { } else {
//            _ = AuthRouter()
//        }
        
//        passLoginStep()
        
//        if let _ = authManager.user?._login {
//            _ = AuthRouter()
//
//        } else {
//            _ = RegRouter()
//
//        }
        
        
        //MARK: - Sentry Configuration
        
        SentrySDK.start { options in
            options.dsn = "https://dda29cd342704a83b0adbc9297f5c1a0@o1052249.ingest.sentry.io/6699135"
            options.debug = true // Enabled debug when first installing is always helpful
            
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
        
        
     

        return true
    }
    
    
    private func passLoginStep(){
        let localManager = AuthLocalManager()
        localManager.save(saveCall: { (user) in
            user._mobile = "00201069739824"
            user._watingForActCode = false
            user._balance = "1000"
        })
        
        _ = NavigationRouter()
    }
    
//    func tokenRefreshNotification(notification: NSNotification) {
//        Messaging.messaging().token { (refreshedToken, error) in
//            print("InstanceID token: \(refreshedToken)")
//            UserDefaults.standard.setValue(refreshedToken, forKey: "token")
//        }
//        connectToFcm()
//    }
    
    func connectToFcm() {
//        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.appActive = false
        if AppDelegate.inApp == true {
            self.deactivateTime = Date()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.appActive = true
        
        guard self.deactivateTime != nil else {
            return
        }
        
        var timeElapsed = Int((self.deactivateTime?.timeIntervalSinceNow)!)
        timeElapsed = timeElapsed * -1
        Util.debugMsg(timeElapsed)
        if timeElapsed > 50 {
            self.deactivateTime = nil
            let backTask = BackTaskRouter()
            backTask.goToRequireAuth()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        print("%@", userInfo)
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] as? [String: AnyObject] {
                if let message = alert["body"] as? String, let title = alert["title"]as? String{
//                    showAlert(message: message, title: title)
                }
            } else if let alert = aps["alert"] as? String {
//                showAlert(message: alert, title: "")
            }
        }
        
    }
    
    func showAlert(message: String, title: String) {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            topWindow.isHidden = true
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true)
    }

    func isDeviceJailbroken() -> Bool {
        #if arch(i386) || arch(x86_64)
        return false
        #else
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt")) ||
            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else {
            return false
        }
        #endif
    }
    
    func isJailBroken() -> Bool {
        #if arch(i386) || arch(x86_64)
        return false
        #else
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || FileManager.default.fileExists(atPath: "/Library/PreferenceLoader/Preferences/LibertyPref.plist")
            || FileManager.default.fileExists(atPath: "/Library/PreferenceBundles/LibertyPref.bundle")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LibertySB.dylib")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LibertySB.plist")
            || FileManager.default.fileExists(atPath: "/usr/lib/Liberty.dylib")
            || FileManager.default.fileExists(atPath: "/Applications/lib/cydia")
            || FileManager.default.fileExists(atPath: "/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist")
            || FileManager.default.fileExists(atPath: "/Library/Frameworks/CydiaSubstrate.framework")
            || FileManager.default.fileExists(atPath: "/private/var/tmp/cydia.log")
            || FileManager.default.fileExists(atPath: "/.cydia_no_stash")
            || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!){
            return true
        } else {
            return false
        }
        #endif
    }
    
    func canWriteOutsideSandbox() -> Bool {
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         //        let config = Realm.Configuration( schemaVersion: 1,
         //                                          migrationBlock: { migration, oldSchemaVersion in
         //                                            if oldSchemaVersion < 1 {
         //                                                migration.enumerateObjects(ofType: Settings.className(), { (oldObject, newObject) in
         //                                                    newObject!["appId"] = oldObject!["appId"] as! String
         //                                                })
         //                                            }
         //        }
         //        )
         //        Realm.Configuration.defaultConfiguration = config
         
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
         
         
         return true
     }

    
    func application(
            _ application: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
//            Messaging.messaging().apnsToken = deviceToken
//            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//            let token = tokenParts.joined()
//            print("Device Token: \(token)")
        }

    
}


//extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//        Util.debugMsg("New Notification")
//        
//        let localManager = AuthLocalManager()
//
//        let userInfo = notification.request.content.userInfo
//       // Messaging.messaging().appDidReceiveMessage(userInfo)
//        AuthLocalManager().save(saveCall: { (user) in
//            user._noOfUnreadNoti = "\( Int(user._noOfUnreadNoti ?? "0")! + 1 )"
//            print("\n\nNoti: Incremented Counter in App Delegate: \(user._noOfUnreadNoti)\n\n")
//        })
//        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
//        NotificationCenter.default.post(name: NSNotification.Name("updateNotification"), object: nil)
//    }
//}
