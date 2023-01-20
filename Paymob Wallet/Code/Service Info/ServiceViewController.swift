//
//  ServiceViewController.swift
//  Paymob Wallet
//
//  Created by mac on 27/07/2021.
//  Copyright © 2021 mahmoud. All rights reserved.
//

import UIKit

class ServiceViewController: InactivateController {
    
    var presenter: ServiceInfoPresenter?
    
    @IBOutlet weak var serviceInfoTableView: UITableView!{
        didSet {
            serviceInfoTableView.tableFooterView = UIView(frame: .zero)
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Service Info".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.requestSerivceInfo()
    }

    func reloadTableView(){
        serviceInfoTableView.reloadData()
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        presenter?.menuClicked()
    }
    
}
extension ServiceViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.serviceInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceInfoTableViewCell", for: indexPath) as! ServiceInfoTableViewCell
        cell.serivceInfoLabel.text = presenter?.serviceInfo[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let serviceInfo = presenter?.serviceInfo[indexPath.row]{
        presenter?.showDetailsServiceInfo(serviceInfo: serviceInfo)
        }
    }
    
}
