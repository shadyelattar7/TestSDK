//
//  UINavControllerController.swift
//  Paymob Wallet
//
//  Created by Ahmed Aldaly on 10/14/17.
//  Copyright © 2017 Ahmed Aldaly. All rights reserved.
//

import UIKit

class UINavController: UINavigationController {
    var presenter:NavigationPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.barTintColor = Settings.getStettings().primaryColor
        self.navigationBar.barTintColor = UIColor.white
        //for audi
        //self.navigationBar.barTintColor = UIColor(red: 29/255, green: 125/255, blue: 137/255, alpha: 1)
        self.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
             //  self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu-white-25"), style: .plain, target: self, action: #selector(self.toggleDrawer))
    }
    func toggleDrawer(){
//        self.presenter?.menuClicked()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
