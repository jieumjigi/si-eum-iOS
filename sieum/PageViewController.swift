//
///  MainPageViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SHSideMenu

class PageViewController: UIPageViewController, SideMenuUsable {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    lazy var pageViewModel: PageViewModel = PageViewModel()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(type: PoemViewController.self),
                self.newViewController(type: QuestionViewController.self),
                self.newViewController(type: PoetViewController.self)]
    }()
    
    private func newViewController(type: UIViewController.Type) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: type))
        
        if var pageViewModelUsable = viewController as? PageViewModelUsable {
            pageViewModelUsable.pageViewModel = pageViewModel
        }
        
        return viewController
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
// Local variable inserted by Swift 4.2 migrator.
let options = convertFromOptionalUIPageViewControllerOptionsKeyDictionary(options)

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: convertToOptionalUIPageViewControllerOptionsKeyDictionary(options))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .menu) { [weak self] in
            self?.sideMenuAction.onNext(.open)
        }
    
        navigationController?.makeClearBar()

        setFirstViewController()
        setupPageControl()
        bind()
    }

    // MARK: - Bind
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func setupPageControl() {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightBrown()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.darkBrown()
    }
}

// MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func setFirstViewController() {
        guard let firstViewController = orderedViewControllers.first else {
            return
        }
        
        setViewControllers([firstViewController], direction: .forward, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController),
            viewControllerIndex - 1 >= 0,
            orderedViewControllers.count > viewControllerIndex - 1 else {
                return nil
        }
        
        return orderedViewControllers[viewControllerIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController),
            orderedViewControllers.count != viewControllerIndex + 1,
            orderedViewControllers.count > viewControllerIndex + 1 else {
                return nil
        }
        
        return orderedViewControllers[viewControllerIndex + 1]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [UIPageViewController.OptionsKey: Any]?) -> [String: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [String: Any]?) -> [UIPageViewController.OptionsKey: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIPageViewController.OptionsKey(rawValue: key), value)})
}
