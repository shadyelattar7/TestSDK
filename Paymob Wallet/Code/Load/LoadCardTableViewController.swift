//
//  LoadCardTableViewController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/10/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadCardTableController: PayMobViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter:LoadPresenter?
    
    @IBOutlet weak var cardsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.presenter?.creditCardsObservable.bind(to: self.cardsTable.rx.items(cellIdentifier: "loadCardCell", cellType: UITableViewCell.self))
//        {(row, card, cell) in
//            cell.textLabel?.text = card.bankAlias1
//            //cell.imageView?.image = UIImage(named: "mastercard1")
//        }.disposed(by: disposeBag)
//        
//        self.cardsTable.rx.itemSelected.subscribe(onNext:{ (index) in
//            self.presenter?.cardClicked(at: index)
//        
//        }).disposed(by:disposeBag)
        
        collectionView.delegate = self
        presenter?.getCreditCards()
        self.presenter?.creditCardsObservable.bind(to: self.collectionView.rx.items(cellIdentifier: "cell", cellType: LoadCell.self))
        {(row, card, cell) in
            //cell.textLabel?.text = card.bankAlias1
            cell.cardTitle.text = card.bankAlias1
            //cell.imageView?.image = UIImage(named: "mastercard1")
            }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.subscribe(onNext:{ (index) in
            self.presenter?.cardClicked(at: index)
            
        }).disposed(by:disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: 152)
    }
    
}
