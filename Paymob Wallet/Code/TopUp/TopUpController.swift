//
//  TopUpController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 8/16/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RxSwift

class TopUpController: PayMobViewController {
    
    @IBOutlet weak var institutesTableView: UITableView!
    @IBOutlet weak var topUpCollectionView: UICollectionView!
    
    var presenter: TopUpPresenter?
    var institutes: [Institution] = []
    var numOfUnreadNoti = BehaviorSubject<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.addBarButtons(vc: self)
        topUpCollectionView.delegate = self
        topUpCollectionView.dataSource = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.title = "topUpTitle".localized
        
                presenter?.viewDidLoad( self)
                institutesTableView.delegate = self
                institutesTableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: false)
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
    
    func institutesReceived(_ institutes: [Institution]){
        self.institutes = institutes
        self.institutesTableView.reloadData()
        self.topUpCollectionView.reloadData()
    }
    
    @IBAction func tsaheelTapped(_ sender: Any) {
//        presenter?.tsahelOrMashroeyTapped(type: .tasahel)
    }
    
    @IBAction func mashroeyTapped(_ sender: Any) {
//        presenter?.tsahelOrMashroeyTapped(type: .mashroey)
    }
    
}

extension TopUpController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return institutes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = institutesTableView.dequeueReusableCell(withIdentifier: "instituteCell") as! InstituteCell
        
        let url = URL(string: institutes[indexPath.row].logo_url)!
        cell.InstituteImageView!.kf.setImage(with: url, placeholder: UIImage.init(named: "white_tasahel"))
        
        if EntryPoint.langId == "ar" {
            cell.InstituteLabel.text = self.institutes[indexPath.row].name_ar
        } else {
            cell.InstituteLabel.text = self.institutes[indexPath.row].name_en
        }
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
                
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tsahelOrMashroeyTapped(institute: self.institutes[indexPath.row])
        
    }
}

extension TopUpController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return institutes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollecCell", for: indexPath) as? TopUpCollectionCell

        let url = URL(string: institutes[indexPath.row].logo_url)!
        cell?.image!.kf.setImage(with: url, placeholder: UIImage.init(named: "white_tasahel"))
        
        if EntryPoint.langId == "ar" {
            cell?.title.text = self.institutes[indexPath.row].name_ar
        } else {
            cell?.title.text = self.institutes[indexPath.row].name_en
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-48)/2, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopUpCollectionHeader", for: indexPath) as! TopUpCollectionHeader
            
            headerView.headerTitle.text = "chooseTopUp".localized
            return headerView
        default:
            Util.debugMsg("unexpected")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.tsahelOrMashroeyTapped(institute: self.institutes[indexPath.item])
    }
}
