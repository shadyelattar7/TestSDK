//
//  NotificationRouter.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/18/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit

class NotificationRouter: Router {
    var presenter = NotificationPresenter()
    var notificationNav: UINavController?
    
    override init() {
        super.init()
        self.presenter.router = self
        let notificationController = initController(fromStoryboard: "Notification", controllerName: "notificationVC") as? NotificationViewController
        notificationController?.presenter = self.presenter
        pushToDrawer(controller: notificationController!)
        
        notificationNav = Router.drawerController?.centerViewController as? UINavController
    }
    
    
//    func goToDetailController() {
//        let detailNoti = initController(fromStoryboard: "Notification", controllerName: "detailNotification") as? DetailNotificationViewController
//        detailNoti?.presenter = self.presenter
////        self.push(into: notificationNav!, childController: detailNoti!)
//    }
    
    func goBack(vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
    
    func goToQrDetailsController() {
        let qrDetailController = initController(fromStoryboard: "Notification", controllerName: "NotificationQrDetailsController") as? NotificationQrDetailsController
        qrDetailController?.presenter = presenter
        notificationNav?.navigationItem.title = "Scan Details"
        push(into: notificationNav!, childController: qrDetailController!)
    }
    
    
    func goToNotificationDetailController(_ notification: Notification) {
        let detailNoti = initController(fromStoryboard: "Notification", controllerName: "detailNotification") as? DetailNotificationViewController
        detailNoti?.presenter = presenter
        detailNoti?.notification = notification
        self.push(into: notificationNav!, childController: detailNoti!)
    }
    
    
}
