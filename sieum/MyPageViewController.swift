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
    
    private enum Constants {
        static let poemPerPage: Int = 10
    }
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    private var user: UserModel?
    private var poems: [Poem]?
    private var isLoadingData: Bool = false
    private var isNoMoreData: Bool = false
    
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageUserTableViewCell.self)
        tableView.register(MyPagePoemTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var writingButton: UIButton = {
        let writingButton = UIButton(for: .write) { [weak self] in
            self?.present(UINavigationController(rootViewController: WriteViewController()), animated: true)
        }
        writingButton.tintColor = .white
        writingButton.backgroundColor = #colorLiteral(red: 0.1697136164, green: 0.1262311339, blue: 0.05355303735, alpha: 1)
        writingButton.layer.cornerRadius = 25
        return writingButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(writingButton)
        makeNavigationBar()
        refreshControl.addTarget(for: .valueChanged) { [weak self] in
            guard let strongSelf = self, strongSelf.tableView.contentOffset.y < 0 else {
                return
            }
            strongSelf.pullToRefresh() {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        bind()
        pullToRefresh() { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - UI
    
    override func updateViewConstraints() {
        if didUpdateConstraints == false {
            didUpdateConstraints = true
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view.snp.edges)
            }
            
            writingButton.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                if #available(iOS 11.0, *) {
                    make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
                } else {
                    make.trailing.equalTo(view.snp.trailing).offset(15)
                    make.bottom.equalTo(view.snp.bottom).offset(15)
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
    }
    
    // MARk: - Network
    
    private func pullToRefresh(completion: @escaping () -> Void) {
        isNoMoreData = false
        requestUser()
        requestPoems(lastPoem: nil) { [weak self] newValue in
            self?.isNoMoreData = newValue.count < Constants.poemPerPage
            completion()
        }
    }
    
    private func loadMore(completion: @escaping () -> Void) {
        guard let lastPoem = poems?.last else {
            return
        }
        requestPoems(lastPoem: lastPoem) { [weak self] newValue in
            self?.isNoMoreData = newValue.count < Constants.poemPerPage
            completion()
        }
    }
    
    private func requestUser() {
        // TODO: - User ID 가져오기
        
        guard let uid = LoginService().currentUID else {
            return
        }
                
//        DatabaseService()
//            .user(id: uid)
//            .subscribe(onNext: { [weak self] userResult in
//                switch userResult {
//                case .success(let user):
//                    self?.user = user
//                case .failure(let error):
//                    print("\(error)")
//                }
//                self?.tableView.reloadData()
//            }).disposed(by: disposeBag)
    }
    
    private func requestPoems(lastPoem: Poem?, completion: @escaping (_ newValue: [Poem]) -> Void) {
        DatabaseService()
            .poems(lastPoem: lastPoem, limit: Constants.poemPerPage) { [weak self] result in
                switch result {
                case .success(let loadedPoems):
                    if lastPoem == nil {
                        self?.poems = loadedPoems
                    } else {
                        self?.poems?.append(contentsOf: loadedPoems)
                    }
                    completion(loadedPoems)
                case .failure(let error):
                    print("\(error)")
                    completion([])
                }
            }
    }
    
    private func removePoem(at index: Int) {
        guard let poem = poems?[index] else {
            return
        }
        
        DatabaseService()
            .removePoem(with: poem.identifier) { [weak self] error in
                guard error == nil else {
                    return
                }
                self?.poems = self?.poems?.filter { $0.identifier != poem.identifier }
                self?.tableView.reloadData()
        }
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
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = (poems?.count ?? 0) - 1
        if isLoadingData == false && isNoMoreData == false && indexPath.row == lastElement {
            isLoadingData = true
            loadMore { [weak self] in
                self?.isLoadingData = false
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(
            style: .destructive,
            title: "삭제",
            handler: { [weak self] _, indexPath in
                self?.removePoem(at: indexPath.row)
        })]
    }
}
