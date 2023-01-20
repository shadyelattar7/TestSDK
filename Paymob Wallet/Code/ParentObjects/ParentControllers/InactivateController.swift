//
//  InactivateController.swift
//  Paymob Wallet
//
//  Created by mahmoud gamal on 12/2/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class InactivateController: PayMobViewController {
    
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(invactivate), userInfo: nil, repeats: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(InactivateController.invactivate), userInfo: nil, repeats: false)
        Util.debugMsg("Touches began now")
        super.touchesBegan(touches, with: event)
    }
    
    @objc func invactivate() {
        Util.debugMsg("inactivate ")
        let backRouter = BackTaskRouter()
        backRouter.goToRequireAuth()
    }
    
}
