//
//  MerchantsPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class MerchantsPresenter: Presenter {
    var router: MerchantsRouter?
    var localManager: MerchantsLocalManager?
    var fromPay: Bool?
    
    override init() {
        super.init()
        self.localManager = MerchantsLocalManager()
    }
    
    init(fromPay: Bool) {
        self.fromPay = fromPay
        self.localManager = MerchantsLocalManager()
    }
    
    func menuClicked() {
        self.router?.toogleDrawer()
    }
    
    func addClicked(vc: MerchantsViewController) {
        add(vc: vc)
    }
    
    func add(vc: MerchantsViewController) {
        let popup=UIAlertController(title: "addMerchant".localized , message:"enterMerchantDetails".localized , preferredStyle: UIAlertController.Style.alert)
        
        popup.addAction(UIAlertAction(title: "add".localized, style: UIAlertAction.Style.default,handler: { (thing) in
            //self.mers.append(mer)
            //self.tableView.reloadData()
            let name = popup.textFields?.first?.text
            let code = popup.textFields?.last?.text
            let merchant = Merchant()
            merchant._merchantName = name
            merchant._merchantCode = code
            
            self.localManager?.save(merchant: merchant)
            
            vc.merchants.onNext(self.merchants())
            
            
        }))
        popup.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: nil))
        
        popup.addTextField(configurationHandler: { (name) in
            name.placeholder="merchantName".localized
        })
        popup.addTextField { (code) in
            code.placeholder="merchantCode".localized
            code.keyboardType = .numberPad
        }
        vc.present(popup, animated: true, completion: nil)

    }
    
    func editClicked(merchant: Merchant, vc: MerchantsViewController) {
        let popup=UIAlertController(title: "updateMerchant".localized , message: "updateMerchantDetails".localized , preferredStyle: UIAlertController.Style.alert)
        
        popup.addAction(UIAlertAction(title: "update".localized, style: UIAlertAction.Style.default,handler: { (thing) in
            //self.mers.append(mer)
            //self.tableView.reloadData()
            let name = popup.textFields?.first?.text
            let code = popup.textFields?.last?.text
            
            
            self.localManager?.update(merchant: merchant, name: name!, code: code!)
            
            vc.merchants.onNext(self.merchants())
            
            
        }))
        popup.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: nil))
        
        popup.addTextField(configurationHandler: { (name) in
            name.placeholder="merchantName".localized
        })
        popup.addTextField { (code) in
            code.placeholder="merchantCode".localized
            code.keyboardType = .numberPad
        }
        vc.present(popup, animated: true, completion: nil)
        
    }
    
    func deleteClicked(merchant: Merchant, vc: MerchantsViewController, indexPath: IndexPath) {
        localManager?.delete(merchant: merchant)
        vc.merchants.onNext(self.merchants())
        //vc.tableView.deleteRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>)
    }
    
    func merchants() -> [Merchant] {
        return (localManager?.getMerchants())!
    }
}
