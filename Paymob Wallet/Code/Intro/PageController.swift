//
//  PageController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 3/14/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//

import UIKit

class PageController: UIPageViewController {

    var currentIndex: Int!
    var pageControl: UIPageControl!
    
    var pagesCount = 5
    var presenter: IntroPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let viewController = presenter?.tutorialController(index: currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        self.pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pagesCount
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
                
    }
    
    
}

extension PageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? TutorialController,
            let index = viewController.index,
            index > 0 {
            return presenter?.tutorialController(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? TutorialController,
            let index = viewController.index,
            (index + 1) < pagesCount {
            return presenter?.tutorialController(index: index + 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? TutorialController {
                pageControl.currentPage = currentViewController.index
            }
        }
    }
    
    //    func presentationCount(for pageViewController: UIPageViewController) -> Int {
    //        return 3
    //    }
    //
    //    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    //        return currentIndex ?? 0
    //    }
}

