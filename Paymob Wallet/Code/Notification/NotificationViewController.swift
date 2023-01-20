//
//  NotificationViewController.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/18/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationViewController: InactivateController {
    var presenter: NotificationPresenter?
    var notifications = [Notification]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        
        //self.presenter?.getAllNotification()
        presenter?.addBarButtons(vc: self)
        
//        self.presenter?.notificationArray.asObservable().subscribe(onNext: { (_) in
//            self.tableView.reloadData()
//        }).disposed(by: self.disposeBag)
        
//        self.presenter?.notificationArray.bind(to: tableView.rx.items(cellIdentifier: "notificationCell", cellType: NotificationCell.self)){(row, notification, cell) in
//            Util.debugMsg(notification)
//            cell.updateCell(notification: notification)
//
//        }.disposed(by: disposeBag)
        
//        self.tableView.rx.itemSelected.subscribe(onNext: {[weak self](indexPath: IndexPath) in
//            //self?.tableView.deselectRow(at: indexPath, animated: true)
//
////            self?.presenter?.cellSelected(row: indexPath.row)
//
//
//            self?.tableView.deselectRow(at: indexPath, animated: true)
//
//            let notification = self?.notifications[indexPath.row]
//            self?.presenter?.currentNoti = notification
//            self?.presenter?.selected(notification!)
//
//        }).disposed(by: disposeBag)
        
        //tableView.isEditing = true
//        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
        
//        self.tableView.rx.itemDeleted.subscribe(onNext: { (indexPath: IndexPath) in
//        }).disposed(by: disposeBag)
//
//        self.tableView.rx.modelDeleted(Notification.self).subscribe { (notification) in
//            Util.debugMsg(notification.element?.data.type)
//            self.presenter?.setNotification(dateTime: (notification.element?.data.preFormattedDate)!, action: .delete)
//            //self.presenter?.getAllNotification()
//        }.disposed(by: disposeBag)
//
//        presenter?.notificationArray.subscribe(onNext: { (notifications) in
//            Util.debugMsg(notifications)
//        })
        
        tableView.delegate = self
        tableView.dataSource = self
 
    }
    
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func localization() {
        self.navigationItem.title = "notifications".localized
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.presenter?.getAllNotification()
//        presenter?.notificationArray.subscribe(onNext: { (notis) in
//            Util.debugMsg(notis)
//        }).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)


        self.presenter?.getAllNotification() {[weak self] notifications in
            self?.notifications = notifications
            self?.tableView.reloadData()
            self?.presenter?.getNumOfUnreadNotification()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuBtnTapped(_ sender: UIBarButtonItem) {
        self.presenter?.menuClicked()
    }
    
    @IBAction func trashBtnTapped(_ sender: UIBarButtonItem) {
        self.presenter?.deleteAllNotifications()
    }

}



extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell else {
            fatalError()
        }
        let notification = notifications[indexPath.row]
        cell.updateCell(notification: notification)
        return cell
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = notifications[indexPath.row]
            let date = notification.data.preFormattedDate
            presenter?.setNotification(dateTime: date, action: .delete) {[weak self] notifications in
                self?.notifications = notifications
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        presenter?.currentNoti = notification
        presenter?.selected(notification)
//                    self?.presenter?.cellSelected(row: indexPath.row)
    }
}


