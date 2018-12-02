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
import SHSideMenu
import Alamofire

class MyPageViewController: BaseViewController, SideMenuUsable {
    
    fileprivate enum Section: Int, CaseIterable {
        case user = 0
        case poem
    }
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    private var user: User?
    private var poems: [Poem]?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageUserTableViewCell.self)
        tableView.register(MyPagePoemTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        makeNavigationBar()
        bind()
        view.setNeedsUpdateConstraints()
        requestAPIs()
    }
    
    // MARK: - UI
    
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
    
    // MARk: - Network
    
    private func requestAPIs() {
        requestUser()
        requestPoems()
    }
    
    private func requestUser() {
        guard let userID = LoginKit.userID else {
            return
        }
        
        DatabaseService()
            .user(id: userID)
            .subscribe(onNext: { [weak self] userResult in
                switch userResult {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    print("\(error)")
                }
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func requestPoems() {
        DatabaseService()
            .poems()
            .subscribe(onNext: { [weak self] poemsResult in
                switch poemsResult {
                case .success(let poems):
                    self?.poems = poems
                case .failure(let error):
                    print("\(error)")
                }
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension MyPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.user.rawValue:
            return 1
        case Section.poem.rawValue:
            return poems?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.user.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as MyPageUserTableViewCell
            cell.configure(user)
            return cell
        case Section.poem.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as MyPagePoemTableViewCell
            if (poems?.count ?? 0) > indexPath.row {
                cell.configure(poems?[indexPath.row])
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.user.rawValue:
            return 120
        default:
            return UITableView.automaticDimension
        }
    }
}
