//
//  UpperBlueViewController.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 9/18/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UpperBlueViewController: PayMobViewController {
    
    var presenter:UpperViewPresenter?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var egpTxt: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.presenter?.balanceObserver.bind(to: self.amount.rx.text).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (presenter?.userManager.userExist)! {
            self.amount.text = "\(presenter?.userManager.user?._balance ?? "0.0") \("egp".localized)"
        }
    }
    
    func localization() {
        userName.text = "walletBalance".localized
        egpTxt.text = "egp".localized
    }

}
