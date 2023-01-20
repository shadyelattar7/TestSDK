//
//  CashInOutViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 7/19/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class CashInOutViewController: PayMobViewController {
    
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var upperBlue: UIView!

    @IBOutlet weak var infoBtn: PaymobUIButton!
    @IBOutlet weak var otpBtn: PaymobUIButton!
    var presenter: LoadPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBtn.imageView?.contentMode = .scaleAspectFit
        self.keyBoard(withPush:false)
        presenter?.addBarButtons(vc: self)
        self.navigationItem.title = "load".localized
        loadLabel.text = "avl".localized
        otpLabel.text = "cashout".localized
        infoLabel.text = "infoMaps".localized
        loadBtn.imageView?.contentMode = .scaleAspectFit
        infoBtn.imageView?.contentMode = .scaleAspectFit
        otpBtn.imageView?.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    

    @IBAction func loadTapped(_ sender: Any) {
        presenter?.loadTapped()
    }
    
    
    @IBAction func otpTapped(_ sender: Any) {
        presenter?.cashoutTapped()
    }
    
    
    @IBAction func infoTapped(_ sender: Any) {
        presenter?.mapInfoTapped()
    }
}
