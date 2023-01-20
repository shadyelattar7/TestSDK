//
//  MainController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 1/9/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    var presenter: RegPresenter?

    @IBOutlet weak var registerBtn: PaymobUIButton!
    @IBOutlet weak var loginBtn: PaymobUIButton!
    @IBOutlet weak var sigInImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sigInImageView.image = ImageProvider.image(named: "signInLogo".localized)
        loginBtn.setTitle("login".localized, for: .normal)
        registerBtn.setTitle("register".localized, for: .normal)

    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        presenter?.loginBtnTapped()
    }
    
    @IBAction func regBtnTapped(_ sender: Any) {
        Util.debugMsg("Tappppppped")
        presenter?.selfRegTapped()
    }
    
    
}
