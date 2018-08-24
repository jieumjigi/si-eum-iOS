//
//  MyPageViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 20..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RxDataSources
import SHSideMenu

class MyPageViewController: UIViewController, SideMenuUsable {
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        
        bind()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
        }
        
        super.updateViewConstraints()
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }

    private func makeNavigationBar() {
        navigationController?.makeClearBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .menu) { [weak self] in
            self?.sideMenuAction.onNext(.open)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(for: .write) { [weak self] in
            self?.navigationController?.pushViewController(WriteViewController(), animated: true)
        }
    }
}
