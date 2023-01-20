//
//  TutorialController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/14/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class TutorialController: UIViewController {

    @IBOutlet weak var skipBtn: UIButton!
    var index: Int!
    var text = ""
    var isSkipBtnHidden = true
    var color = UIColor.white
    var presenter: IntroPresenter?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = color
        print(text)
        self.skipBtn.isHidden = true
        if isSkipBtnHidden {
            self.skipBtn.isHidden = true
        } else {
            self.skipBtn.isHidden = false
        }
    }
    
    
    @IBAction func skipTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "firstTime")
        _ = RegRouter()
    }
    
}
