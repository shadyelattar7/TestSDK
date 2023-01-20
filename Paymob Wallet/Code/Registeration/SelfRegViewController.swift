//
//  SelfRegViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 1/11/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class TitleCustomView: UIView {
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

class SelfRegViewController: PayMobViewController {

    var presenter: RegPresenter?
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var middleNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var nationalIdTxt: UITextField!
    
    @IBOutlet weak var loginBtn: PaymobUIButton!
    
    @IBOutlet weak var registerBtn: PaymobUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        presenter?.editNavigationTitleView(vc: self)
        loginBtn.setTitle("login".localized, for: .normal)
        registerBtn.setTitle("register".localized, for: .normal)
        firstNameTxt.placeholder = "firstName".localized
        middleNameTxt.placeholder = "middleName".localized
        lastNameTxt.placeholder = "lastName".localized
        nationalIdTxt.placeholder = "nationalId".localized
        
    }
    
    
    

    @IBAction func registerTapped(_ sender: Any) {
        
        guard !(firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!, !(middleNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!, !(lastNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!, !(nationalIdTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! else {
            self.presenter?.emptyFieldsError()
            return
        }
        
        presenter?.firstName = firstNameTxt.text!
        presenter?.middleName = middleNameTxt.text!
        presenter?.lastName = lastNameTxt.text!
        presenter?.nationalID = nationalIdTxt.text!
        
        presenter?.goToFinalRegController()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        presenter?.loginBtnTapped()
    }
    
}
