//
//  LoadViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoadController: PayMobViewController {

    var presenter:LoadPresenter?
    var LoadDisposeBag = DisposeBag()
    
    @IBOutlet weak var upperBlue: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var youCanCashInLb: PaymobUILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardName: PaymobUILabel!
    @IBOutlet weak var loadAmount: PaymobUITextField!
    
    @IBOutlet weak var cashInBrn: PaymobUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.keyBoard(withPush:false)
        //presenter?.addBarButtons(vc: self)
        self.presenter?.activityObservable.bind(to: activityIndicator.rx.isHidden).disposed(by: LoadDisposeBag)
        self.presenter?.loadViewObservable.bind(to: cardView.rx.isHidden).disposed(by: LoadDisposeBag)
        self.presenter?.cardNameObservable.bind(to: self.cardName.rx.text).disposed(by: LoadDisposeBag)
        navigationItem.title = "avl".localized
    }
    
    func localization() {
        self.navigationItem.title = "load".localized
        youCanCashInLb.text = "youCanCashIn".localized
        loadAmount.placeholder = "amount".localized
        cashInBrn.setTitle("cashIn".localized, for: .normal)
    }

    @IBAction func cashInClicked(_ sender: Any) {
        self.presenter?.loadAmount(amount: self.loadAmount.text!)
    }
  
    @IBAction func closeCashInViewClicked(_ sender: Any) {
        self.presenter?.closeLoadViewClicked()
    }
    
    
}
