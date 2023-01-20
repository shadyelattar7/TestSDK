//
//  ProfilePresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/7/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation
import RxSwift

class ProfilePresenter: Presenter {
    
    var router: ProfileRouter?
    var localManager: AuthLocalManager?
    var apiManager: AuthApiManager?
    var disposeBag = DisposeBag()
    var updatedBalance = BehaviorSubject<String>(value: "")
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    
    var fullName: String?
    var email: String?
    var gender: String?
    var address: String?
    var nationalId: String?
    var dateOfBirth: String?
    
    var profileDataDownloaded = BehaviorSubject<Bool>(value: false)
    
    override init() {
        super.init()
        self.localManager = AuthLocalManager()
        self.apiManager = AuthApiManager()
    }
    
    func editClicked() {
        router?.goToEditController()
    }
    
    func editNameClicked() {
        router?.goToChangeNameController()
    }
    
    func resetPinClicked() {
        router?.goToResetMPin()
    }
    
    func changePicClicked() {
        router?.goToChangePicture()
    }
    
    
    func profileDetail() {
        guard self.localManager!.userExist else {
            return
        }
        guard let userMobile = self.localManager?.user?._mobile else {
            return
        }
        self.apiManager?.profileDetails(mobile: userMobile).subscribe(onNext: { (response) in
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            
            self.fullName = response.userName
            self.gender = response.userGender
            self.address = response.userAddress
            self.email = response.userMail
            self.dateOfBirth = response.userDateOfBirth
            self.nationalId = response.userNationalId
            self.profileDataDownloaded.onNext(true)
        }, onError: { (error) in
//            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    self.logoCliked()
                })
//            }
        }).disposed(by: disposeBag)
        
    }
    
    
    
    func editNavigationTitleView(vc: UIViewController) {
        let titleCustomView = TitleCustomView(frame: CGRect(x: 0, y: 0, width: 60, height: (vc.navigationController?.navigationBar.frame.height)!))
        
        let stackView = UIStackView()
//        stackView.backgroundColor = settings.primaryColor
        titleCustomView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.leadingAnchor.constraint(equalTo: titleCustomView.leadingAnchor, constant: 35).isActive = true
        stackView.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        stackView.centerXAnchor.constraint(equalTo: titleCustomView.centerXAnchor).isActive = true
        let titleLabel = UILabel()
        titleLabel.text = "profile".localized
        titleLabel.textColor = UIColor.AppColor.mainText
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_menu"))
//        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(titleLabel)
//        stackView.addArrangedSubview(imageView)
        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.heightAnchor.constraint(equalToConstant: (vc.navigationController?.navigationBar.frame.height)!).isActive = true
//
//        imageView.widthAnchor.constraint(equalToConstant: (vc.navigationController?.navigationBar.frame.height)!).isActive = true
//        imageView.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        
//        titleCustomView.backgroundColor = settings.primaryColor
        
        vc.navigationItem.titleView = titleCustomView
        
    }
    
    @objc func menuClicked()  {
        self.router?.toogleDrawer()
    }
    
    @objc func notificationClicked() {
        NavigationPresenter.currentModule = "Notifications"
        goToNotifications()
    }
    
    @objc func logoCliked() {
        NavigationPresenter.currentModule = "Dashboard"
        goToDashboard()
    }
    
    @objc func goToPreviousVC(){
        self.router?.profileNav?.popViewController(animated: true)
    }
    
    func addBarButtons(vc: UIViewController) {
        /*
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(ProfilePresenter.notificationClicked), for: .touchUpInside)
        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        
        if (userManager.userExist) {
            //            notificationBarBtn.setBadge(text: userManager.user?._noOfUnreadNoti)
                        
                        numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
                            notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
                        }).disposed(by: disposeBag)
                        
            numOfUnreadNoti.onNext( Int(userManager.user?._noOfUnreadNoti ?? "0") ?? 0 )
                }
        
        vc.navigationItem.rightBarButtonItems = [notificationBarBtn]
        */
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if ("\(vc.classForCoder)" == "ProfileViewController"){
            backBtn.addTarget(self, action: #selector(ProfilePresenter.logoCliked), for: .touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(ProfilePresenter.goToPreviousVC), for: .touchUpInside)
        }
//        backBtn.addTarget(self, action: #selector(ProfilePresenter.logoCliked), for: .touchUpInside)
        backBtn.setImage(ImageProvider.image(named: "back"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.flipImage()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.leftBarButtonItems = [backBarBtn]
    }
    func getNumOfUnreadNotification() {
        self.apiManager?.getNumOfUnreadNotification(mobile: (userManager.user?._mobile)!).subscribe(onNext: { (response) in
            //self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            //self.router?.hideMsg {
            guard response.txn == "200" else {
                self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                })
                return
            }
            self.localManager?.save(saveCall: { (user) in
                user._noOfUnreadNoti = "\(response.numberOfUnreadNoti)"
            })
            self.numOfUnreadNoti.onNext(response.numberOfUnreadNoti)
            UIApplication.shared.applicationIconBadgeNumber = response.numberOfUnreadNoti
            //}
            
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: disposeBag)
    }
    
    
    func resetMpin(pin: String, newPin: String, confPin: String) {
        self.router?.displayAlert(msg: "loading".localized)
        if (localManager?.userExist)! {
            
            self.apiManager?.resetMPin(pin: pin, newPin: newPin, confPin: confPin, mobile: (localManager?.user?._mobile)!).subscribe(onNext: { (response) in
                self.router?.hideMsg {
                    guard response.txn == "200" else {
                        self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                        })
                        return
                    }
                    self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                        NavigationPresenter.currentModule = "Dashboard"
                        self.router?.closeModal()
                        self.router?.goToDashboard()
                    })
                }
            }, onError: { (error) in
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }).disposed(by: disposeBag)
        }
    }
    func unregisterClicked(){
        router?.goToUnregisterController()
    }
    
    func logOutAction(){
        router?.goToLogout()
    }
}
