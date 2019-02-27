//
//  PoetsViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RxDataSources
import SHSideMenu

struct Poet {
    var name: String?
    var imageUrl: String?
    var job: String?
    var snsUrl: String?
    var description: String?
}

enum PoetsSection: Int, CaseIterable {
    case thumnail = 0
    case profile
    case poems
}

enum ProfileRow: Int, CaseIterable {
    case main = 0
    case description
}

class PoetsViewController: UIViewController, SideMenuUsable {
    
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    private var didupdateViewConstraints: Bool = false
    fileprivate var cellHeightsDictionary: [String: CGFloat] = [:]
    
    var users: [UserModel] = []
    var selectedUser: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    var poems: [Poem] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PoetsThumbnailContainerCell.self)
        tableView.register(PoetProfileCell.self)
        tableView.register(PoetDescriptionCell.self)
        tableView.register(PoemsOfPoetContainerCell.self)
        tableView.refreshControl = refreshControl
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        bind()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if didupdateViewConstraints == false {
            didupdateViewConstraints = true
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        super.updateViewConstraints()
    }
    
    private func makeNavigationBar() {
        navigationController?.makeClearBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .menu) { [weak self] in
            self?.sideMenuAction.onNext(.open)
        }
    }
    
    private func bind() {
        view.backgroundColor = themeService.theme.associatedObject.backgroundColor
        tableView.backgroundColor = themeService.theme.associatedObject.backgroundColor
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: tableView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        DatabaseService.shared.poets { [weak self] result in
            switch result {
            case .failure:
                break
            case .success(let users):
                self?.updateUsersAndSelectFirst(users: users)
            }
        }
        
        selectedUser
            .asObservable()
            .map { $0?.identifier }
            .unwrappedOptional()
            .subscribe(onNext: { userID in
                DatabaseService.shared.poems(userID: userID, lastPoem: nil, limit: 10, after: Date().timeRemoved(), completion: { [weak self] result in
                    switch result {
                    case .failure:
                        break
                    case .success(let poems):
                        self?.poems = poems
                        self?.tableView.reloadSections(IndexSet(integer: PoetsSection.poems.rawValue), with: .automatic)
                    }
                })
            }).disposed(by: disposeBag)
    }
    
    private func updateUsersAndSelectFirst(users: [UserModel]) {
        self.users = users
        if let firstUser = users.first {
            selectedUser.accept(firstUser)
        }
        tableView.reloadData(with: .automatic)
    }
}

extension PoetsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PoetsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case PoetsSection.profile.rawValue:
            return ProfileRow.allCases.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightsDictionary[indexPath.cacheKey] ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath.cacheKey] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case PoetsSection.thumnail.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoetsThumbnailContainerCell
            cell.configure(users)
            cell.selectedUser.asObservable()
                .subscribe(onNext: { [weak self] user in
                    self?.selectedUser.accept(user)
                    self?.tableView.reloadSections(IndexSet(integer: PoetsSection.profile.rawValue), with: .fade)
                }).disposed(by: disposeBag)
            return cell
        case PoetsSection.profile.rawValue:
            switch indexPath.row {
            case ProfileRow.main.rawValue:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetProfileCell
                cell.configure(model: selectedUser.value)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetDescriptionCell
                cell.configure(model: selectedUser.value)
                return cell
            }
        case PoetsSection.poems.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoemsOfPoetContainerCell
            cell.configure(poems: poems)
            cell.didSelectItem { [weak self] indexPath in
                guard let poems = self?.poems, poems.count > indexPath.item else {
                    return
                }
                let poem = poems[indexPath.item]
                let controller = PageViewController(type: .specific(poemID: poem.identifier))
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case PoetsSection.profile.rawValue:
            if let cell = tableView.cellForRow(at: indexPath) as? PoetDescriptionCell {
                cell.toggle()
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        default:
            return
        }
    }
}

extension PoetsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            // networking
            refreshControl.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var contentHeight = scrollView.contentSize.height
        
        if #available(iOS 11.0, *) {
            contentHeight += view.safeAreaInsets.bottom
        }
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // load more
        }
    }
}

