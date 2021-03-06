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
        case poem = 0
    }
    
    private enum Constants {
        static let poemPerPage: Int = 10
    }
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    private var user: UserModel?
    private var poems: [Poem]? {
        didSet {
            emptyView.isHidden = (poems?.count ?? 0) > 0
        }
    }
    private var isLoadingData: Bool = false
    private var isNoMoreData: Bool = false
    
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPagePoemTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var emptyView: EmptyView = {
        let emptyView: EmptyView = EmptyView()
        emptyView.configure(text: "작성한 시가 없습니다.")
        emptyView.isHidden = true
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(emptyView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: tableView.rx.backgroundColor)
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
    
    private func pullToRefresh(completion: @escaping () -> Void) {
        isNoMoreData = false
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
    
    private func requestPoems(lastPoem: Poem?, completion: @escaping (_ newValue: [Poem]) -> Void) {
        guard let userID = LoginService.shared.currentUID else {
            return
        }
        
        DatabaseService()
            .poems(userID: userID, lastPoem: lastPoem, limit: Constants.poemPerPage) { [weak self] result in
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
            .deletePoem(poem) { [weak self] error in
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
        return poems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MyPagePoemTableViewCell
        if (poems?.count ?? 0) > indexPath.row {
            cell.configure(poems?[indexPath.row])
        }
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let poems = poems, poems.count > indexPath.row else {
            return
        }
        let controller = WriteViewController(poem: poems[indexPath.row])
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
