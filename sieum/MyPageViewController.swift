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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyPageProfileTableViewCell.self)
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        makeNavigationBar()
        bind()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            tableView.snp.makeConstraints { make in
                if #available(iOS 11.0, *) {
                    make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
                } else {
                    make.edges.equalTo(view.snp.edges)
                }
            }
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
            self?.present(UINavigationController(rootViewController: WriteViewController()), animated: true)
        }
    }
    
//    private func requestPoems() {
//        Request.poems().bind
//    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as MyPageProfileTableViewCell
            cell.configure(profile: LoginKit.profile())
            return cell
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "test \(indexPath.row)"
            return cell
        }
    }
}
