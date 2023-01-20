//
//  SplashVC.swift
//  Paymob Wallet
//
//  Created by Al-attar on 18/10/2022.
//  Copyright © 2022 mahmoud. All rights reserved.
//

import UIKit
//import Firebase

class SplashVC: UIViewController{
    
    @IBOutlet weak var signInLogo: UIImageView!
    @IBOutlet weak var powredBy: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
        
//        Messaging.messaging().subscribe(toTopic: "news");
//        Messaging.messaging().subscribe(toTopic: "iOS");
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SplashVC.navigate), userInfo: nil, repeats: false)
    }
    
    func UI(){
        signInLogo.image = ImageProvider.image(named: "HalanCash_\(EntryPoint.langId ?? "en")")
    }
    
    @objc func navigate(){
        _ = AuthRouter()
    }
}
