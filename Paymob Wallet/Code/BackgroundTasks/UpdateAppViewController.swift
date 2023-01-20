//
//  UpdateAppViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/14/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class UpdateAppViewController: UIViewController {
    @IBOutlet weak var updateAppDEscLb: PaymobUILabel!

    var presenter: BackTaskPresenter?
    @IBOutlet weak var updateBtn: PaymobUIButton!
    @IBOutlet weak var updateAppTitleLb: PaymobUILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        // Do any additional setup after loading the view.
    }

    func localization() {
        updateAppTitleLb.text = "updateAppTitle".localized
        updateAppDEscLb.text = "updateAppDescription".localized
        updateBtn.setTitle("updateBtn".localized, for: .normal)
    }
  
    @IBAction func updateAppTapped(_ sender: Any) {
        presenter?.goToAppStore()
    }

}
