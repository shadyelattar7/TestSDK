//
//  TipsViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 11/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = "tips".localized
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
