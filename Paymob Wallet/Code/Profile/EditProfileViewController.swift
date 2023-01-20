//
//  EditProfileViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/7/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import ImagePicker

class EditProfileViewController: PayMobViewController {
    var presenter: ProfilePresenter?

    @IBOutlet weak var editiconImageView: UIImageView!
    let imagePicker = ImagePickerController()
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var rateAppLabel: UILabel!
    @IBOutlet weak var changePicLabel: UILabel!
    @IBOutlet weak var changePassowrdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var editiconImageView3: UIImageView!
    @IBOutlet weak var editIconImageView2: UIImageView!
    @IBOutlet weak var editIconImagView1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        presenter?.editNavigationTitleView(vc: self)
        
        if let mail = self.presenter?.email, !mail.isEmpty {
            self.emailLabel.text = self.presenter?.email
        } else {
            self.emailLabel.text = "-------"
        }
        self.localization()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.presenter!.localManager!.userExist {
            //self.userNameLabel.text = self.presenter?.localManager?.user?._name
            if presenter?.userManager.user?._name == "My Name" {
                userNameLabel.text = "myName".localized
            } else {
                userNameLabel.text = (presenter?.userManager.user?._name)!
            }
            self.mobileLabel.text = self.presenter?.localManager?.user?._mobile
        }
    }
    
    @IBAction func userNameTapped(_ sender: Any) {
        presenter?.editNameClicked()
    }
    
    
    @IBAction func changePassowrdTapped(_ sender: Any) {
        presenter?.resetPinClicked()
    }
    
    
    @IBAction func changeProfilePicTaapped(_ sender: Any) {
        presenter?.changePicClicked()
    }
    
    
    @IBAction func rateAppTapped(_ sender: Any) {
    }
    
    
    func localization() {
        changePassowrdLabel.text = "changePass".localized
        changePicLabel.text = "changePic".localized
        rateAppLabel.text = "rateApp".localized
        editiconImageView.image = ImageProvider.image(named: "backTitle".localized)
        editIconImagView1.image = ImageProvider.image(named: "backTitle".localized)
        editIconImageView2.image = ImageProvider.image(named: "backTitle".localized)
        editiconImageView3.image = ImageProvider.image(named: "backTitle".localized)
        
    }

//    @IBAction func dismissViewTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func saveTapped(_ sender: Any) {
//        if (presenter?.userManager.userExist)! {
//            presenter?.userManager.save(saveCall: { (user) in
//                if let newImage = image {
//                    let imageData = UIImageJPEGRepresentation(newImage, 0.9)
//                    user._image = imageData
//                }
//
//                if (self.newUserNameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
//
//                } else {
//                    user._name = self.newUserNameTxt.text!
//                }
//
//            })
//        }
//        self.navigationController?.popViewController(animated: true)
//    }

//    @IBAction func selctImageTapped(_ sender: Any) {
//        self.present(imagePicker, animated: true, completion: nil) // <-------- eh el garema dehhhh
//        print("Tapped")
//    }
//
}
