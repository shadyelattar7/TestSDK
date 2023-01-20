//
//  IntroPresenter.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/14/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit


class IntroPresenter: Presenter {
    var router: IntroRouter?
    var texts = ["One", "Two", "three", "four", "Five"]
    var colors = [UIColor.white, UIColor.blue, UIColor.darkGray, UIColor.cyan, UIColor.green]
    var isSkipBtnHidden: Bool = false
    
    override init() {
        super.init()
    }
    
    func tutorialController(index: Int) -> TutorialController? {
        if let page = router?.initController(fromStoryboard: "Intro", controllerName: "pageViews") as? TutorialController {
            page.presenter = self
            page.index = index
            page.text = texts[index]
            page.color = colors[index]
            if index == 4 {
                page.isSkipBtnHidden = false
            }
            return page
        }
        return nil
    }
    
}
