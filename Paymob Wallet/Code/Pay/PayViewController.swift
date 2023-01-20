//
//  PayViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import QRCodeReader
import AVFoundation

class PayViewController: PayMobViewController,WKScriptMessageHandler,WKNavigationDelegate, QRCodeReaderViewControllerDelegate, UITableViewDelegate  {
    
    @IBOutlet weak var fMerView: UIView!
    @IBOutlet weak var virtualCardsTable: UITableView!
    
    @IBOutlet weak var cancelInqPayBtn: UIButton!
    @IBOutlet weak var refreashBtn: UIButton!
    @IBOutlet weak var faviouriteTable: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var inquireBtn: UIButton!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var nextBtn: PaymobUIButton!
    @IBOutlet weak var featuredLb: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var deleteAllBtn: PaymobUIButton!
    
    @IBOutlet weak var payByQrUIView: UIView!
    @IBOutlet weak var payByQrTitle: UILabel!
    @IBOutlet weak var payByQrSubTitle: UILabel!
    @IBOutlet weak var payByQrBtn: UIButton!
    @IBOutlet weak var payQrOrManuallyTitle: UILabel!
    var WKwebview:WKWebView?
    
    var presenter: PayPresenter?
    var current: currentPage?
    var refreshControl: UIRefreshControl?
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    func localization() {
        //self.navigationItem.title = NSLocalizedString("pay", comment: "pay")
        self.nextBtn.setTitle("payManuallyBtn".localized, for: .normal)
        self.payByQrBtn.setTitle("payByQrBtn".localized, for: .normal)
        payByQrTitle.text = "payByQrTitle".localized
        payByQrSubTitle.text = "payByQrSubTitle".localized
        payQrOrManuallyTitle.text = "payByQrOrManually".localized
        
        self.featuredLb.text = "featured".localized
        self.segmentControl.setTitle("store".localized, forSegmentAt: 0)
        self.segmentControl.setTitle("services".localized, forSegmentAt: 1)
        self.segmentControl.setTitle("online".localized, forSegmentAt: 2)
        self.deleteAllBtn.setTitle("deleteAll".localized, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyBoard(withPush: false)
        self.addWebView()
        self.localization()
        
        presenter?.addBarButtons(vc: self)
        //        presenter?.getAdImage()
        // handle current page
        
        
        //MARK: - POPUP Pin Code

        presenter?.currentPage.subscribe(onNext: { (current) in
            Util.debugMsg(current)
            self.current = current
            switch current
            {
            case .qrCode:
                self.servicesView.isHidden = true
                self.storeView.isHidden = false
                self.cardView.isHidden = true
                self.favView.isHidden = true
                self.navigationItem.title = "homePay".localized

            case .vcn:
                self.servicesView.isHidden = true
                self.storeView.isHidden = true
                self.cardView.isHidden = false
                self.favView.isHidden = true
                self.navigationItem.title = "eCommere".localized
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //  self.presenter!.loadCardsRequest()
                //                }
            case .webView:
                self.servicesView.isHidden = false
                self.storeView.isHidden = true
                self.cardView.isHidden = true
                self.favView.isHidden = true
                self.navigationItem.title = "bills".localized
            }

        }).disposed(by: disposeBag)
 
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshFavTable), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.faviouriteTable.addSubview(refreshControl!)
        
        faviouriteTable.delegate = self
        
        presenter?.favBills.bind(to: self.faviouriteTable.rx.items(cellIdentifier: "favCell", cellType: FavBillCell.self)){(row, bill, cell) in
            cell.billNameValue.text = bill.billName
            cell.billRefValue.text = bill.billReference
            cell.statusValue.text = bill.status
            cell.amountValue.text = bill.amount
            cell.amountStackView.isHidden = false
            cell.statusStackView.isHidden = false
            
        }.disposed(by: disposeBag)
        
        
        presenter?.embeddFMerVC(into: self, container: fMerView)
        //        presenter?.featMerCodeObserver.bind(to: self.merCode.rx.text).disposed(by: disposeBag)
        
        self.segmentControl.selectedSegmentIndex = 0
        virtualCardsTable.tableFooterView = UIView()
        virtualCardsTable.rowHeight = 60
      
        self.presenter?.virtualCardsObservable.bind(to: self.virtualCardsTable.rx.items(cellIdentifier: "vcnCell", cellType: UITableViewCell.self))
        {(row, card, cell) in
            if card.number == "Generate Card" {
                //cell.textLabel?.text = card.number
                cell.textLabel?.text = "generateCard".localized
                cell.detailTextLabel?.text = ""
                //cell.textLabel?.backgroundColor = .lightGray
                //cell.textLabel?.contentMode = .scaleAspectFit
                cell.backgroundColor = .white
                cell.imageView?.image = ImageProvider.image(named: "plus")
                //cell.imageView?.contentMode = .scaleAspectFit
            }else{
                let cardNumber = card.number
                let last4Digits = cardNumber?.components(separatedBy: " ")[3]
                Util.debugMsg(last4Digits)
                cell.textLabel?.text = "**** **** **** \(last4Digits!)"
                cell.imageView?.image = ImageProvider.image(named: "VCN")
                cell.accessoryView = UIImageView(image: ImageProvider.image(named: "ic_multiUseVCN_small"))
                if card.isMultiUse {
                    cell.detailTextLabel?.text = "Multiple Usage"
                } else {
                    cell.detailTextLabel?.text = ""
                }
            }
        }.disposed(by: disposeBag)
        
        self.faviouriteTable.rx.modelDeleted(FavBill.self).subscribe { (favBill) in
            Util.debugMsg(favBill.element?.amount)
            //self.presenter?.setNotification(dateTime: (notification.element?.data.preFormattedDate)!, action: .delete)
            //self.presenter?.getAllNotification()
            self.presenter?.deleteFavBill(bill: favBill.element!)
        }.disposed(by: disposeBag)
        
        self.virtualCardsTable.rx.itemSelected.subscribe(onNext:{ (index) in
            self.presenter?.openCardPage(at:index)
            
        }).disposed(by:disposeBag)
        
        self.virtualCardsTable.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        self.virtualCardsTable.rx.modelDeleted(VirtualCard.self).subscribe { (card) in
            if card.element!.isMultiUse {
                self.presenter?.deleteCard(card: card.element!, from: self)
            } else {
                self.presenter?.deleteCard(card: card.element!)
            }
            
            
        }.disposed(by: disposeBag)
        
        self.payBtn.isEnabled = false
        self.payBtn.titleLabel?.textColor = .lightGray
        self.inquireBtn.isEnabled = true
        self.inquireBtn.titleLabel?.textColor = .white
        presenter?.inquirySuccess.subscribe(onNext: { (_) in
            self.inquireBtn.isEnabled = false
            self.inquireBtn.titleLabel?.textColor = .lightGray
            self.payBtn.isEnabled = true
            self.payBtn.titleLabel?.textColor = .white
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        presenter?.paymentSuccess.subscribe(onNext: { (_) in
            self.inquireBtn.isEnabled = false
            self.payBtn.isEnabled = false
            self.inquireBtn.titleLabel?.textColor = .lightGray
            self.payBtn.titleLabel?.textColor = .lightGray
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        presenter?.cancelSuccess.subscribe(onNext: { (_) in
            self.inquireBtn.isEnabled = true
            self.payBtn.isEnabled = false
            self.inquireBtn.titleLabel?.textColor = .white
            self.payBtn.titleLabel?.textColor = .lightGray
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        presenter?.inquiryPayFaliure.subscribe(onNext: { (_) in
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        if self.current == .qrCode{
            //            QRCodeViewInit()
        }
    }
    
    func QRCodeViewInit(){
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.AppColor.LabelGreen?.cgColor
        yourViewBorder.lineDashPattern = [4, 4]
        yourViewBorder.frame = payByQrUIView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(roundedRect: payByQrUIView.bounds, cornerRadius: 16).cgPath
        
        //        payByQrUIView.layer.sublayers = nil
        payByQrUIView.layer.insertSublayer(yourViewBorder, at: 0)
    }
    
    @objc func handleUpdateNotification() {
        self.presenter?.getNumOfUnreadNotification()
    }
    
    
    @IBAction func cancelINQPAYTapped(_ sender: Any) {
        self.presenter?.showAlertToCancel()
    }
    @IBAction func refreashTapped(_ sender: Any) {
        refreshFavTable()
    }
    
    @objc func refreshFavTable() {
        let key = UserDefaults.standard.string(forKey: blulkState.key.description)
        if let bulkKey = key {
            switch bulkKey {
            case blulkState.getFav.description:
                self.payBtn.isEnabled = false
                self.payBtn.titleLabel?.textColor = .lightGray
                self.inquireBtn.isEnabled = true
                self.inquireBtn.titleLabel?.textColor = .white
                self.presenter?.getFavBills()
            case blulkState.inquiry.description:
                self.payBtn.isEnabled = true
                self.payBtn.titleLabel?.textColor = .white
                self.inquireBtn.isEnabled = false
                self.inquireBtn.titleLabel?.textColor = .lightGray
                self.presenter?.getBillsStatus(action: "inq")
            case blulkState.pay.description:
                self.payBtn.isEnabled = false
                self.payBtn.titleLabel?.textColor = .lightGray
                self.inquireBtn.isEnabled = false
                self.inquireBtn.titleLabel?.textColor = .lightGray
                self.presenter?.getBillsStatus(action: "PAY")
            default:
                self.payBtn.isEnabled = false
                self.payBtn.titleLabel?.textColor = .lightGray
                self.inquireBtn.isEnabled = true
                self.inquireBtn.titleLabel?.textColor = .white
                self.presenter?.getFavBills()
            }
        } else {
            self.presenter?.getFavBills()
        }
        
    }
    
    @IBAction func payTapped(_ sender: Any) {
        
        let inqBills = presenter?.favBillsArray?.filter({ (bill) -> Bool in
            bill.isSelected == true
        })
        if (inqBills?.count)! > 0 {
            presenter?.sendBulkPayBills(selectedBills: inqBills!.toJSON())
        }
    }
    
    @IBAction func inquireTapped(_ sender: Any) {
        let inqBills = presenter?.favBillsArray?.filter({ (bill) -> Bool in
            bill.isSelected == true
        })
        
        if (inqBills?.count)! > 0 {
            
            Util.debugMsg(inqBills?.count)
            
            presenter?.sendInqBills(selectedBills: inqBills!.toJSON())
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == virtualCardsTable {
            if indexPath.row == 0 {
                return .none
            }
            return .delete
        } else if tableView == faviouriteTable {
            let key = UserDefaults.standard.string(forKey: blulkState.key.description)
            if let bulkKey = key {
                switch bulkKey {
                case blulkState.getFav.description:
                    return .delete
                case blulkState.inquiry.description:
                    return .none
                case blulkState.pay.description:
                    return .none
                default:
                    return .none
                }
            } else {
                return .delete
            }
        } else {
            return .none
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNotification), name: NSNotification.Name("updateNotification"), object: nil)
        
        //        if let mer = UserDefaults.standard.object(forKey: "Merchant") as? String {
        //            merCode.text = mer
        //        }
        if let merName = UserDefaults.standard.object(forKey: "MerchantName") as? String {
            presenter?.merNameObserver.onNext(merName)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        UserDefaults.standard.setValue(nil, forKey: "Merchant")
        UserDefaults.standard.setValue(nil, forKey: "MerchantName")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func deleteCards(_ sender: Any) {
        
        presenter?.deleteAllCards()
    }
    
    @IBAction func merchantClicked(_ sender: Any) {
        // open the merchants and store their object
        _ = MerchantsRouter(fromPay: true)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        
        presenter?.nextClicked()
    }
    
    @IBAction func openTheQR(_ sender: Any) {
        //open the QR reader
        if (presenter?.checkScanPermissions(viewController: self))! {
            readerVC.delegate = self
            
            // Or by using the closure pattern
            readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                Util.debugMsg(result?.value)
            }
            
            // Presents the readerVC as modal form sheet
            readerVC.modalPresentationStyle = .formSheet
            present(readerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        let segmentIndex=segmentControl.selectedSegmentIndex
        
        switch segmentIndex {
        case 0:
            storeView.isHidden=false
            servicesView.isHidden=true
            cardView.isHidden=true
            favView.isHidden = true
            break
        case 1:
            storeView.isHidden=true
            servicesView.isHidden=false
            cardView.isHidden=true
            favView.isHidden = true
            break
            
        case 2:
            storeView.isHidden=true
            servicesView.isHidden=true
            cardView.isHidden=false
            favView.isHidden = true
            break
            
        case 3:
            storeView.isHidden=true
            servicesView.isHidden=true
            cardView.isHidden=true
            favView.isHidden = false
            let key = UserDefaults.standard.string(forKey: blulkState.key.description)
            if let bulkKey = key {
                switch bulkKey {
                case blulkState.getFav.description:
                    self.payBtn.isEnabled = false
                    self.payBtn.titleLabel?.textColor = .lightGray
                    self.inquireBtn.isEnabled = true
                    self.inquireBtn.titleLabel?.textColor = .white
                    self.presenter?.getFavBills()
                case blulkState.inquiry.description:
                    self.payBtn.isEnabled = false
                    self.payBtn.titleLabel?.textColor = .lightGray
                    self.inquireBtn.isEnabled = false
                    self.inquireBtn.titleLabel?.textColor = .lightGray
                    self.presenter?.getBillsStatus(action: "INQ")
                case blulkState.pay.description:
                    self.payBtn.isEnabled = false
                    self.payBtn.titleLabel?.textColor = .lightGray
                    self.inquireBtn.isEnabled = false
                    self.inquireBtn.titleLabel?.textColor = .lightGray
                    self.presenter?.getBillsStatus(action: "PAY")
                default:
                    self.payBtn.isEnabled = false
                    self.payBtn.titleLabel?.textColor = .lightGray
                    self.inquireBtn.isEnabled = true
                    self.inquireBtn.titleLabel?.textColor = .white
                    self.presenter?.getFavBills()
                }
            } else {
                self.presenter?.getFavBills()
            }
            
            break
            
        default:
            storeView.isHidden=false
            servicesView.isHidden=true
            cardView.isHidden=true
            favView.isHidden = true
            break
            
        }
        
    }
    
    //    @IBAction func menuTapped(_ sender: Any) {
    //        presenter?.menuClicked()
    //    }
    
    func addWebView(){
        var stringUrl = ""
        //        print("\n\n\n\n\n\n\n")
        //        print("value of the debug : \(self.presenter?.settings.debug)")
        //        print("\n\n\n\n\n\n\n")
        if self.presenter?.settings.debug ?? true{
            stringUrl = self.settings.webViewLink
        }else{
            stringUrl = self.settings.webViewLink
        }
        
        
        
        var completeUrl = ""
        if EntryPoint.langId == "ar" {
            completeUrl = stringUrl+"ar"
        } else {
            completeUrl = stringUrl+"en"
        }
        
        let url=URL(string: completeUrl)
        
        let request = URLRequest(url: url!)
        let config=WKWebViewConfiguration()
        config.userContentController.add(self, name: "PayMob")
        
        
        WKwebview=WKWebView(frame: servicesView.bounds, configuration: config)
        
        WKwebview!.navigationDelegate=self
        WKwebview!.isHidden=true
        
        WKwebview!.load(request)
        //self.servicesView.autoresizesSubviews = true
        //self.servicesView.translatesAutoresizingMaskIntoConstraints=false
        self.WKwebview?.translatesAutoresizingMaskIntoConstraints=false
        self.servicesView.addSubview(WKwebview!)
        self.WKwebview?.leadingAnchor.constraint(equalTo: servicesView.leadingAnchor).isActive = true
        self.WKwebview?.trailingAnchor.constraint(equalTo: servicesView.trailingAnchor).isActive = true
        self.WKwebview?.bottomAnchor.constraint(equalTo: servicesView.bottomAnchor).isActive = true
        self.WKwebview?.topAnchor.constraint(equalTo: servicesView.topAnchor).isActive = true
        
        
        let source: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.WKwebview?.configuration.userContentController.addUserScript(script)
        
        clearWebviewCache()
        
    }
    
    func clearWebviewCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.isHidden=true
        self.WKwebview?.isHidden=false
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dataFromString = message.body as? String else {
            
            print("no data from string")
            return
        }
        
        self.presenter?.webView(with: dataFromString)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: {
            self.presenter?.qrRequestAfterScanning(scanResult: result.value)
            
        })
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        //        if let cameraName = newCaptureDevice.device.localizedName {
        //            print("Switching capturing to: \(cameraName)")
        //        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == faviouriteTable {
            presenter?.favBillsArray?[indexPath.item].isSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == faviouriteTable {
            presenter?.favBillsArray?[indexPath.item].isSelected = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView == faviouriteTable {
            if let se = tableView.indexPathsForSelectedRows {
                if se.count == 5 {
                    return nil
                }
            }
            return indexPath
        }
        return indexPath
    }
    
    //    @objc func menuTapped() {
    //        self.presenter?.menuClicked()
    //    }
    //
    //    @objc func notificationTapped() {
    //        NavigationPresenter.currentModule = "Notifications"
    //        self.presenter?.goToNotifications()
    //    }
    //
    //    @objc func backTapped() {
    //        NavigationPresenter.currentModule = "Dashboard"
    //        presenter?.goToDashboard()
    //    }
    //    func addBarButtons() {
    //        let menuBtn = UIButton(type: .custom)
    //        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    //        menuBtn.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
    //        menuBtn.setImage(#imageLiteral(resourceName: "Menu-23"), for: .normal)
    //        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
    //
    //        let notificationBtn = UIButton(type: .custom)
    //        notificationBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    //        notificationBtn.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
    //        notificationBtn.setImage(#imageLiteral(resourceName: "horn-white-25"), for: .normal)
    //        let notificationBarBtn = UIBarButtonItem(customView: notificationBtn)
    //
    //        navigationItem.leftBarButtonItems = [menuBarBtn, notificationBarBtn]
    //
    //        let appIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    //        appIconImageView.image = #imageLiteral(resourceName: "upperAppIcon")
    //        appIconImageView.contentMode = .scaleAspectFit
    //        let appIconBarBtn = UIBarButtonItem(customView: appIconImageView)
    //
    //        let backBtn = UIButton(type: .custom)
    //        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 25)
    //        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    //        backBtn.setImage(UIImage(named: NSLocalizedString("backTitle", comment: "backTitle")), for: .normal)
    //        let backBarBtn = UIBarButtonItem(customView: backBtn)
    //
    //        navigationItem.rightBarButtonItems = [backBarBtn, appIconBarBtn]
    //
    //    }
    
    
    //MARK: -
    
//    WKwebview.evaluateJavaScript("document.getElementById('bill_reference').value = '\(phoneNumber)'") { (result, error) in
//        print(result) //This will Print Hello
//        self.viewDidLayoutSubviews()
//        print("Added View Phone NUmber")
//    }
//    
//    
//    
//    WKwebview.evaluateJavaScript("document.getElementById('mobile_number').value = '\(phoneNumber)'") { (result, error) in
//        print(result) //This will Print Hello
//        self.viewDidLayoutSubviews()
//        print("Added View Phone NUmber")
//    }
    
}
