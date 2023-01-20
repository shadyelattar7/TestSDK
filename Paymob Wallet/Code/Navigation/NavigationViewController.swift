//
//  DashboardViewController.swift
//  WalletsPaymob
//
//  Created by mahmoud gamal on 8/17/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import DrawerController
import RxSwift
import RxCocoa


class NavigationViewController: PayMobViewController {
    var presenter: NavigationPresenter?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var historyShowAllButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var installementsBtn: UIButton!
    @IBOutlet weak var billBtn: UIButton!
    @IBOutlet weak var mobileAndInternetBtn: UIButton!
    @IBOutlet weak var shoppingCardsBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        self.getAllHistory()
        
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notificationBtn.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        
        notificationBtn.setImage(ImageProvider.image(named: "horn-white-25"), for: .normal)
        
    
        
        notificationBtn.backgroundColor = UIColor.clear
        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
        navigationItem.rightBarButtonItems = [notificationBarBtn]
        
        let profileBtn = UIButton(type: .custom)
//        profileBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileBtn.addTarget(self, action: #selector(profTapped), for: .touchUpInside)
        
        
        
        profileBtn.setImage(ImageProvider.image(named: "homeProfile"), for: .normal)
        profileBtn.setTitle(presenter?.localManager?.user?._name, for: .normal)
        profileBtn.setTitleColor(.black, for: .normal)
        profileBtn.backgroundColor = UIColor.clear
        let profileBarBtn = UIBarButtonItem(customView: profileBtn)

        navigationItem.leftBarButtonItems = [profileBarBtn]
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        presenter?.editNavigationTitleView(vc: self)
        
//        if presenter!.localManager!.userExist {
//            amountLb.text = presenter?.localManager?.user?._balance
//            userName.text = presenter?.localManager?.user?._name
//            if let imageData = presenter?.localManager?.user?._image {
//                userImageView.image = UIImage(data: imageData)
//            }
//        }
 
        self.presenter?.numOfUnreadNoti.subscribe(onNext: { (numberOfUnreadNoti) in
            notificationBarBtn.setBadge(text: "\(numberOfUnreadNoti)")
//            self.notificationNumberLb.text = "\(numberOfUnreadNoti)"
//            if numberOfUnreadNoti == 0{
//                self.notificationNumberLb.isHidden = true
//            } else {
//                self.notificationNumberLb.isHidden = false
//            }
        }).disposed(by: disposeBag)
        
        presenter?.updatedBalance.subscribe(onNext: { (_) in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.historyTableView.layoutIfNeeded()
        self.historyTableView.rx.observe(CGSize.self, "contentSize")
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (size) in
                guard let self = self else {return}
                if let size = size, size.height > CGFloat(0){
                    self.tableHeight.constant = size.height
                }
            }).disposed(by: disposeBag)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)
        //presenter?.newModule = "Dashboard"
        self.presenter?.getNumOfUnreadNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func localization(){
        servicesLabel.text = "HalanServices".localized
        historyLabel.text = "homePastTransactions".localized
        historyShowAllButton.setTitle("showAll".localized, for: .normal)
        installementsBtn.setTitle("homeInstallements".localized, for: .normal)
        billBtn.setTitle("homeBills".localized, for: .normal)
        mobileAndInternetBtn.setTitle("homeMobileAndInternet".localized, for: .normal)
        shoppingCardsBtn.setTitle("homeShoppingCards".localized, for: .normal)
    }
    
    @objc func menuTapped() {
        self.presenter?.menuClicked()
    }
    
    @objc func notificationTapped() {
        NavigationPresenter.currentModule = "Notifications"
        self.presenter?.notificationClicked()
    }
    
    @objc func profTapped() {
        NavigationPresenter.currentModule = "Profile"
        self.presenter?.profileClicked()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        NavigationPresenter.currentModule = "Send"
        self.presenter?.sendClicked()
    }
    
    @IBAction func loadTapped(_ sender: Any) {
        NavigationPresenter.currentModule = "Load"
        self.presenter?.loadClicked()
    }
    
    @IBAction func payTapped(_ sender: Any) {
        NavigationPresenter.currentModule = "Pay"
        self.presenter?.payClicked()
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        NavigationPresenter.currentModule = "Profile"
        self.presenter?.profileClicked()
    }
    
    @IBAction func topUpTapped(_ sender: Any) {
        presenter?.topUpClicked()
    }
    
    
    @IBAction func webViewTapped(_ sender: Any) {
        presenter?.webViewClicked()
    }
    
    @IBAction func historyShowAllTapped(_ sender: Any) {
        presenter?.historyClicked()
    }
    
    @IBAction func vcnTapped(_ sender: Any) {
        
        //MARK: - POPUP Pin Code
        
  
        self.presenter!.loadCardsRequest()
        
        
            // presenter?.vcnClicked()
    }
    
    
    @IBAction func refreshClicked(_ sender: Any) {
        
        Util.debugMsg("Refresh Tapppped ........")
        self.presenter!.requestUpdateBalancePIN()
//        presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
//            self.presenter?.updateBalance(pin: pin)
//        }).disposed(by: disposeBag)
        
        
    }
    
    
    func getAllHistory(){

        self.presenter?.getAllHistory( page: 1)
        self.presenter?.historyArray.subscribe { (history) in
            Util.debugMsg(history.element?.toJSON())
               self.historyTableView.reloadData()
        }.disposed(by: self.disposeBag)
        
        self.presenter?.historyArray.bind(to: self.historyTableView.rx.items(cellIdentifier: "historyCell", cellType: HistoryCell.self)) {(row, history, cell) in
            
            Util.debugMsg(history)
            cell.updateCell(history: history)
        }.disposed(by: disposeBag)
        
        self.historyTableView.rx.modelSelected(History.self).subscribe(onNext: { (history) in
            //            self.presenter?.currentHistory.onNext(history)
            //            self.presenter?.cellTapped()
            self.presenter?.TransactionClicked(transaction: history)
        }).disposed(by: disposeBag)
        

        
    }
}

extension NavigationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter?.celImages.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollecCell", for: indexPath) as? MainCollectionCell
        cell?.imageView.image = presenter?.celImages[indexPath.item]
        cell?.title.text = presenter?.cellTitles[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseViewKind", for: indexPath) as! MainCollectionReusableView
            headerView.titleLabel.text = "walletBalance".localized
            headerView.amountLabel.text =  (presenter?.localManager?.user?._balance)! + " " + "egp".localized
            return headerView
        default:
            Util.debugMsg("unexpected")
            return UICollectionReusableView()
        }
        
    }
    
    @objc func handleRefreshBalance() {
        Util.debugMsg("Refresh Tapppped ........")
        presenter?.displayVerifiy(vc: self).subscribe(onNext: { (pin) in
            self.presenter?.updateBalance(pin: pin)
        }).disposed(by: disposeBag)
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            presenter?.sendClicked()
        case 1:
            presenter?.cashoutClicked()
        case 2:
            presenter?.cashinClicked()
        case 3:
            presenter?.payClicked()
        case 4:
            presenter?.loadClicked()
        case 5:
            presenter?.vcnClicked()
        default:
            presenter?.sendClicked()
        }
    }
}
