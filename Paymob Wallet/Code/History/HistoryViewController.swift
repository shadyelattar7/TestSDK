//
//  HistoryViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/10/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit


import UIKit
var segmentIndex = 0

class HistoryViewController: PayMobViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var upperBlueContainer: UIView!
    var presenter: HistoryPresenter?
    @IBOutlet weak var historyTableContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var exportBtn: UIButton!
    var newHistory = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        presenter?.embeddHistoryTableView(into: self, container: historyTableContainer)
        presenter?.addBarButtons(vc: self)
        
        self.presenter?.historyArray.subscribe { (_) in
            self.activityIndicator.isHidden = true
            self.historyTableContainer.isHidden = false
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func localization() {
        self.navigationItem.title = "history".localized
        self.segmentControl.setTitle("all".localized, forSegmentAt: 0)
        self.segmentControl.setTitle("recieved".localized, forSegmentAt: 1)
        self.segmentControl.setTitle("sent".localized, forSegmentAt: 2)
        self.segmentControl.setTitle("pending".localized, forSegmentAt: 3)
        self.exportBtn.setTitle("export".localized, for: .normal)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        presenter?.menuClicked()
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        segmentIndex = self.segmentControl.selectedSegmentIndex
        self.presenter?.allHistoryArray.subscribe { (histories) in
            self.newHistory = (self.presenter?.getForSection(sec: self.segmentControl.selectedSegmentIndex, txns: (histories.element)!))!
        }.disposed(by: disposeBag)
        self.presenter?.historyArray.onNext(newHistory)
    }
    
    @IBAction func exportPdfAction(_ sender: Any) {
        presenter?.showExpoertView()
    }
    
}
