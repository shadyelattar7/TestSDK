//
//  DetailHistoryViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/11/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class DetailHistoryViewController: PayMobViewController {
    
    var presenter: HistoryPresenter?

    
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var dateValueLb: UILabel!
    @IBOutlet weak var typeLb: UILabel!
    @IBOutlet weak var typeValueLb: UILabel!
    @IBOutlet weak var transLb: UILabel!
    @IBOutlet weak var transValueLb: UILabel!
    @IBOutlet weak var participantLb: UILabel!
    @IBOutlet weak var participantValueLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var amountValueLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var statusValueLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.presenter?.currentHistory.subscribe(onNext: { (history) in
            self.dateValueLb.text = history.time
            self.typeValueLb.text = history.type
            self.transValueLb.text = history.txnId
            self.participantValueLb.text = history.fromTo
            self.amountValueLb.text = "\(history.amount)"
            self.statusValueLb.text = history.status
        }).disposed(by: disposeBag)
        presenter?.addBarButtons(vc: self)
        
    }
    
    func localization() {
        dateLb.text = "date".localized
        typeLb.text = "type".localized
        transLb.text = "transaction".localized
        participantLb.text = "participant".localized
        amountLb.text = "amount".localized
        statusLb.text = "status".localized
    }
}
