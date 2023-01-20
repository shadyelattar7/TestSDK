//
//  RegPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 1/9/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit
import RxSwift

class RegPresenter: Presenter {
    
    var router: RegRouter?
    var apiManger: RegApiManager?
    var disposeBag = DisposeBag()
    //var pKey = BehaviorSubject<String>(value: "")
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var nationalID = ""
    
    override init(){
        super.init()
        self.apiManger = RegApiManager()
        
        /// to be called when user tap register
        //getAESKeys()
    }
    
    func getAESKeys(userData: [String:String])  {
        
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(2048)
        
        self.router?.displayAlert(msg: "loading".localized)
        apiManger?.aesKeys(privateKey: privateKey, publicKey: publicKey).subscribe(onNext: { (response) in
            
            guard response.txnStatus == "200" else {
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: response.msg!, afterMsg: {
                    })
                }
                return
            }
            
            let iv = response.iv?.data(using: .utf8)!
            let symKey = response.symKey?.data(using: .utf8)!
            let session = response.sessionID!
            
            ApiManager.aes = (iv, symKey, session)
            
            self.register(userData: userData)
            //self.pKey = response.pKey
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.hideMsg {
                    self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                    })
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func register(userData: [String: String]) {
        //self.router?.displayAlert(msg: NSLocalizedString("loading", comment: "loading"))
        self.apiManger?.register(params: userData).subscribe(onNext: { (response) in
            self.router?.hideMsg {
                guard response.txn == "200" else {
                    self.router?.sweetAlertFail(message: response.msg, afterMsg: {
                    })
                    return
                }
                
                self.router?.sweetAlertSuccess(message: response.msg, afterMsg: {
                    self.router?.goToAuth()
                })
            }
        }, onError: { (error) in
            self.router?.hideMsg {
                self.router?.sweetAlertFail(message: (error as! Response).msg, afterMsg: {
                })
            }
        }).disposed(by: self.disposeBag)
    }
    
    func registerTapped(userData: [String:String]) {
        //register(dic: userData)
        getAESKeys(userData: userData)
    }
    
    func selfRegTapped() {
        router?.goToSelfReg()
    }
    
    
    func loginBtnTapped() {
        router?.goToAuth()
    }
    
    func emptyFieldsError() {
        //router?.hideMsg {
            self.router?.sweetAlertFail(message: "All fields required", afterMsg: {
                
            })
        //}
    }
    
    func goToFinalRegController() {
        router?.goToFinalRegController()
    }
    
    func editNavigationTitleView(vc: UIViewController) {
        let titleCustomView = TitleCustomView(frame: (vc.navigationController?.navigationBar.frame)!)
        let stackView = UIStackView()
        stackView.backgroundColor = settings.primaryColor
        titleCustomView.addSubview(stackView)
        stackView.axis = .horizontal
        //stackView.distribution = .fillEqually
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: titleCustomView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: titleCustomView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "createNewAccount".localized
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "GESSTwoMedium-Medium", size: 17)
        let imageView = UIImageView(image: ImageProvider.image(named: "navIcon".localized))
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: titleCustomView.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (vc.navigationController?.navigationBar.frame.height)!).isActive = true
        imageView.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        
        //titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: titleCustomView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleCustomView.trailingAnchor).isActive = true
        //imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //titleLabel.heightAnchor.constraint(equalToConstant: (vc.navigationController?.navigationBar.frame.height)!).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleCustomView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleCustomView.bottomAnchor, constant: -5).isActive = true
        
        titleCustomView.backgroundColor = settings.primaryColor
        
        vc.navigationItem.titleView = titleCustomView
        
    }
    
}
