//
//  MutliUseVCNDeletionWireframe.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 9/21/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import Foundation
import UIKit
// VIPER Module Constants
struct MutliUseVCNDeletionConstants {
    static let storyboardIdentifier = "MutliUseVCNDeletion"
    static let viewControllerIdentifier = "MutliUseVCNDeletion"
}

// VIPER Protocol for communication from Presenter -> Wireframe
protocol MutliUseVCNDeletionPresenterToWireframeProtocol: class, Router {
    
}


protocol MutliUseVCNDeletionDelegate {
    func completionDelegate(pin: String)
}

class MutliUseVCNDeletionWireframe : Router {
    
    // MARK: - Instance Variables
    weak var viewController: UIViewController!
    weak var previousView: UIViewController!
    var alert: UIViewController?
    
    init(cardNumber: String, delegate: MutliUseVCNDeletionDelegate) {
        super.init()
        loadView(cardNumber: cardNumber, delegate: delegate)
    }
    
    init(from view:UIViewController, isPush: Bool = true, cardNumber: String, delegate: MutliUseVCNDeletionDelegate) {
        super.init()
        self.previousView = view
        loadView(cardNumber: cardNumber, delegate: delegate)
        showView(isPush: isPush)
    }
    
    init(withRoot isOpenAsRoot:Bool = false, cardNumber: String, delegate: MutliUseVCNDeletionDelegate) {
        super.init()
        loadView(cardNumber: cardNumber, delegate: delegate)
        if isOpenAsRoot{
            openAsRootView(controller: self.viewController)
        }
        
    }
    
    private func loadView(cardNumber: String, delegate: MutliUseVCNDeletionDelegate){
        let storyboard = UIStoryboard(name: MutliUseVCNDeletionConstants.storyboardIdentifier, bundle: Bundle(for: MutliUseVCNDeletionWireframe.self))
        let view = (storyboard.instantiateViewController(withIdentifier: MutliUseVCNDeletionConstants.viewControllerIdentifier) as? MutliUseVCNDeletionView)!
        
        viewController = view
        
        let interactor = MutliUseVCNDeletionInteractor()
        let presenter = MutliUseVCNDeletionPresenter(wireframe: self,
                                                view: view,
                                                interactor: interactor, cardNumber: cardNumber, delegate: delegate)
        
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
    private func showView(isPush: Bool){
        if isPush {
            if let navigationController = self.previousView?.navigationController{
                navigationController.pushViewController(self.viewController, animated: true)
            } else {
                fatalError("No Navigation Controller")
            }
        } else {
            self.viewController.modalPresentationStyle = .fullScreen
            self.previousView.present(self.viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - Presenter to Wireframe Protocol
extension MutliUseVCNDeletionWireframe: MutliUseVCNDeletionPresenterToWireframeProtocol {
    
}
