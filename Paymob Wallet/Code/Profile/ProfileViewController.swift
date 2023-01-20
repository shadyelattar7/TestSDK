//
//  ProfileViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/7/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: PayMobViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var presenter: ProfilePresenter?
    
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editBtn: PaymobUIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var nationalIdLAbel: UILabel!
    @IBOutlet weak var unregisterBtn: UIButton!

    @IBOutlet weak var nationalIdTitleLb: UILabel!
    @IBOutlet weak var dateOfBirthTitleLb: UILabel!
    @IBOutlet weak var genderTitleLb: UILabel!
    @IBOutlet weak var addressTitleLb: UILabel!
    @IBOutlet weak var mailTitleLb: UILabel!
    @IBOutlet weak var personnelInfoTitleLb: UILabel!
    
    @IBOutlet weak var changePinBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.localization()
        if EntryPoint.langId == "en"{
            editBtn.semanticContentAttribute = .forceRightToLeft
        }else{
            editBtn.semanticContentAttribute = .forceLeftToRight
        }
//        logOutBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        presenter?.addBarButtons(vc: self)
        presenter?.editNavigationTitleView(vc: self)
        presenter?.profileDetail()
        scrollView.isHidden = true
        activityIndicator.isHidden = false
        presenter?.profileDataDownloaded.subscribe(onNext: { (completed) in
            if completed {
                self.activityIndicator.isHidden = true
                self.scrollView.isHidden = false
                if self.presenter!.localManager!.userExist {
                    //self.userNameLb.text = self.presenter?.localManager?.user?._name
                    if self.presenter?.userManager.user?._name == "My Name" {
                        self.userNameLb.text = "myName".localized
                    } else {
                        self.userNameLb.text = (self.presenter?.userManager.user?._name)!
                    }
                }
                
                if let nationalId = self.presenter?.nationalId, !nationalId.isEmpty {
                    self.nationalIdLAbel.text = self.presenter?.nationalId
                } else {
                    self.nationalIdLAbel.text = "-------"
                }
                
                if let birth = self.presenter?.dateOfBirth, !birth.isEmpty {
                    self.birthDateLabel.text = self.presenter?.dateOfBirth
                } else {
                    self.birthDateLabel.text = "-------"
                }
                
                if let gender = self.presenter?.gender, !gender.isEmpty {
                    self.genderLabel.text = self.presenter?.gender
                    if gender == "Male" {
                        self.genderLabel.text = "male".localized
                    }
                    if gender == "Female" {
                        self.genderLabel.text = "female".localized
                    }
                } else {
                    self.genderLabel.text = "-------"
                }
                
                if let address = self.presenter?.address, !address.isEmpty {
                    self.addressLabel.text = self.presenter?.address
                } else {
                    self.addressLabel.text = "-------"
                }
                
                if let mail = self.presenter?.email, !mail.isEmpty {
                    self.emailLabel.text = self.presenter?.email
                } else {
                    self.emailLabel.text = "-------"
                }
                
                if let _ = self.presenter?.localManager?.userExist {
                    self.mobileLabel.text = self.presenter?.localManager?.user?._mobile
                }
                
                if let _ = self.presenter?.localManager?.userExist {
//                    self.balanceLabel.text = self.presenter?.localManager?.user?._balance
                }
                self.presenter?.profileDataDownloaded = BehaviorSubject<Bool>(value: false)
            }
        }).disposed(by: disposeBag)
        
        
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        presenter?.changePicClicked()
    }
    
    @IBAction func editPinTapped(_ sender: Any) {
        presenter?.resetPinClicked()
    }
    
    
    func localization() {
        personnelInfoTitleLb.text = "profilePersonnelInfo".localized
        nationalIdTitleLb.text = "profileNationalID".localized
        addressTitleLb.text = "profileAddress".localized
        dateOfBirthTitleLb.text = "profileDOB".localized
        genderTitleLb.text = "profileGender".localized
        mailTitleLb.text = "profileMail".localized

        changePinBtn.setTitle("profilePin".localized, for: .normal)

        editBtn.setTitle("ProfileEdit".localized, for: .normal)
        unregisterBtn.setTitle("unregister".localized, for: .normal)
        logOutBtn.setTitle("ProfileLogOut".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)

        if let imageData = presenter?.localManager?.user?._image {
            userImage.image = UIImage(data: imageData)
            
        }
        userImage.layer.cornerRadius = userImage.frame.height/2
//        userImage.layer.borderColor = UIColor.white.cgColor
//        userImage.layer.borderWidth = 10
        userImage.layer.masksToBounds = true
        
//        let path = UIBezierPath(roundedRect:viewImageContainer.bounds,
//                                byRoundingCorners:[.topRight, .topLeft],
//                                cornerRadii: CGSize(width: 15, height:  15))
//        viewImageContainer.layer.masksToBounds = true
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        viewImageContainer.layer.mask = maskLayer
        
        if self.presenter!.localManager!.userExist {
            //self.userNameLb.text = self.presenter?.localManager?.user?._name
            if self.presenter?.userManager.user?._name == "My Name" {
                self.userNameLb.text = "myName".localized
            } else {
                self.userNameLb.text = (self.presenter?.userManager.user?._name)!
            }
        }
    }
    
    @IBAction func unregisterTapped(_ sender: UIButton) {
                presenter?.unregisterClicked()
            }

    @IBAction func logOutTapped(_ sender: Any) {
        self.presenter?.logOutAction()
    }
}
