//
//  MutliUseVCNDeletionPresenter.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 9/21/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import Foundation
import UIKit
// VIPER Protocol for communication from Interactor -> Presenter
protocol MutliUseVCNDeletionInteractorToPresenterProtocol: class {
    
}

// VIPER Protocol for communication from View -> Presenter
protocol MutliUseVCNDeletionViewToPresenterProtocol: class {
    func viewDidLoad()
    func viewWillAppear()
    func doneButtonDidTapped(pin: String, cardNumber: String)
    
}


class MutliUseVCNDeletionPresenter {
    
    // MARK: - VIPER Stack
    weak var view: (MutliUseVCNDeletionPresenterToViewProtocol &  UIViewController)!
    var interactor: MutliUseVCNDeletionPresenterToInteractorProtocol!
    var wireframe: MutliUseVCNDeletionPresenterToWireframeProtocol!
    var delegate: MutliUseVCNDeletionDelegate!
    var cardNumber: String
    // MARK: - Instance Variables
    
    init(wireframe: MutliUseVCNDeletionPresenterToWireframeProtocol,
         view: MutliUseVCNDeletionPresenterToViewProtocol,
         interactor: MutliUseVCNDeletionPresenterToInteractorProtocol,
         cardNumber: String,
         delegate: MutliUseVCNDeletionDelegate) {
        self.delegate = delegate
        self.cardNumber = cardNumber
        self.wireframe = wireframe
        self.interactor = interactor
        self.view = view as? (MutliUseVCNDeletionPresenterToViewProtocol &  UIViewController)
    }
    
}

// MARK: - Interactor to Presenter Protocol
extension MutliUseVCNDeletionPresenter: MutliUseVCNDeletionInteractorToPresenterProtocol {
    
    
}

// MARK: - View to Presenter Protocol
extension MutliUseVCNDeletionPresenter: MutliUseVCNDeletionViewToPresenterProtocol {
    func viewDidLoad() {
        self.view.cardNumber = self.cardNumber
    }
    
    func viewWillAppear() {
//        self.delegate.completionDelegate(pin: "")
    }
    
    func doneButtonDidTapped(pin: String, cardNumber: String) {
        let nonWhitespacesCardNumber = self.cardNumber.components(separatedBy: .whitespaces).joined()
        if cardNumber == self.cardNumber ||  cardNumber == nonWhitespacesCardNumber {
            if pin.count > 5 {
                self.view.dismissView()
                self.delegate.completionDelegate(pin: pin)
            } else {
                self.wireframe.sweetAlertFail(message: "Please Enter Your Pin 6 digits", afterMsg: {})
            }
        } else {
            self.wireframe.sweetAlertFail(message: "Card Number Is Incorrect , Please Try Again", afterMsg: {})
        }
        
        print("""
            \(self.cardNumber)
            """)
    }
}


