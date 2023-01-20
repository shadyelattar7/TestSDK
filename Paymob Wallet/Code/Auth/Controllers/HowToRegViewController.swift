//
//  HowToRegViewController.swift
//  Paymob Wallet
//
//  Created by mohamad ghonem on 26/07/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import Foundation
import UIKit

class HowToRegViewController: PayMobViewController{
    
    @IBOutlet weak var backgroundLowerView: UIView!
    var presenter: AuthPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyBoard(withPush: false)


        backgroundLowerView.layer.cornerRadius = 16.0
        backgroundLowerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
