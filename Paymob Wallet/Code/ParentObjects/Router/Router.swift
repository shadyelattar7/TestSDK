//
//  Router.swift
//  RevoxTv
//
//  Created by Ahmed Aldaly on 7/25/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import Foundation
import UIKit
import DrawerController
import RealmSwift
import RxSwift

// To be implemented 
public enum MsgDuration: Double {
    case Short = 0.3
    case Long = 1.0
}

class Router: NSObject{
    static var drawerController: DrawerController?
    
    static var NavRouter:NavigationRouter?
    
    
    private var _window: UIWindow?
    private var _settings: Settings?
    private var _alert:UIAlertController?
    private var _alertShowing:Bool = false
    private var _upperView:UIView? // it's assined for the upper part of the name and transaction
    
    var centerContainer: DrawerController?
    
    
    public var window:UIWindow{
        get{
            return self._window!
        }
    }
    
    public var settings: Settings {
        get {
            return self._settings!
        }
    }
    
    public struct Duration{
        var Short = 0.3
        var Long = 1.0
    }
    
    override init(){
        super.init()
        self._window = getWindow()
        print("\n\n\n\n\n\n\n\n\n\n")
        
        print(UIApplication.shared.windows.first)
        
        print("\n\n\n\n\n\n\n\n\n\n")
        self._settings = Settings.getStettings()
    }
    
    
    func getWindow()->UIWindow{
        var window = EntryPoint.window
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.first
            //            print("\n\n\n\n\n\n\n\n\n\n\n")
            //            print("ios 13")
            print(UIApplication.shared.windows.first)
            //            print("\n\n\n\n\n\n\n\n\n\n\n")
        }else{
            window = EntryPoint.window
        }
        guard let hardWindow = window else {
            print("UI WInodw Is Nil And creating New ONe ")
            return UIWindow()
        }
        return hardWindow
    }
    
    func goToDashboard(){
        Router.NavRouter?.goToDashboard()
    }
    func openAsRootView(controller:UIViewController,withTransition:Bool = false){
        guard withTransition else {
            self._window!.rootViewController = controller
            self._window!.makeKeyAndVisible()
            return
        }
        
        UIView.transition(with: self.window, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            self._window!.rootViewController = controller
            self._window!.makeKeyAndVisible()
        }, completion: nil)
        
        
        //self._window!.makeKeyAndVisible()
        
        /*will implement to add many kinds of animations to the entring and leaving views*/
        //self._window!.layer.addAnimation(self.loadWindowWithAnimation(), forKey: "loadFromRight")
        
    }
    
    /* add the given UIViewController underneth the appearing one */
    func addUnder(controller:UIViewController) {
        //TODO:: to be implemented
    }
    
    /* add the given UIViewController modally */
    func openModally(controller:UIViewController, transition: UIModalTransitionStyle) {
        let presentingController = self._window!.rootViewController!
        controller.modalTransitionStyle = transition
        controller.modalPresentationStyle = .fullScreen
        presentingController.present(controller, animated: true, completion: nil)
    }
    
    
    func loadWindowWithAnimation()->CATransition{
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromRight
        slideInFromLeftTransition.duration = 0.3
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        
        return slideInFromLeftTransition;
    }
    
    func initController(fromStoryboard:String,controllerName:String) -> UIViewController{
        let bundle = Bundle(identifier: "Al-attar.HalanFramework")
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: fromStoryboard, bundle: bundle)
        return mainStoryBoard.instantiateViewController(withIdentifier: controllerName)
    }
    
    func globalGotoMobileValidation () {
        let realm = try? Realm()
        let result = realm?.objects(User.self)
        try? realm?.write {
            realm?.delete(result!)
        }
        _ = AuthRouter()
    }
    
    func anotherApplicationActivated () {
//        let realm = try? Realm()
//        let result = realm?.objects(User.self)
//        try? realm?.write {
//            realm?.delete(result!)
//        }
        AuthLocalManager().deleteAll()
        _ = AuthRouter(withLogout: true)
    }
    
    func embedd(into controller:UIViewController, childController:UIViewController, containerView: UIView){
        controller.addChild(childController)
        childController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        containerView.addSubview(childController.view)
        childController.didMove(toParent: controller)
    }
    
    func push(into navController:UINavigationController, childController:UIViewController){// get the UINav automatically
        navController.pushViewController(childController, animated: true)
    }
    
    func pushToDrawer(controller:UIViewController){
        if Router.NavRouter != nil {
            Router.NavRouter?.addToCenter(controller: controller)
        }
    }
    
    
    func displayAlert(msg:String,title:String = "",hideAfter:TimeInterval = 0.0,onComplete:@escaping ()->() = {} ){
        if hideAfter > 0.0 {
            let _ = Timer.scheduledTimer(timeInterval: hideAfter, target: self, selector: #selector(self.hideMsg), userInfo: nil, repeats: false)
            self._alertShowing = true
        }
        if _alertShowing  {
            self._alert?.title = title
            self._alert?.message = msg
            self._alertShowing = true
            return
        }else{
            self._alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            self._alertShowing = true
        }
        
        let vc = self._window!.rootViewController!
        let controller = self.top(vc: vc)
        controller.present(self._alert!, animated: true, completion: {
            self._alertShowing = true
        })
    }
    
    @objc func hideMsg(afterMsg:@escaping ()->Void){
        if _alertShowing {
            self._alert?.dismiss(animated: true, completion: {
                self._alertShowing = false
                afterMsg()
            })
        }
    }
    
    /* add the given UIViewController modally */
    func addModally(controller:UIViewController, transition: UIModalTransitionStyle, presentation: UIModalPresentationStyle = .fullScreen) {
        let presentingController = self.top(vc: self.window.rootViewController!)
        controller.modalTransitionStyle = transition
        controller.modalPresentationStyle = presentation
        presentingController.present(controller, animated: true, completion: nil)
    }
    func closeModal(){
        let presentingController = self.top(vc: self.window.rootViewController!)
        presentingController.dismiss(animated: true, completion: nil)
        
    }
    
//    func customDismiss(vc: UIViewController)
    
    // with support for arabic
    
    func toogleDrawer() {
//        if AppDelegate.langId == "ar" {
//            let containerController = window.rootViewController as! DrawerController
//            containerController.toggleDrawerSide(.right, animated: true, completion: nil)
//        } else {
//            let containerController = window.rootViewController as! DrawerController
//            containerController.toggleDrawerSide(.left, animated: true, completion: nil)
//        }
    }
    
    ///for audi toogle drawer without arabic
    /*
     func toogleDrawer() {
     let containerController = window.rootViewController as! DrawerController
     containerController.toggleDrawerSide(.left, animated: true, completion: nil)
     }
     */
    func closeDrawer() {
        let containerController = window.rootViewController as! DrawerController
        containerController.closeDrawer(animated: true, completion: nil)
    }
    
    func top(vc:UIViewController) -> UIViewController {
        
        if let navigationController = vc as? UINavigationController {
            
            return self.top( vc: navigationController.visibleViewController!)
            
        } else if let tabBarController = vc as? UITabBarController {
            
            return self.top(vc: tabBarController.selectedViewController!)
            
        } else {
            if let presentedViewController = vc.presentedViewController {
                return self.top(vc: presentedViewController)
            } else {
                return vc;
            }
        }
    }
    
    var alertShowing = false
    var alertView = UIView()
    let containerView = UIView()
    var conBottom = NSLayoutConstraint()
    
    func sweetAlertSuccess(message: String, afterMsg:@escaping ()->Void) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController{
            while let presentedController = vc.presentedViewController {
                vc = presentedController
            }
            self.showCustomAlert(vc: vc, message: message, image: ImageProvider.image(named: "success")!, completed: {
                afterMsg()
            })
        }
        
        //        SweetAlert().showAlert(NSLocalizedString("success", comment: "success"), subTitle: message, style: .success, buttonTitle: NSLocalizedString("ok", comment: "ok")) { (tapped) in
        //            if tapped {
        //                afterMsg()
        //            }
        //        }
    }
    
    func sweetAlertFail(message: String, afterMsg:@escaping ()->Void) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController{
            while let presentedController = vc.presentedViewController {
                vc = presentedController
            }
            self.showCustomAlert(vc: vc, message: message, image: ImageProvider.image(named: "error")!, completed: {
                afterMsg()
            })
        }
        
        /*SweetAlert().showAlert(NSLocalizedString("error", comment: "error"), subTitle: message, style: .error, buttonTitle: NSLocalizedString("ok", comment: "ok")) { (tapped) in
         if tapped {
         afterMsg()
         }
         }*/
    }
    
    func sweetAlertWarning(message: String, afterMsg:@escaping ()->Void) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController{
            while let presentedController = vc.presentedViewController {
                vc = presentedController
            }
            self.showCustomAlert(vc: vc, message: message, image: ImageProvider.image(named: "info")!, completed: {
                afterMsg()
            })
        }
        //        SweetAlert().showAlert(NSLocalizedString("Warning", comment: "warning"), subTitle: message, style: .warning, buttonTitle: NSLocalizedString("ok", comment: "ok"), buttonColor: .red, otherButtonTitle: NSLocalizedString("cancel", comment: "cancel"), otherButtonColor: .gray) { (tapped) in
        //            if tapped {
        //                afterMsg()
        //            } else {
        //            }
        //        }
    }
    
    func sweetAlertWarningWithOneButton(message: String, afterMsg:@escaping ()->Void){
        SweetAlert().showAlert("Warning".localized, subTitle: message, style: .warning, buttonTitle: "ok".localized) { (tapped) in
            if tapped {
                afterMsg()
            }
        }
    }
    
    func showAlert(message: String, title: String) {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            topWindow.isHidden = true
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true)
    }
    
    func showAlertWithAcceptAndReject(message: String, title: String) {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            topWindow.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            exit(0)
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true)
    }
    
    func showCustomAlert(vc: UIViewController, message: String, image: UIImage, completed: @escaping ()->()) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let alertVc = storyBoard.instantiateViewController(withIdentifier: "AlertVC") as! CustomAlertController
        alertVc.bodyString = message
        alertVc.titleString = "Thanks"
        alertVc.image = image
        alertVc.tapped.subscribe(onNext: { (value) in
            Util.debugMsg(value)
            if value {
                completed()
            }
        })
        vc.present(alertVc, animated: true, completion: nil)
    }
    
    func showCustomAlertWith2Butons(vc: UIViewController, message: String, image: UIImage, completed: @escaping (Bool)->()) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let alertVc = storyBoard.instantiateViewController(withIdentifier: "customAlertWithTwoController") as! CustomAlertWithTwoController
        alertVc.bodyString = message
        alertVc.titleString = "Thanks"
        alertVc.image = image
        _ = alertVc.tapped.subscribe(onNext: { (value) in
            Util.debugMsg(value)
            if value {
                completed(true)
            } else {
                completed(false)
            }
        })
        vc.present(alertVc, animated: true, completion: nil)
    }
    
    func sweetAlertWarningWithTwoButton(message: String, afterMsg:@escaping (Bool)->Void){
        if var vc = UIApplication.shared.keyWindow?.rootViewController{
            while let presentedController = vc.presentedViewController {
                vc = presentedController
                //            self.showCustomAlert(vc: vc, message: message, image: #imageLiteral(resourceName: "info"), completed: {
                //                afterMsg()
                //            })
            }
            self.showCustomAlertWith2Butons(vc: vc, message: message, image: ImageProvider.image(named: "info")!) { (value) in
                if value {
                    afterMsg(true)
                } else {
                    afterMsg(false)
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func showSetRateView(TXNID :String){

        let presentingController = self.top(vc: self.window.rootViewController!)
        print("presentingController",presentingController)

        let rateView = RateRouter(TXNID: TXNID)

        UIView.transition(with: presentingController.view, duration: 0.50, options: [.transitionCrossDissolve], animations: {
            presentingController.addChild(rateView.viewController)
            presentingController.view.addSubview(rateView.viewController.view)
        }, completion: nil)
    }
}
