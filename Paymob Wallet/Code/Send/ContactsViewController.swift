//
//  ContactsViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/25/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class ContactsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var presenter: SendPresenter?
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try? Realm()
        if let contacts = realm?.objects(Contact.self) {
            Util.debugMsg(contacts.elements)
            var conts = [Contact]()
            for contcat in contacts {
                Util.debugMsg(contcat._name)
                conts.append(contcat)
            }
            self.presenter?.contactsArray.onNext(conts)
            self.collectionView.reloadData()
        }
        
        presenter?.contactsArray.subscribe(onNext: { (contacts) in
            Util.debugMsg(contacts)
        })
        
        self.collectionView.rx.modelSelected(Contact.self).subscribe (onNext: {(contact) in
            self.presenter?.currentContact.onNext(contact)
            //Util.debugMsg(contact)
        })
        self.collectionView.rx.itemSelected
        
        self.presenter?.contactsArray.bind(to: self.collectionView.rx.items(cellIdentifier: "contactsCell", cellType: ContactsCell.self)) {(row, contact, cell) in
            Util.debugMsg(contact)
            cell.name.text = contact._name
            cell.imageView.makeRound()
            }.disposed(by: disposeBag)
    }
    

}
