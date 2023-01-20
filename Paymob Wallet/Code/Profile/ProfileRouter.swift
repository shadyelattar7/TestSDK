//
//  ProfileRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/7/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit

class ProfileRouter: Router {
    var presenter = ProfilePresenter()
    var profileNav: UINavController?
    
    override init() {
        super.init()
        self.presenter.router = self
        let profileVC = initController(fromStoryboard: "Profile", controllerName: "ProfileVC") as? ProfileViewController
        profileVC?.presenter = self.presenter
        pushToDrawer(controller: profileVC!)
        profileNav = Router.drawerController?.centerViewController as? UINavController
        
    }
    
    func goToEditController() {
        let editUser = initController(fromStoryboard: "Profile", controllerName: "EditProfileVC") as? EditProfileViewController
        editUser?.presenter = self.presenter
        self.push(into: profileNav!, childController: editUser!)
    }
    
    func goToChangeNameController() {
        let changeName = initController(fromStoryboard: "Profile", controllerName: "editNameController") as? EditNameController
        changeName?.presenter = self.presenter
        self.push(into: profileNav!, childController: changeName!)
    }
    
    func goToResetMPin() {
        let resetPinVC = initController(fromStoryboard: "Profile", controllerName: "changePinController") as? ChangePinController
        resetPinVC?.presenter = self.presenter
        self.push(into: profileNav!, childController: resetPinVC!)
    }
    
    func goToChangePicture() {
        let changePicVC = initController(fromStoryboard: "Profile", controllerName: "changePictureController") as? ChangePictureController
        changePicVC?.presenter = self.presenter
        self.push(into: profileNav!, childController: changePicVC!)
    }
    
    func goToUnregisterController(){
        let unregister = UnregisterRouter()
        push(into: profileNav!, childController: unregister.unregisterController!)
        
    }
    
    func goToLogout() {
        _ = AuthRouter(withLogout: true)
    }
    
}
