//
//  MerchantsViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MerchantsViewController: UIViewController, UITableViewDelegate {

    var presenter: MerchantsPresenter?
    @IBOutlet weak var tableView: UITableView!
    var merchants = BehaviorSubject<[Merchant]>(value: [])
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        merchants.onNext((presenter?.merchants())!)
        
        merchants.bind(to: tableView.rx.items(cellIdentifier: "merchantCell")) { (row, merchant, cell) in
            cell.textLabel?.text = merchant._merchantName
            cell.detailTextLabel?.text = merchant._merchantCode
        }.disposed(by: disposeBag)
        

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Merchant.self).subscribe(onNext: { (merchant) in
            //self.presenter?.selectedMerchant?.onNext(merchant)
            Util.debugMsg(merchant)
            let merc = Merchant()
            merc._merchantCode = merchant._merchantCode
            merc._merchantName = merchant._merchantName
            UserDefaults.standard.setValue(merc._merchantCode, forKey: "Merchant")
            UserDefaults.standard.setValue(merc._merchantName, forKey: "MerchantName")
            UserDefaults.standard.synchronize()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        if presenter?.fromPay == true {
            let button = UIButton(type: .system)
            button.setImage(ImageProvider.image(named: "X"), for: .normal)
            //button.setTitle("YourTitle", for: .normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(self.action), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageProvider.image(named: "X"), style: .plain, target: self, action: #selector(self.action))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        }
        
    }
    
    
    func localization() {
        self.navigationItem.title = "merchant".localized
    }
    
    @objc func action() {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete".localized) { (deleteAction, indexPath) in
            let merchants = self.presenter?.merchants()
            self.presenter?.deleteClicked(merchant: (merchants?[indexPath.row])!, vc: self, indexPath: indexPath)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit".localized) { (editAction, indexPath) in
            let merchants = self.presenter?.merchants()
            self.presenter?.editClicked(merchant: (merchants?[indexPath.row])!, vc: self)
        }
        
        return [deleteAction, editAction]
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        self.presenter?.menuClicked()
    }
        
    
    @IBAction func addTapped(_ sender: Any) {
        self.presenter?.add(vc: self)
    }
}
