//
//  MutliUseVCNDeletionInteractor.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 9/21/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import Foundation

//MARK:- VIPER Protocol for communication from Presenter to Interactor
protocol MutliUseVCNDeletionPresenterToInteractorProtocol: class {
    
}


class MutliUseVCNDeletionInteractor {
    
    // MARK: - VIPER Stack
    weak var presenter: MutliUseVCNDeletionInteractorToPresenterProtocol!
}

// MARK: - Presenter To Interactor Protocol
extension MutliUseVCNDeletionInteractor: MutliUseVCNDeletionPresenterToInteractorProtocol {
    
    
}
