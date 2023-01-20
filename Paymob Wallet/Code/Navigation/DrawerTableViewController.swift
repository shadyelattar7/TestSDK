//
//  DrawerTableViewController.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/6/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import DrawerController
import RxSwift

class DrawerTableViewController: UITableViewController {
    
    var leftDrawerItems:[[(String,String,String)]] = []
    var presenter: NavigationPresenter?
    var disposeBag = DisposeBag()
    var isLogoInDrawer: Bool? = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //isLogoInDrawer = self.presenter?.settings.get(key: "isLogoInDrawer") as! Bool
        //self.view.backgroundColor = Settings.getStettings().primaryColor
        /// for abk
        self.view.backgroundColor = UIColor(red: 112/255, green: 111/255, blue: 111/255, alpha: 1)
        //self.tableView.backgroundView = UIImageView(image: UIImage(named: "ic_drawer_background"))
        
        //  Section #0
        leftDrawerItems.append([("dashboard".localized,
                                 "DashboardController","upperAppIcon-1.png"),
                                ("dashboard".localized,
                                 "DashboardController","upperAppIcon-1.png"),
                                ("p2p".localized,
                                 "SendController","Peer_to_Peer_White.png")])
        //  Section #1
        leftDrawerItems.append( [("bills".localized,
                                  "SendController","Bill_Payments_White.png"),
                                 ("topUp".localized,"topUpController","topUp-1.png"),
                                 ("qrCode".localized,"PayController","QR_Code_White.png"),
                                 ("myWallet".localized,
                                  "LoadController","My_Wallet_White.png"),
                                 ("eCommere".localized,"PayViewController","eCom.png"),
                                 ("map".localized,"MapController","ic_map_dashboard")])
        //  Section #2
        
//        leftDrawerItems.append(
//            [(NSLocalizedString("profile", comment: "profile"),"ProfileController","ic_profile.png"),(NSLocalizedString("notifications", comment: "notifications"), "NotificationsController","ic_notifications.png"),(NSLocalizedString("merchant", comment: "merchants"),"MerchantTableViewController","ic_pay.png"),(NSLocalizedString("history", comment: "history"),"HistoryController","ic_history.png"),("offers","OffersController","euro")])
        
        leftDrawerItems.append(
            [("profile".localized,
              "ProfileController","profile_menu.png"),
             ("history".localized,
              "HistoryController","ic_history.png"),
             ("Service Info".localized,
              "HistoryController","ic_info")])
 
        //  Section #3
        leftDrawerItems.append(
            [("contactUs".localized,
              "SettingsController","ic_contactUs.png"),
             ("logout".localized,
              "LoginController","ic_logout.png")])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter?.getNumOfUnreadNotification()
        if self.presenter!.localManager!.userExist {
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if (isLogoInDrawer)!
            { return 3 }
            else
            { return 2 }
        case 1:
            //return 5
            // for audi 
            return 5
        case 2:
            return 3
        case 3:
            return 2
            
        default:
            return 0
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLogoInDrawer! {
            if indexPath.section == 0 && indexPath.item == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "logoDrawerCell", for: indexPath) as? DrawerCell {
                    if presenter!.localManager!.userExist {
                        cell.userNameLabel.text = presenter?.localManager?.user?._name
                        if let imageData = presenter?.localManager?.user?._image {
                            cell.userImageView.image = UIImage(data: imageData)
                        }
                    }
                    cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width/2
                    cell.userImageView.layer.masksToBounds = true
                    cell.userImageView.layer.borderWidth = 10
                    cell.userImageView.layer.borderColor = UIColor.white.cgColor
                    return cell
                }
            } else {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as? DrawerCell {
                    cell.titleLb.text = leftDrawerItems[indexPath.section][indexPath.item].0
                    cell.icon.image = ImageProvider.image(named: leftDrawerItems[indexPath.section][indexPath.item].2)
                    cell.cellIdentifier = leftDrawerItems[indexPath.section][indexPath.item].0
                    cell.noteNo.makeRound()
                    cell.noteNo.isHidden = true
                    self.presenter?.numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                        cell.noteNo.text = "\(numberOfUnreadNoti)"
                        Util.debugMsg(numberOfUnreadNoti)
                        if numberOfUnreadNoti == 0 {
                            cell.noteNo.isHidden = true
                        } else {
                            //cell.noteNo.isHidden = false
                            if cell.cellIdentifier == "notifications".localized {
                                cell.noteNo.isHidden = false
                            } else {
                                cell.noteNo.isHidden = true
                            }
                        }
                        /*
                        if cell.cellIdentifier == NSLocalizedString("notifications", comment: "notifications") {
                            cell.noteNo.isHidden = false
                        } else {
                            cell.noteNo.isHidden = true
                        }*/
                       
                        
                        
                    }).disposed(by: disposeBag)
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as? DrawerCell {
                cell.titleLb.text = leftDrawerItems[indexPath.section][indexPath.item].0
                cell.icon.image = ImageProvider.image(named: leftDrawerItems[indexPath.section][indexPath.item].2)
                cell.cellIdentifier = leftDrawerItems[indexPath.section][indexPath.item].0
                cell.noteNo.makeRound()
                cell.noteNo.isHidden = true
                self.presenter?.numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                    cell.noteNo.text = "\(numberOfUnreadNoti)"
                    if numberOfUnreadNoti == 0 {
                        cell.noteNo.isHidden = true
                    } else {
                        //cell.noteNo.isHidden = false
                        if cell.cellIdentifier == "notifications".localized {
                            cell.noteNo.isHidden = false
                        } else {
                            cell.noteNo.isHidden = true
                        }
                    }
                    
                }).disposed(by: disposeBag)
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath) as? DrawerCell
        presenter?.newModule = cell?.cellIdentifier
        presenter?.cellSelected()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isLogoInDrawer)!
        {
            if (indexPath.section == 0 && indexPath.item == 0) {
                return 150;
            }else{
                return 55;
            }
        }else{
            
            return 55;
        }
        
    }
    
}
