//
//  MapPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation

class MapPresenter: Presenter {
    var router: MapRouter?
    
    
    override init(){
        super.init()
    }
    
    func menuClicked()  {
        self.router?.toogleDrawer()
    }
}
