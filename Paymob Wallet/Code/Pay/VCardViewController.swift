//
//  VCardViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/19/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit

class VCardViewController: PayMobViewController {
    var presenter:PayPresenter?
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
//    @IBOutlet weak var validUntilLabel: UILabel!
    @IBOutlet weak var amountTitleLb: UILabel!
    @IBOutlet weak var rseedyLabel: UILabel!
    @IBOutlet weak var vcnCardImageView: UIImageView!
    @IBOutlet weak var cardMessageLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var electronicUseOnlyLb: UILabel!
    //@IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var multiUseIcon: UIImageView!
    @IBOutlet weak var disclaimer: UILabel!
    
    
    //MARK: - New Desgin Outlet
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var cardNumLB: UILabel!
    @IBOutlet weak var cardNumValueLb: UILabel!
    @IBOutlet weak var expireDateLb: UILabel!
    @IBOutlet weak var expireDateValueLb: UILabel!
    @IBOutlet weak var cvvLb: UILabel!
    @IBOutlet weak var cvvValueLb: UILabel!
    @IBOutlet weak var amountStack: UIStackView!
    @IBOutlet weak var cardStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.presenter?.addBarButtons(vc: self)
        
        // MARK: - Hide old design
        amountStack.isHidden = true
        cardStack.isHidden = true
        
        self.presenter?.currentCardObservable.subscribe(onNext: { (vCard) in
            self.amountLabel.text = "egp".localized+" "+(vCard.amount ?? "0.0")
            self.numberLabel.text = vCard.number!
            self.expireLabel.text = vCard.expireDay!
            self.expireLabel.text?.insert("/", at: vCard.expireDay!.index(vCard.expireDay!.startIndex, offsetBy: 2))
            self.cvvLabel.text = vCard.cvv!
            
            
            //MARK: - New Design fill data
            
            self.cardNumValueLb.text = vCard.number!
            self.expireDateValueLb.text = vCard.expireDay!
            self.expireDateValueLb.text?.insert("/", at: vCard.expireDay!.index(vCard.expireDay!.startIndex, offsetBy: 2))
            self.cvvValueLb.text = vCard.cvv!
            
            
            
//            self.validUntilLabel.text = NSLocalizedString("validUntil", comment: "Valid Until") + vCard.validityDate!
//            self.multiUseIcon.isHidden = !vCard.isMultiUse
            self.multiUseIcon.isHidden = true
            
            //for audi
            /*
            let localManager = AuthLocalManager()
            if localManager.userExist {
               self.userNameLb.text = localManager.user?._name
            }
 */
        }).disposed(by: disposeBag)

    }
    
    func localization() {
        self.navigationItem.title = "card".localized
        self.amountTitleLb.text = "amount".localized
        self.electronicUseOnlyLb.text = "electronicUseOnly".localized
        self.disclaimer.text = "disclaimer".localized
        
        
        //MARK: - New design view
        self.titleLb.text = "Card details".localized
        self.cardNumLB.text = "Card number".localized
        self.expireDateLb.text = "Expire date".localized
        self.cvvLb.text = "CVV".localized
        
        self.view.semanticContentAttribute = .forceLeftToRight
    }
}
