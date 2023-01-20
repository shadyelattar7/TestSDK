//
//  MapRouter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import Foundation

class MapRouter: Router {
    var presenter = MapPresenter()
    
    override init() {
        super.init()
//        self.presenter.router = self
//        let mapController = initController(fromStoryboard: "Map", controllerName: "mapVC") as? MapViewController
//        mapController?.presenter = self.presenter
//        pushToDrawer(controller: mapController!)
    }
}
