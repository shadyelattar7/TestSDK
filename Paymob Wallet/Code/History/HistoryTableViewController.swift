//
//  HistoryTableViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/11/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryTableViewController: PayMobViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter: HistoryPresenter?
    var page = 1
    var isLoading: Bool = false
    var last_page = 10
    var pin = String()
    var historyCount = 0
    var newHistory = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        getAllHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        segmentIndex = 0
    }
    
    func getAllHistory(){

        self.presenter?.getAllHistory( page: self.page)
        self.tableView.isHidden = false
        self.presenter?.historyArray.subscribe { (history) in
            Util.debugMsg(history.element?.toJSON())
               self.historyCount = history.element?.count ?? 0
               self.newHistory = history.element!
               self.tableView.reloadData()
        }.disposed(by: self.disposeBag)
        
        self.presenter?.historyArray.bind(to: self.tableView.rx.items(cellIdentifier: "historyCell", cellType: HistoryCell.self)) {(row, history, cell) in
            Util.debugMsg(history)
            cell.updateCell(history: history)
        }.disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(History.self).subscribe(onNext: { (history) in
            self.presenter?.currentHistory.onNext(history)
            self.presenter?.cellTapped()
        }).disposed(by: disposeBag)
        
        tableView.rx
                .willDisplayCell
                .subscribe(onNext: { cell, indexPath in
                    guard segmentIndex == 0 else{return}
                    if indexPath.row == (self.historyCount - 1) {
                        if self.page <= self.presenter?.number_Pages ?? 0{
                                            self.page += 1
                                            self.isLoading = false
                            self.loadMore()
                        }

                    }
                   })
                .disposed(by: disposeBag)

    }
    
    
    fileprivate func loadMore() {
        guard isLoading == false else { return }
        guard page <= (presenter?.number_Pages ?? 0) else { return }
        self.presenter?.getAllHistory( page: self.page)
       
        isLoading = true

    }

}
