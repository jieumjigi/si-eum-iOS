//
///  MainPageViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.setColor()
        self.setupPageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UI
    
    func setColor(){
//        self.view.backgroundColor = UIColor(red: (254.0/255.0), green: (255.0/255.0), blue: (250.0/255.0), alpha: 1.0)
        self.view.backgroundColor = UIColor.defaultBackground()
    }
    
    
    private func setupPageControl() {
    
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.darkBrown()
        appearance.currentPageIndicatorTintColor = UIColor.lightBrown()
//        appearance.backgroundColor = UIColor.darkGray
    }
    
    
    // MARK: UIPageViewControllerDataSource
    
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name: "PoemViewController") ,
                self.newViewController(name: "QuestionViewController") ,
                self.newViewController(name: "PoetViewController")]
    }()
    
    private func newViewController(name: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(name)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
