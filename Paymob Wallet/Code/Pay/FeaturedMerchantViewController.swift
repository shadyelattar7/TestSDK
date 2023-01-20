//
//  FeaturedMerchantViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 11/4/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class FeaturedMerchantViewController: PayMobViewController {

    @IBOutlet var collectionView: UICollectionView!
    //var disposeBag = DisposeBag()

    var presenter: PayPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getFeatMerchants()
        self.presenter?.featMerchants.bind(to: self.collectionView.rx.items(cellIdentifier: "featMerchant", cellType: FeatMerCollectionViewCell.self)) {(row, featMer, cell) in
            cell.merName.text = featMer.merName
            cell.merImage.sd_setImage(with: URL(string: self.settings.imageBase+featMer.imageUrl), placeholderImage: ImageProvider.image(named: "man.png") , options: [], completed: nil)
            Util.debugMsg(self.settings.imageBase+featMer.imageUrl)
            cell.merImage.makeRound()
            }.disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(FeatMerchant.self).subscribe { (fMer) in
            let merCode = fMer.element?.merCode
            let merName = fMer.element?.merName
            self.presenter?.featMerCodeObserver.onNext(merCode!)
            self.presenter?.merNameObserver.onNext(merName!)
            //let merchant = Merchant()
            //merchant._merchantName = fMer.element?.merName
            //merchant._merchantCode = fMer.element?.merCode
            //self.presenter?.merObjectObserver?.onNext(merchant)
            Util.debugMsg("Tapped")
        }.disposed(by: disposeBag)
        self.collectionView.rx.itemSelected
            //Util.debugMsg(contact)
    }

}
